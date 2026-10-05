// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'positions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(positionsRepository)
final positionsRepositoryProvider = PositionsRepositoryProvider._();

final class PositionsRepositoryProvider
    extends
        $FunctionalProvider<
          PositionsRepository,
          PositionsRepository,
          PositionsRepository
        >
    with $Provider<PositionsRepository> {
  PositionsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'positionsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$positionsRepositoryHash();

  @$internal
  @override
  $ProviderElement<PositionsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PositionsRepository create(Ref ref) {
    return positionsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PositionsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PositionsRepository>(value),
    );
  }
}

String _$positionsRepositoryHash() =>
    r'd8f85ef646ac9de17f315fb542c144f7a0f75e11';

@ProviderFor(positionCatalogs)
final positionCatalogsProvider = PositionCatalogsProvider._();

final class PositionCatalogsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PositionCatalogs>,
          PositionCatalogs,
          FutureOr<PositionCatalogs>
        >
    with $FutureModifier<PositionCatalogs>, $FutureProvider<PositionCatalogs> {
  PositionCatalogsProvider._()
    : super(
        from: null,
        argument: null,
        retry: manualRetryOnly,
        name: r'positionCatalogsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$positionCatalogsHash();

  @$internal
  @override
  $FutureProviderElement<PositionCatalogs> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PositionCatalogs> create(Ref ref) {
    return positionCatalogs(ref);
  }
}

String _$positionCatalogsHash() => r'4423ae214c31010251a9f46bde931f15525746da';

@ProviderFor(posicionesPage)
final posicionesPageProvider = PosicionesPageFamily._();

final class PosicionesPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiPage<Posicion>>,
          ApiPage<Posicion>,
          FutureOr<ApiPage<Posicion>>
        >
    with
        $FutureModifier<ApiPage<Posicion>>,
        $FutureProvider<ApiPage<Posicion>> {
  PosicionesPageProvider._({
    required PosicionesPageFamily super.from,
    required (int, {TableQuery query}) super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'posicionesPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$posicionesPageHash();

  @override
  String toString() {
    return r'posicionesPageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ApiPage<Posicion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiPage<Posicion>> create(Ref ref) {
    final argument = this.argument as (int, {TableQuery query});
    return posicionesPage(ref, argument.$1, query: argument.query);
  }

  @override
  bool operator ==(Object other) {
    return other is PosicionesPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$posicionesPageHash() => r'861ba43603ed0c324d90921b7534f768b40df6ef';

final class PosicionesPageFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ApiPage<Posicion>>,
          (int, {TableQuery query})
        > {
  PosicionesPageFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'posicionesPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PosicionesPageProvider call(
    int pageIndex, {
    TableQuery query = const TableQuery(),
  }) =>
      PosicionesPageProvider._(argument: (pageIndex, query: query), from: this);

  @override
  String toString() => r'posicionesPageProvider';
}

@ProviderFor(allPosicionesForPicker)
final allPosicionesForPickerProvider = AllPosicionesForPickerProvider._();

final class AllPosicionesForPickerProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Posicion>>,
          List<Posicion>,
          FutureOr<List<Posicion>>
        >
    with $FutureModifier<List<Posicion>>, $FutureProvider<List<Posicion>> {
  AllPosicionesForPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: manualRetryOnly,
        name: r'allPosicionesForPickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allPosicionesForPickerHash();

  @$internal
  @override
  $FutureProviderElement<List<Posicion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Posicion>> create(Ref ref) {
    return allPosicionesForPicker(ref);
  }
}

String _$allPosicionesForPickerHash() =>
    r'a0532858cde77976028915d37c08d55a38579beb';

@ProviderFor(posicionDetail)
final posicionDetailProvider = PosicionDetailFamily._();

final class PosicionDetailProvider
    extends
        $FunctionalProvider<AsyncValue<Posicion>, Posicion, FutureOr<Posicion>>
    with $FutureModifier<Posicion>, $FutureProvider<Posicion> {
  PosicionDetailProvider._({
    required PosicionDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'posicionDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$posicionDetailHash();

  @override
  String toString() {
    return r'posicionDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Posicion> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Posicion> create(Ref ref) {
    final argument = this.argument as String;
    return posicionDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PosicionDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$posicionDetailHash() => r'c5e8e8e64f9ee115de9906d709624b2b4b33075d';

final class PosicionDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Posicion>, String> {
  PosicionDetailFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'posicionDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PosicionDetailProvider call(String id) =>
      PosicionDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'posicionDetailProvider';
}
