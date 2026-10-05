import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/colors.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../application/persons_controller.dart';
import '../data/person_models.dart';
import 'contacto_urgencia_form.dart';
import 'perfil_medico_form.dart';
import 'person_form.dart';

const _noCapturado = 'No capturado';
final _displayDate = DateFormat.yMMMd('es_MX');

class PersonDetailPage extends ConsumerStatefulWidget {
  const PersonDetailPage({super.key, required this.personaId});
  final String personaId;
  @override
  ConsumerState<PersonDetailPage> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends ConsumerState<PersonDetailPage> {
  int _tab = 0;

  void _refresh() {
    ref.invalidate(personDetailProvider(widget.personaId));
    ref.invalidate(contactosDePersonaProvider(widget.personaId));
    ref.invalidate(perfilMedicoDePersonaProvider(widget.personaId));
  }

  Future<void> _editPersona(Persona persona) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => PersonForm(persona: persona),
    );
    if (saved == true && mounted) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final personAsync = ref.watch(personDetailProvider(widget.personaId));
    final title = switch (personAsync) {
      AsyncData(:final value) when value.fullName.isNotEmpty => value.fullName,
      _ => 'Persona',
    };
    return FeaturePage(
      title: title,
      description: 'Datos generales, contacto de emergencia y perfil médico de esta persona.',
      actions: [
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: _refresh,
        ),
      ],
      child: personAsync.when(
        skipLoadingOnRefresh: false,
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(error: error, onRetry: _refresh),
        data: (persona) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final (index, label) in const [
                  'Datos generales',
                  'Contacto de urgencia',
                  'Perfil médico',
                ].indexed)
                  ChoiceChip(
                    label: Text(label),
                    selected: _tab == index,
                    onSelected: (_) => setState(() => _tab = index),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            switch (_tab) {
              0 => _GeneralTab(
                persona: persona,
                onEdit: () => _editPersona(persona),
              ),
              1 => _ContactosTab(personaId: persona.id),
              _ => _PerfilTab(personaId: persona.id),
            },
          ],
        ),
      ),
    );
  }
}

class _GeneralTab extends ConsumerWidget {
  const _GeneralTab({required this.persona, required this.onEdit});
  final Persona persona;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogs = ref.watch(personCatalogsProvider);
    final canManage = ref.watch(canManageHrProvider);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              Text(
                'Datos generales',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (canManage)
                AppButton(
                  label: 'Editar',
                  icon: Icons.edit_outlined,
                  variant: AppButtonVariant.secondary,
                  onPressed: onEdit,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _field('CURP', persona.curp),
          _field('NSS', persona.nss),
          _field('RFC', persona.rfc),
          _field(
            'Fecha de nacimiento',
            persona.birthDate == null
                ? null
                : _displayDate.format(DateTime.parse(persona.birthDate!)),
          ),
          _field('Estado de nacimiento', persona.birthPlaceState),
          catalogs.when(
            data: (data) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _field(
                  'Género',
                  PersonCatalogs.nameIn(data.generos, persona.gender),
                ),
                _field(
                  'Estado civil',
                  PersonCatalogs.nameIn(
                    data.estadosCiviles,
                    persona.maritalStatus,
                  ),
                ),
                _field(
                  'Escolaridad',
                  PersonCatalogs.nameIn(
                    data.escolaridades,
                    persona.educationLevel,
                  ),
                ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          _field('Tiene hijos', persona.hasChildren ? 'Sí' : 'No'),
          const Divider(height: AppSpacing.xl),
          _field('Correo personal', persona.personalEmail),
          _field('Teléfono', persona.phone),
          const Divider(height: AppSpacing.xl),
          _field('Domicilio', persona.addressLine),
          _field('Código postal', persona.postalCode),
          _field('Ciudad', persona.city),
          _field('Municipio', persona.municipality),
          _field('Estado', persona.state),
        ],
      ),
    );
  }

  Widget _field(String label, String? value) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 180,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value == null || value.trim().isEmpty ? _noCapturado : value,
          ),
        ),
      ],
    ),
  );
}

class _ContactosTab extends ConsumerWidget {
  const _ContactosTab({required this.personaId});
  final String personaId;

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, [
    ContactoUrgencia? contacto,
  ]) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) =>
          ContactoUrgenciaForm(personaId: personaId, contacto: contacto),
    );
    if (saved == true) ref.invalidate(contactosDePersonaProvider(personaId));
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    ContactoUrgencia contacto,
  ) async {
    final deleted = await showConfirmDialog(
      context,
      title: 'Eliminar contacto de urgencia',
      message:
          '¿Eliminar a «${contacto.name}»? Esta acción no se puede deshacer.',
      onConfirm: () =>
          ref.read(personsRepositoryProvider).deleteContacto(contacto.id),
    );
    if (deleted) ref.invalidate(contactosDePersonaProvider(personaId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactos = ref.watch(contactosDePersonaProvider(personaId));
    final canManage = ref.watch(canManageHrProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (canManage) ...[
          Align(
            alignment: Alignment.centerRight,
            child: AppButton(
              label: 'Agregar contacto',
              icon: Icons.add,
              onPressed: () => _edit(context, ref),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        contactos.when(
          skipLoadingOnRefresh: false,
          loading: () => const FeatureLoading(),
          error: (error, _) => FeatureError(
            error: error,
            onRetry: () =>
                ref.invalidate(contactosDePersonaProvider(personaId)),
          ),
          data: (items) => items.isEmpty
              ? const AppCard(
                  child: EmptyState(
                    icon: Icons.contact_phone_outlined,
                    title: 'Sin contactos de urgencia',
                    message:
                        'Todavía no se ha capturado ninguno para esta persona.',
                  ),
                )
              : Column(
                  children: [
                    for (final contacto in items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: AppCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contacto.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Text(
                                      '${contacto.relationship} · ${contacto.phone}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              if (canManage) ...[
                                IconButton(
                                  tooltip: 'Editar a ${contacto.name}',
                                  onPressed: () =>
                                      _edit(context, ref, contacto),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                                IconButton(
                                  tooltip: 'Eliminar a ${contacto.name}',
                                  onPressed: () =>
                                      _delete(context, ref, contacto),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _PerfilTab extends ConsumerWidget {
  const _PerfilTab({required this.personaId});
  final String personaId;

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    List<PersonCatalogEntry> tiposSangre, [
    PerfilMedico? perfil,
  ]) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => PerfilMedicoForm(
        personaId: personaId,
        tiposSangre: tiposSangre,
        perfil: perfil,
      ),
    );
    if (saved == true) ref.invalidate(perfilMedicoDePersonaProvider(personaId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfil = ref.watch(perfilMedicoDePersonaProvider(personaId));
    final catalogs = ref.watch(personCatalogsProvider);
    final canManage = ref.watch(canManageHrProvider);
    return catalogs.when(
      skipLoadingOnRefresh: false,
      loading: () => const FeatureLoading(),
      error: (error, _) => FeatureError(
        error: error,
        onRetry: () => ref.invalidate(personCatalogsProvider),
      ),
      data: (catalogData) => perfil.when(
        skipLoadingOnRefresh: false,
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(
          error: error,
          onRetry: () =>
              ref.invalidate(perfilMedicoDePersonaProvider(personaId)),
        ),
        data: (data) => AppCard(
          child: data == null
              ? EmptyState(
                  icon: Icons.medical_information_outlined,
                  title: 'Sin perfil médico capturado',
                  message: canManage
                      ? 'Agrega el tipo de sangre y las alergias de esta persona.'
                      : 'Todavía no se ha capturado.',
                  action: canManage
                      ? AppButton(
                          label: 'Agregar perfil médico',
                          onPressed: () =>
                              _edit(context, ref, catalogData.tiposSangre),
                        )
                      : null,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.sm,
                      children: [
                        Text(
                          'Perfil médico',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (canManage)
                          AppButton(
                            label: 'Editar',
                            icon: Icons.edit_outlined,
                            variant: AppButtonVariant.secondary,
                            onPressed: () => _edit(
                              context,
                              ref,
                              catalogData.tiposSangre,
                              data,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Tipo de sangre: ${PersonCatalogs.nameIn(catalogData.tiposSangre, data.bloodType) ?? _noCapturado}',
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Alergias: ${data.allergies.trim().isEmpty ? _noCapturado : data.allergies}',
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
