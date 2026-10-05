// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizations_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(organizationsRepository)
final organizationsRepositoryProvider = OrganizationsRepositoryProvider._();

final class OrganizationsRepositoryProvider
    extends
        $FunctionalProvider<
          OrganizationsRepository,
          OrganizationsRepository,
          OrganizationsRepository
        >
    with $Provider<OrganizationsRepository> {
  OrganizationsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrganizationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrganizationsRepository create(Ref ref) {
    return organizationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrganizationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrganizationsRepository>(value),
    );
  }
}

String _$organizationsRepositoryHash() =>
    r'837add4d4aa25d1ff5944a70f159d474b237877b';

@ProviderFor(organizationTree)
final organizationTreeProvider = OrganizationTreeProvider._();

final class OrganizationTreeProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrganizationTree>,
          OrganizationTree,
          FutureOr<OrganizationTree>
        >
    with $FutureModifier<OrganizationTree>, $FutureProvider<OrganizationTree> {
  OrganizationTreeProvider._()
    : super(
        from: null,
        argument: null,
        retry: manualRetryOnly,
        name: r'organizationTreeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationTreeHash();

  @$internal
  @override
  $FutureProviderElement<OrganizationTree> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OrganizationTree> create(Ref ref) {
    return organizationTree(ref);
  }
}

String _$organizationTreeHash() => r'd64cb75dedf90dbce5740d2e7baaf9f37dbc5be2';

@ProviderFor(companiesPage)
final companiesPageProvider = CompaniesPageFamily._();

final class CompaniesPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiPage<Company>>,
          ApiPage<Company>,
          FutureOr<ApiPage<Company>>
        >
    with $FutureModifier<ApiPage<Company>>, $FutureProvider<ApiPage<Company>> {
  CompaniesPageProvider._({
    required CompaniesPageFamily super.from,
    required (int, {TableQuery query}) super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'companiesPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$companiesPageHash();

  @override
  String toString() {
    return r'companiesPageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ApiPage<Company>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiPage<Company>> create(Ref ref) {
    final argument = this.argument as (int, {TableQuery query});
    return companiesPage(ref, argument.$1, query: argument.query);
  }

  @override
  bool operator ==(Object other) {
    return other is CompaniesPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$companiesPageHash() => r'22f1f65e454d6e31eefd5c6c331cb90c42ac83ce';

final class CompaniesPageFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ApiPage<Company>>,
          (int, {TableQuery query})
        > {
  CompaniesPageFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'companiesPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CompaniesPageProvider call(
    int pageIndex, {
    TableQuery query = const TableQuery(),
  }) =>
      CompaniesPageProvider._(argument: (pageIndex, query: query), from: this);

  @override
  String toString() => r'companiesPageProvider';
}

@ProviderFor(companyNode)
final companyNodeProvider = CompanyNodeFamily._();

final class CompanyNodeProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrganizationNode>,
          OrganizationNode,
          FutureOr<OrganizationNode>
        >
    with $FutureModifier<OrganizationNode>, $FutureProvider<OrganizationNode> {
  CompanyNodeProvider._({
    required CompanyNodeFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'companyNodeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$companyNodeHash();

  @override
  String toString() {
    return r'companyNodeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<OrganizationNode> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OrganizationNode> create(Ref ref) {
    final argument = this.argument as String;
    return companyNode(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CompanyNodeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$companyNodeHash() => r'85104028be5f5219671d4cbdd699e1e3d8f7967d';

final class CompanyNodeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<OrganizationNode>, String> {
  CompanyNodeFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'companyNodeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CompanyNodeProvider call(String id) =>
      CompanyNodeProvider._(argument: id, from: this);

  @override
  String toString() => r'companyNodeProvider';
}
