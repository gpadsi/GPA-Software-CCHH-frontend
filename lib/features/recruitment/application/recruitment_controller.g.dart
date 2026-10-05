// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruitment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recruitmentRepository)
final recruitmentRepositoryProvider = RecruitmentRepositoryProvider._();

final class RecruitmentRepositoryProvider
    extends
        $FunctionalProvider<
          RecruitmentRepository,
          RecruitmentRepository,
          RecruitmentRepository
        >
    with $Provider<RecruitmentRepository> {
  RecruitmentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recruitmentRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recruitmentRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecruitmentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecruitmentRepository create(Ref ref) {
    return recruitmentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecruitmentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecruitmentRepository>(value),
    );
  }
}

String _$recruitmentRepositoryHash() =>
    r'9e79f8c51d6db0aa647cd129fe161d0725445f49';

@ProviderFor(requisicionCatalogs)
final requisicionCatalogsProvider = RequisicionCatalogsProvider._();

final class RequisicionCatalogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<RequisicionCatalogs>,
          RequisicionCatalogs,
          FutureOr<RequisicionCatalogs>
        >
    with
        $FutureModifier<RequisicionCatalogs>,
        $FutureProvider<RequisicionCatalogs> {
  RequisicionCatalogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: manualRetryOnly,
        name: r'requisicionCatalogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requisicionCatalogsHash();

  @$internal
  @override
  $FutureProviderElement<RequisicionCatalogs> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RequisicionCatalogs> create(Ref ref) {
    return requisicionCatalogs(ref);
  }
}

String _$requisicionCatalogsHash() =>
    r'848fa90cfbad16c75b3ce885b364318c0aebc1c6';

@ProviderFor(descriptivoCatalogs)
final descriptivoCatalogsProvider = DescriptivoCatalogsProvider._();

final class DescriptivoCatalogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<DescriptivoCatalogs>,
          DescriptivoCatalogs,
          FutureOr<DescriptivoCatalogs>
        >
    with
        $FutureModifier<DescriptivoCatalogs>,
        $FutureProvider<DescriptivoCatalogs> {
  DescriptivoCatalogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: manualRetryOnly,
        name: r'descriptivoCatalogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$descriptivoCatalogsHash();

  @$internal
  @override
  $FutureProviderElement<DescriptivoCatalogs> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DescriptivoCatalogs> create(Ref ref) {
    return descriptivoCatalogs(ref);
  }
}

String _$descriptivoCatalogsHash() =>
    r'3d4e5a6b083842871268762a703c08d027572585';

@ProviderFor(requisicionesPage)
final requisicionesPageProvider = RequisicionesPageFamily._();

final class RequisicionesPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiPage<Requisicion>>,
          ApiPage<Requisicion>,
          FutureOr<ApiPage<Requisicion>>
        >
    with
        $FutureModifier<ApiPage<Requisicion>>,
        $FutureProvider<ApiPage<Requisicion>> {
  RequisicionesPageProvider._({
    required RequisicionesPageFamily super.from,
    required (int, {TableQuery query}) super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'requisicionesPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$requisicionesPageHash();

  @override
  String toString() {
    return r'requisicionesPageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ApiPage<Requisicion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiPage<Requisicion>> create(Ref ref) {
    final argument = this.argument as (int, {TableQuery query});
    return requisicionesPage(ref, argument.$1, query: argument.query);
  }

  @override
  bool operator ==(Object other) {
    return other is RequisicionesPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$requisicionesPageHash() => r'4e959e802f6920ad1decff234f8f176b02fac1d7';

final class RequisicionesPageFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ApiPage<Requisicion>>,
          (int, {TableQuery query})
        > {
  RequisicionesPageFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'requisicionesPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RequisicionesPageProvider call(
    int pageIndex, {
    TableQuery query = const TableQuery(),
  }) => RequisicionesPageProvider._(
    argument: (pageIndex, query: query),
    from: this,
  );

  @override
  String toString() => r'requisicionesPageProvider';
}

@ProviderFor(requisicionDetail)
final requisicionDetailProvider = RequisicionDetailFamily._();

final class RequisicionDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Requisicion>,
          Requisicion,
          FutureOr<Requisicion>
        >
    with $FutureModifier<Requisicion>, $FutureProvider<Requisicion> {
  RequisicionDetailProvider._({
    required RequisicionDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'requisicionDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$requisicionDetailHash();

  @override
  String toString() {
    return r'requisicionDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Requisicion> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Requisicion> create(Ref ref) {
    final argument = this.argument as String;
    return requisicionDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RequisicionDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$requisicionDetailHash() => r'd31bb44eaf6f60b8e490c4ea82ebf1a4b7a7d287';

final class RequisicionDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Requisicion>, String> {
  RequisicionDetailFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'requisicionDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RequisicionDetailProvider call(String id) =>
      RequisicionDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'requisicionDetailProvider';
}

@ProviderFor(descriptivosPage)
final descriptivosPageProvider = DescriptivosPageFamily._();

final class DescriptivosPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiPage<Descriptivo>>,
          ApiPage<Descriptivo>,
          FutureOr<ApiPage<Descriptivo>>
        >
    with
        $FutureModifier<ApiPage<Descriptivo>>,
        $FutureProvider<ApiPage<Descriptivo>> {
  DescriptivosPageProvider._({
    required DescriptivosPageFamily super.from,
    required (int, {TableQuery query}) super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'descriptivosPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$descriptivosPageHash();

  @override
  String toString() {
    return r'descriptivosPageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ApiPage<Descriptivo>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiPage<Descriptivo>> create(Ref ref) {
    final argument = this.argument as (int, {TableQuery query});
    return descriptivosPage(ref, argument.$1, query: argument.query);
  }

  @override
  bool operator ==(Object other) {
    return other is DescriptivosPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$descriptivosPageHash() => r'd4a597bd9582adddfc29434dd98a8bb45aafcd55';

final class DescriptivosPageFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ApiPage<Descriptivo>>,
          (int, {TableQuery query})
        > {
  DescriptivosPageFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'descriptivosPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DescriptivosPageProvider call(
    int pageIndex, {
    TableQuery query = const TableQuery(),
  }) => DescriptivosPageProvider._(
    argument: (pageIndex, query: query),
    from: this,
  );

  @override
  String toString() => r'descriptivosPageProvider';
}

@ProviderFor(descriptivoDetail)
final descriptivoDetailProvider = DescriptivoDetailFamily._();

final class DescriptivoDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Descriptivo>,
          Descriptivo,
          FutureOr<Descriptivo>
        >
    with $FutureModifier<Descriptivo>, $FutureProvider<Descriptivo> {
  DescriptivoDetailProvider._({
    required DescriptivoDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'descriptivoDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$descriptivoDetailHash();

  @override
  String toString() {
    return r'descriptivoDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Descriptivo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Descriptivo> create(Ref ref) {
    final argument = this.argument as String;
    return descriptivoDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DescriptivoDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$descriptivoDetailHash() => r'3827e54845a92846d8e204169fd9acc9e0157358';

final class DescriptivoDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Descriptivo>, String> {
  DescriptivoDetailFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'descriptivoDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DescriptivoDetailProvider call(String id) =>
      DescriptivoDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'descriptivoDetailProvider';
}
