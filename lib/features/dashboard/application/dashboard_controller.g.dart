// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardCount)
final dashboardCountProvider = DashboardCountFamily._();

final class DashboardCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  DashboardCountProvider._({
    required DashboardCountFamily super.from,
    required DashboardMetric super.argument,
  }) : super(
         retry: null,
         name: r'dashboardCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dashboardCountHash();

  @override
  String toString() {
    return r'dashboardCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as DashboardMetric;
    return dashboardCount(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DashboardCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dashboardCountHash() => r'4847ae7de621b6f823926ddc82a19353b857eb4e';

final class DashboardCountFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, DashboardMetric> {
  DashboardCountFamily._()
    : super(
        retry: null,
        name: r'dashboardCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DashboardCountProvider call(DashboardMetric metric) =>
      DashboardCountProvider._(argument: metric, from: this);

  @override
  String toString() => r'dashboardCountProvider';
}
