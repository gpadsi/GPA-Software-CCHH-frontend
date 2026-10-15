import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/form_dialog.dart';
import '../application/organizations_controller.dart';
import '../data/organization_models.dart';
import '../data/organizations_repository.dart';

/// Alta de una empresa nueva (sin [company]) o edición de una existente.
///
/// El nombre que se ve en las listas es el de su nodo organizacional, así que
/// al editar se carga ese nodo para poder renombrarlo desde aquí. Los datos
/// legales que GPA aún no confirma pueden quedar vacíos: se guardan como
/// "pendiente".
class CompanyForm extends ConsumerStatefulWidget {
  const CompanyForm({super.key, this.company});
  final Company? company;

  @override
  ConsumerState<CompanyForm> createState() => _CompanyFormState();
}

class _CompanyFormState extends ConsumerState<CompanyForm>
    with FormChangeTracking {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _code = TextEditingController();
  late final _legalName = TextEditingController(
    text: widget.company?.legalName,
  );
  late final _rfc = TextEditingController(text: widget.company?.rfc);
  late final _registration = TextEditingController(
    text: widget.company?.employerRegistration,
  );
  // El nombre se precarga una sola vez, cuando llega el nodo.
  bool _nameLoaded = false;
  String _initialName = '';
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    watchChanges([_name, _code, _legalName, _rfc, _registration]);
  }

  @override
  bool get hasChanges {
    final current = widget.company;
    return _name.text != _initialName ||
        _code.text.isNotEmpty ||
        _legalName.text != (current?.legalName ?? '') ||
        _rfc.text != (current?.rfc ?? '') ||
        _registration.text != (current?.employerRegistration ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    _legalName.dispose();
    _rfc.dispose();
    _registration.dispose();
    super.dispose();
  }

  String? _validate(String? value, int limit, {bool required = true}) {
    final text = value?.trim() ?? '';
    if (required && text.isEmpty) return 'Este dato es obligatorio.';
    if (text.length > limit) return 'Usa como máximo $limit caracteres.';
    return null;
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final current = widget.company;
    final repository = ref.read(organizationsRepositoryProvider);
    final data = Company(
      id: current?.id ?? '',
      organizationNode: current?.organizationNode ?? '',
      legalName: _legalName.text,
      rfc: _rfc.text,
      employerRegistration: _registration.text,
    );
    try {
      if (current == null) {
        final tree = ref.read(organizationTreeProvider).requireValue;
        final empresa = tree.levels.firstWhere((level) => level.numero == 1);
        await repository.createCompany(
          empresaLevel: empresa.id,
          code: _code.text.trim(),
          name: _name.text.trim(),
          company: data,
        );
      } else {
        final node = ref
            .read(companyNodeProvider(current.organizationNode))
            .requireValue;
        await repository.updateCompany(
          data,
          node: node,
          name: _name.text.trim(),
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = organizationMutationError(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final creating = widget.company == null;
    // Alta: hace falta el nivel "Empresa". Edición: el nodo para su nombre.
    final ready = creating
        ? ref.watch(organizationTreeProvider).whenData((_) => null)
        : ref
              .watch(companyNodeProvider(widget.company!.organizationNode))
              .whenData((node) {
                if (!_nameLoaded) {
                  _initialName = node.name;
                  _name.text = node.name;
                  _nameLoaded = true;
                }
                return null;
              });
    return AppFormDialog(
      title: creating ? 'Agregar empresa' : 'Editar empresa',
      subtitle: creating
          ? 'Se agrega como empresa de Grupo GPA en el organigrama.'
          : null,
      dirty: hasChanges,
      busy: _busy,
      error: _error,
      canSave: ready.hasValue,
      onSave: _save,
      child: ready.when(
        data: (_) => _fields(creating),
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(
          error: error,
          onRetry: () {
            ref.invalidate(organizationTreeProvider);
            if (!creating) {
              ref.invalidate(
                companyNodeProvider(widget.company!.organizationNode),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _fields(bool creating) => Form(
    key: _form,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppFormSection(
          first: true,
          title: 'Empresa',
          description:
              'El nombre con el que aparece en listas y en el organigrama.',
          children: [
            // Al editar el código ya no cambia: el nombre ocupa todo el ancho.
            if (creating)
              AppFieldGrid(
                minTwoColumnWidth: 480,
                children: [
                  _nameField(creating),
                  AppTextField(
                    label: 'Código',
                    hint: 'Ej. GPA-AZM',
                    controller: _code,
                    enabled: !_busy,
                    validator: (value) => _validate(value, 50),
                  ),
                ],
              )
            else
              _nameField(creating),
          ],
        ),
        AppFormSection(
          title: 'Datos legales',
          description: 'Los que GPA aún no confirme pueden quedar vacíos; se muestran como pendientes.',
          children: [
            AppTextField(
              label: 'Razón social (opcional)',
              controller: _legalName,
              enabled: !_busy,
              validator: (value) => _validate(value, 255, required: false),
            ),
            AppFieldGrid(
              minTwoColumnWidth: 480,
              children: [
                AppTextField(
                  label: 'RFC (opcional)',
                  controller: _rfc,
                  enabled: !_busy,
                  validator: (value) => _validate(value, 20, required: false),
                ),
                AppTextField(
                  label: 'Registro patronal (opcional)',
                  controller: _registration,
                  enabled: !_busy,
                  validator: (value) => _validate(value, 100, required: false),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  Widget _nameField(bool creating) => AppTextField(
    label: 'Nombre de la empresa',
    controller: _name,
    enabled: !_busy,
    autofocus: creating,
    validator: (value) => _validate(value, 200),
  );
}
