// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sidebar_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SidebarController)
final sidebarControllerProvider = SidebarControllerProvider._();

final class SidebarControllerProvider
    extends $NotifierProvider<SidebarController, bool> {
  SidebarControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sidebarControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sidebarControllerHash();

  @$internal
  @override
  SidebarController create() => SidebarController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$sidebarControllerHash() => r'14dde871376ab17855ae0af7c092fb90e97d839a';

abstract class _$SidebarController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
