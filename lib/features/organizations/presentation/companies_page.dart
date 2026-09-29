import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../application/organizations_controller.dart';
import 'organization_tree_page.dart';

class CompaniesPage extends ConsumerStatefulWidget {
  const CompaniesPage({super.key});
  @override
  ConsumerState<CompaniesPage> createState() => _CompaniesPageState();
}

class _CompaniesPageState extends ConsumerState<CompaniesPage> {
  int _page = 0;
  void _refresh() {
    ref.invalidate(companiesPageProvider);
    ref.invalidate(companyNodeProvider);
  }

  @override
  Widget build(BuildContext context) {
    final companies = ref.watch(companiesPageProvider(_page));
    return FeaturePage(
      title: 'Empresas',
      description: 'Datos corporativos de las empresas de Grupo GPA. Los datos aún no confirmados aparecen como Pendiente.',
      tabs: const FeatureTabs(
        current: '/organizacion/empresas',
        destinations: organizationTabs,
      ),
      actions: [
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: _refresh,
        ),
      ],
      child: companies.when(
        skipLoadingOnRefresh: false,
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(error: error, onRetry: _refresh),
        data: (data) => AppDataTable(
          columns: const [
            DataColumn(label: Text('Empresa')),
            DataColumn(label: Text('Razón social')),
            DataColumn(label: Text('RFC')),
            DataColumn(label: Text('Registro patronal')),
          ],
          rows: [
            for (final company in data.results)
              DataRow(
                cells: [
                  DataCell(_CompanyName(id: company.organizationNode)),
                  DataCell(tableText(company.legalName)),
                  DataCell(tableText(company.rfc)),
                  DataCell(tableText(company.employerRegistration)),
                ],
              ),
          ],
          totalCount: data.count,
          pageIndex: _page,
          pageSize: 25,
          onPageChanged: (page) => setState(() => _page = page),
        ),
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
