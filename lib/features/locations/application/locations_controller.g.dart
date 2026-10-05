// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(locationsRepository)
final locationsRepositoryProvider = LocationsRepositoryProvider._();

final class LocationsRepositoryProvider
    extends
        $FunctionalProvider<
          LocationsRepository,
          LocationsRepository,
          LocationsRepository
        >
    with $Provider<LocationsRepository> {
  LocationsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationsRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocationsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocationsRepository create(Ref ref) {
    return locationsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocationsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocationsRepository>(value),
    );
  }
}

String _$locationsRepositoryHash() =>
    r'be8b75089fdd6150f074125cbbec9dd56f541df7';

@ProviderFor(locationPage)
final locationPageProvider = LocationPageFamily._();

final class LocationPageProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiPage<LocationRecord>>,
          ApiPage<LocationRecord>,
          FutureOr<ApiPage<LocationRecord>>
        >
    with
        $FutureModifier<ApiPage<LocationRecord>>,
        $FutureProvider<ApiPage<LocationRecord>> {
  LocationPageProvider._({
    required LocationPageFamily super.from,
    required (LocationKind, int, {TableQuery query}) super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'locationPageProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$locationPageHash();

  @override
  String toString() {
    return r'locationPageProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ApiPage<LocationRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ApiPage<LocationRecord>> create(Ref ref) {
    final argument = this.argument as (LocationKind, int, {TableQuery query});
    return locationPage(ref, argument.$1, argument.$2, query: argument.query);
  }

  @override
  bool operator ==(Object other) {
    return other is LocationPageProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$locationPageHash() => r'a0c7ea78d9cf8d81602b391d6c16a02fa038e647';

final class LocationPageFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ApiPage<LocationRecord>>,
          (LocationKind, int, {TableQuery query})
        > {
  LocationPageFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'locationPageProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LocationPageProvider call(
    LocationKind kind,
    int pageIndex, {
    TableQuery query = const TableQuery(),
  }) => LocationPageProvider._(
    argument: (kind, pageIndex, query: query),
    from: this,
  );

  @override
  String toString() => r'locationPageProvider';
}

@ProviderFor(locationCatalog)
final locationCatalogProvider = LocationCatalogProvider._();

final class LocationCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocationCatalog>,
          LocationCatalog,
          FutureOr<LocationCatalog>
        >
    with $FutureModifier<LocationCatalog>, $FutureProvider<LocationCatalog> {
  LocationCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: manualRetryOnly,
        name: r'locationCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationCatalogHash();

  @$internal
  @override
  $FutureProviderElement<LocationCatalog> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocationCatalog> create(Ref ref) {
    return locationCatalog(ref);
  }
}

String _$locationCatalogHash() => r'e854d4bfbc01435c4065b71289ac1f9bc0b31284';
