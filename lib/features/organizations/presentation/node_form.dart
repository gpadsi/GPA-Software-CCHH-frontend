import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_panel.dart';
import '../application/organizations_controller.dart';
import '../data/organization_models.dart';
import '../data/organizations_repository.dart';

/// Los niveles en los que puede crearse un nodo hijo de [parent]: los de
/// número mayor al del padre, y su mismo nivel solo si ese nivel puede
/// anidarse a sí mismo (ej. Unidad de Negocio). Es la misma regla que valida
/// el servidor; aquí solo evita ofrecer opciones que seguro rechazaría.
List<OrganizationLevel> childLevelsFor(
  List<OrganizationLevel> levels,
  OrganizationNode parent,
) {
  final parentLevel = levels.where((level) => level.id == parent.level);
  if (parentLevel.isEmpty) return const [];
  final own = parentLevel.first;
  return [
    for (final level in levels)
      if (level.numero > own.numero ||
          (level.id == own.id && own.allowsRecursiveNesting))
        level,
  ]..sort((a, b) => a.numero.compareTo(b.numero));
}

/// Alta de un nodo hijo (con [parent]) o edición de uno existente (con [node]).
/// Al editar solo cambian nombre, código y vigencia: mover un nodo a otro
/// padre o de nivel no se ofrece aquí.
class NodeForm extends ConsumerStatefulWidget {
  const NodeForm({super.key, required this.tree, this.node, this.parent})
    : assert(node != null || parent != null);
  final OrganizationTree tree;
  final OrganizationNode? node;
  final OrganizationNode? parent;

  @override
  ConsumerState<NodeForm> createState() => _NodeFormState();
}

class _NodeFormState extends ConsumerState<NodeForm> {
  final _form = GlobalKey<FormState>();
  late final _code = TextEditingController(text: widget.node?.code);
  late final _name = TextEditingController(text: widget.node?.name);
  late bool _active = widget.node?.isActive ?? true;
  late final List<OrganizationLevel> _options = widget.node != null
      ? const []
      : childLevelsFor(widget.tree.levels, widget.parent!);
  late int? _level = widget.node?.level ?? _defaultLevel();
  bool _busy = false;
  String? _error;

  int? _defaultLevel() {
    if (_options.isEmpty) return null;
    final parentLevel = widget.parent!.level;
    // Si el padre se anida a sí mismo (Unidad de Negocio) lo normal es otro
    // nodo de su mismo nivel; si no, el nivel inmediato siguiente.
    for (final level in _options) {
      if (level.id == parentLevel) return level.id;
    }
    return _options.first.id;
  }

  OrganizationNode? get _parent {
    final parentId = widget.parent?.id ?? widget.node?.parent;
    if (parentId == null) return null;
    for (final node in widget.tree.nodes) {
      if (node.id == parentId) return node;
    }
    return null;
  }

  String _levelName(int id) {
    for (final level in widget.tree.levels) {
      if (level.id == id) return level.name;
    }
    return 'Nivel no disponible';
  }

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    super.dispose();
  }

  String? _validate(String? value, int limit) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Este dato es obligatorio.';
    if (text.length > limit) return 'Usa como máximo $limit caracteres.';
    return null;
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final current = widget.node;
    try {
      await ref
          .read(organizationsRepositoryProvider)
          .saveNode(
            OrganizationNode(
              id: current?.id ?? '',
              tenant: current?.tenant ?? 0,
              level: _level!,
              parent: widget.parent?.id ?? current?.parent,
              code: _code.text.trim(),
              name: _name.text.trim(),
              isActive: _active,
            ),
            creating: current == null,
          );
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
    final creating = widget.node == null;
    final parent = _parent;
    return AppFormPanel(
      title: creating ? 'Agregar unidad' : 'Editar unidad',
      subtitle: creating ? 'Dentro de ${widget.parent!.name}' : null,
      busy: _busy,
      error: _error,
      canSave: !creating || _options.isNotEmpty,
      onSave: _save,
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (creating && _options.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  'Este nodo ya está en el último nivel y no admite unidades dentro.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            AppTextField(
              label: 'Nombre',
              controller: _name,
              enabled: !_busy,
              validator: (value) => _validate(value, 200),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Código',
              hint: 'Ej. GPA-AZM-01',
              controller: _code,
              enabled: !_busy,
              validator: (value) => _validate(value, 50),
            ),
            const SizedBox(height: AppSpacing.lg),
            if (creating)
              DropdownButtonFormField<int>(
                key: ValueKey('nivel:$_level'),
                initialValue: _level,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Nivel'),
                items: [
                  for (final level in _options)
                    DropdownMenuItem(value: level.id, child: Text(level.name)),
                ],
                onChanged: _busy
                    ? null
                    : (value) => setState(() => _level = value),
                validator: (value) =>
                    value == null ? 'Selecciona un nivel.' : null,
              )
            else
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Nivel'),
                child: Text(_levelName(widget.node!.level)),
              ),
            if (!creating && parent != null) ...[
              const SizedBox(height: AppSpacing.lg),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Dentro de'),
                child: Text(parent.name),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Activo'),
              subtitle: Text(
                'Desmárcalo al cerrar un departamento o unidad.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: _active,
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _active = value),
            ),
          ],
        ),
      ),
    );
  }
}
