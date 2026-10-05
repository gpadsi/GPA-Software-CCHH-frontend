// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedules_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(schedulesRepository)
final schedulesRepositoryProvider = SchedulesRepositoryProvider._();

final class SchedulesRepositoryProvider
    extends
        $FunctionalProvider<
          SchedulesRepository,
          SchedulesRepository,
          SchedulesRepository
        >
    with $Provider<SchedulesRepository> {
  SchedulesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'schedulesRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$schedulesRepositoryHash();

  @$internal
  @override
  $ProviderElement<SchedulesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SchedulesRepository create(Ref ref) {
    return schedulesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SchedulesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SchedulesRepository>(value),
    );
  }
}

String _$schedulesRepositoryHash() =>
    r'0e47a52f94176d101f35bd2fd34e5620c4ccc5c8';

@ProviderFor(catorcenasPage)
final catorcenasPageProvider = CatorcenasPageFamily._();

final class CatorcenasPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiPage<Catorcena>>,
          ApiPage<Catorcena>,
          FutureOr<ApiPage<Catorcena>>
        >
    with
        $FutureModifier<ApiPage<Catorcena>>,
        $FutureProvider<ApiPage<Catorcena>> {
  CatorcenasPageProvider._({
    required CatorcenasPageFamily super.from,
    required (int, {TableQuery query}) super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'catorcenasPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$catorcenasPageHash();

  @override
  String toString() {
    return r'catorcenasPageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ApiPage<Catorcena>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiPage<Catorcena>> create(Ref ref) {
    final argument = this.argument as (int, {TableQuery query});
    return catorcenasPage(ref, argument.$1, query: argument.query);
  }

  @override
  bool operator ==(Object other) {
    return other is CatorcenasPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$catorcenasPageHash() => r'411a00f75b842cdef26bd425f65b7d4303be3959';

final class CatorcenasPageFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ApiPage<Catorcena>>,
          (int, {TableQuery query})
        > {
  CatorcenasPageFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'catorcenasPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  CatorcenasPageProvider call(
    int pageIndex, {
    TableQuery query = const TableQuery(),
  }) =>
      CatorcenasPageProvider._(argument: (pageIndex, query: query), from: this);

  @override
  String toString() => r'catorcenasPageProvider';
}

@ProviderFor(allCatorcenas)
final allCatorcenasProvider = AllCatorcenasProvider._();

final class AllCatorcenasProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Catorcena>>,
          List<Catorcena>,
          FutureOr<List<Catorcena>>
        >
    with $FutureModifier<List<Catorcena>>, $FutureProvider<List<Catorcena>> {
  AllCatorcenasProvider._()
    : super(
        from: null,
        argument: null,
        retry: manualRetryOnly,
        name: r'allCatorcenasProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allCatorcenasHash();

  @$internal
  @override
  $FutureProviderElement<List<Catorcena>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Catorcena>> create(Ref ref) {
    return allCatorcenas(ref);
  }
}

String _$allCatorcenasHash() => r'b51f7a614d39123497b52efe68e7bb939cb56a9d';

@ProviderFor(tiposHorarioCatalog)
final tiposHorarioCatalogProvider = TiposHorarioCatalogProvider._();

final class TiposHorarioCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TipoHorarioRef>>,
          List<TipoHorarioRef>,
          FutureOr<List<TipoHorarioRef>>
        >
    with
        $FutureModifier<List<TipoHorarioRef>>,
        $FutureProvider<List<TipoHorarioRef>> {
  TiposHorarioCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: manualRetryOnly,
        name: r'tiposHorarioCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tiposHorarioCatalogHash();

  @$internal
  @override
  $FutureProviderElement<List<TipoHorarioRef>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TipoHorarioRef>> create(Ref ref) {
    return tiposHorarioCatalog(ref);
  }
}

String _$tiposHorarioCatalogHash() =>
    r'60a360f8b65947be6a11172958d0e9e4b62e4a98';

@ProviderFor(areasCatalog)
final areasCatalogProvider = AreasCatalogProvider._();

final class AreasCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AreaRef>>,
          List<AreaRef>,
          FutureOr<List<AreaRef>>
        >
    with $FutureModifier<List<AreaRef>>, $FutureProvider<List<AreaRef>> {
  AreasCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: manualRetryOnly,
        name: r'areasCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$areasCatalogHash();

  @$internal
  @override
  $FutureProviderElement<List<AreaRef>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AreaRef>> create(Ref ref) {
    return areasCatalog(ref);
  }
}

String _$areasCatalogHash() => r'45c171e106db10d8dffddec12b0aa641edc08bc8';

@ProviderFor(allEmpleadosForPicker)
final allEmpleadosForPickerProvider = AllEmpleadosForPickerProvider._();

final class AllEmpleadosForPickerProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<EmpleadoRef>>,
          List<EmpleadoRef>,
          FutureOr<List<EmpleadoRef>>
        >
    with
        $FutureModifier<List<EmpleadoRef>>,
        $FutureProvider<List<EmpleadoRef>> {
  AllEmpleadosForPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: manualRetryOnly,
        name: r'allEmpleadosForPickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allEmpleadosForPickerHash();

  @$internal
  @override
  $FutureProviderElement<List<EmpleadoRef>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<EmpleadoRef>> create(Ref ref) {
    return allEmpleadosForPicker(ref);
  }
}

String _$allEmpleadosForPickerHash() =>
    r'd3a68036721eeb3cc60f36bc3ed314f80282387b';

@ProviderFor(empleadoRef)
final empleadoRefProvider = EmpleadoRefFamily._();

final class EmpleadoRefProvider
    extends
        $FunctionalProvider<
          AsyncValue<EmpleadoRef>,
          EmpleadoRef,
          FutureOr<EmpleadoRef>
        >
    with $FutureModifier<EmpleadoRef>, $FutureProvider<EmpleadoRef> {
  EmpleadoRefProvider._({
    required EmpleadoRefFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'empleadoRefProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$empleadoRefHash();

  @override
  String toString() {
    return r'empleadoRefProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<EmpleadoRef> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<EmpleadoRef> create(Ref ref) {
    final argument = this.argument as String;
    return empleadoRef(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is EmpleadoRefProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$empleadoRefHash() => r'b4820564edbac3d1d0ad9e6cceb0c467240b206a';

final class EmpleadoRefFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<EmpleadoRef>, String> {
  EmpleadoRefFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'empleadoRefProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  EmpleadoRefProvider call(String id) =>
      EmpleadoRefProvider._(argument: id, from: this);

  @override
  String toString() => r'empleadoRefProvider';
}

@ProviderFor(asignacionesHorarioPage)
final asignacionesHorarioPageProvider = AsignacionesHorarioPageFamily._();

final class AsignacionesHorarioPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiPage<AsignacionHorario>>,
          ApiPage<AsignacionHorario>,
          FutureOr<ApiPage<AsignacionHorario>>
        >
    with
        $FutureModifier<ApiPage<AsignacionHorario>>,
        $FutureProvider<ApiPage<AsignacionHorario>> {
  AsignacionesHorarioPageProvider._({
    required AsignacionesHorarioPageFamily super.from,
    required (int, {TableQuery query}) super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'asignacionesHorarioPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$asignacionesHorarioPageHash();

  @override
  String toString() {
    return r'asignacionesHorarioPageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ApiPage<AsignacionHorario>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiPage<AsignacionHorario>> create(Ref ref) {
    final argument = this.argument as (int, {TableQuery query});
    return asignacionesHorarioPage(ref, argument.$1, query: argument.query);
  }

  @override
  bool operator ==(Object other) {
    return other is AsignacionesHorarioPageProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$asignacionesHorarioPageHash() =>
    r'2f22c664bb9e4e4ca9e58f2dcb790a97a32f0b83';

final class AsignacionesHorarioPageFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ApiPage<AsignacionHorario>>,
          (int, {TableQuery query})
        > {
  AsignacionesHorarioPageFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'asignacionesHorarioPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AsignacionesHorarioPageProvider call(
    int pageIndex, {
    TableQuery query = const TableQuery(),
  }) => AsignacionesHorarioPageProvider._(
    argument: (pageIndex, query: query),
    from: this,
  );

  @override
  String toString() => r'asignacionesHorarioPageProvider';
}

@ProviderFor(asignacionesUbicacionPage)
final asignacionesUbicacionPageProvider = AsignacionesUbicacionPageFamily._();

final class AsignacionesUbicacionPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiPage<AsignacionUbicacion>>,
          ApiPage<AsignacionUbicacion>,
          FutureOr<ApiPage<AsignacionUbicacion>>
        >
    with
        $FutureModifier<ApiPage<AsignacionUbicacion>>,
        $FutureProvider<ApiPage<AsignacionUbicacion>> {
  AsignacionesUbicacionPageProvider._({
    required AsignacionesUbicacionPageFamily super.from,
    required (int, {TableQuery query}) super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'asignacionesUbicacionPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$asignacionesUbicacionPageHash();

  @override
  String toString() {
    return r'asignacionesUbicacionPageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ApiPage<AsignacionUbicacion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiPage<AsignacionUbicacion>> create(Ref ref) {
    final argument = this.argument as (int, {TableQuery query});
    return asignacionesUbicacionPage(ref, argument.$1, query: argument.query);
  }

  @override
  bool operator ==(Object other) {
    return other is AsignacionesUbicacionPageProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$asignacionesUbicacionPageHash() =>
    r'3235e9b69407f9f6a7a3478a8d8b0230a47eb52c';

final class AsignacionesUbicacionPageFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ApiPage<AsignacionUbicacion>>,
          (int, {TableQuery query})
        > {
  AsignacionesUbicacionPageFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'asignacionesUbicacionPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AsignacionesUbicacionPageProvider call(
    int pageIndex, {
    TableQuery query = const TableQuery(),
  }) => AsignacionesUbicacionPageProvider._(
    argument: (pageIndex, query: query),
    from: this,
  );

  @override
  String toString() => r'asignacionesUbicacionPageProvider';
}
