import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_row_actions.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/network/table_query.dart';
import '../../../core/widgets/app_fade_switcher.dart';
import '../../../core/widgets/app_table_toolbar.dart';
import '../../../core/design_system/spacing.dart';
import '../application/organizations_controller.dart';
import '../data/organization_models.dart';
import 'company_form.dart';
import 'organization_tree_page.dart';

class CompaniesPage extends ConsumerStatefulWidget {
  const CompaniesPage({super.key});
  @override
  ConsumerState<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends ConsumerState<CompaniesPage> {
  int _page = 0;
  TableQuery _query = const TableQuery();

  // Buscar u ordenar vuelve a la primera pagina: la pagina 3 de otra
  // consulta puede no existir.
  void _search(String value) => setState(() {
    _query = _query.copyWith(search: value);
    _page = 0;
  });

  void _order(String ordering) => setState(() {
    _query = _query.copyWith(ordering: ordering);
    _page = 0;
  });
  void _refresh() {
    ref.invalidate(companiesPageProvider);
    ref.invalidate(companyNodeProvider);
    ref.invalidate(organizationTreeProvider);
  }

  Future<void> _edit([Company? company]) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => CompanyForm(company: company),
    );
    if (saved == true && mounted) {
      _refresh();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Empresa guardada.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final companies = ref.watch(companiesPageProvider(_page, query: _query));
    final canManage = ref.watch(canManageHrProvider);
    return FeaturePage(
      title: 'Empresas',
      description: 'Datos corporativos de las empresas de Grupo GPA. Los datos aún no confirmados aparecen como Pendiente.',
      tabs: const FeatureTabs(
        current: '/organizacion/empresas',
        destinations: organizationTabs,
      ),
      actions: [
        if (canManage)
          AppButton(
            label: 'Agregar empresa',
            icon: Icons.add,
            onPressed: _edit,
          ),
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: _refresh,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTableToolbar(
            hint: 'Buscar por empresa, razón social o RFC',
            value: _query.search,
            onSearch: _search,
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeSwitcher(
            child: companies.when(
              skipLoadingOnRefresh: false,
              loading: () => const FeatureLoading(),
              error: (error, _) =>
                  FeatureError(error: error, onRetry: _refresh),
              data: (data) => AppDataTable(
                columns: [
                  const DataColumn(label: Text('Empresa')),
                  const DataColumn(label: Text('Razón social')),
                  const DataColumn(label: Text('RFC')),
                  const DataColumn(label: Text('Registro patronal')),
                  if (canManage) const DataColumn(label: Text('Acciones')),
                ],
                rows: [
                  for (final company in data.results)
                    DataRow(
                      onSelectChanged: canManage ? (_) => _edit(company) : null,
                      cells: [
                        DataCell(_CompanyName(id: company.organizationNode)),
                        DataCell(tableText(company.legalName)),
                        DataCell(tableText(company.rfc)),
                        DataCell(tableText(company.employerRegistration)),
                        if (canManage)
                          DataCell(
                            _CompanyActions(
                              company: company,
                              onEdit: () => _edit(company),
                            ),
                          ),
                      ],
                    ),
                ],
                sortFields: [
                  'organization_node__name',
                  'legal_name',
                  'rfc',
                  'employer_registration',
                  if (canManage) null,
                ],
                ordering: _query.ordering,
                onOrderingChanged: _order,
                searchTerm: _query.search,
                onClearSearch: () => _search(''),
                totalCount: data.count,
                pageIndex: _page,
                pageSize: 25,
                onPageChanged: (page) => setState(() => _page = page),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyName extends ConsumerWidget {
  const _CompanyName({required this.id});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(companyNodeProvider(id))
      .when(
        data: (node) => tableText(node.name),
        loading: () => const LoadingSkeleton(width: 160),
        error: (_, _) => TextButton(
          onPressed: () => ref.invalidate(companyNodeProvider(id)),
          child: tableText('Nombre no disponible. Reintentar'),
        ),
      );
}

/// Acciones de la fila; el nombre de la empresa llega con su nodo, así que el
/// tooltip lo usa en cuanto esté disponible.
class _CompanyActions extends ConsumerWidget {
  const _CompanyActions({required this.company, required this.onEdit});
  final Company company;
  final VoidCallback onEdit;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(companyNodeProvider(company.organizationNode)).value;
    return AppRowActions(subject: name?.name ?? 'empresa', onEdit: onEdit);
  }
}
