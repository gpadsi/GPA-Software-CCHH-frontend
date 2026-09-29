import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sidebar_controller.g.dart';

@Riverpod(keepAlive: true)
class SidebarController extends _$SidebarController {
  @override
  bool build() => false;

  void toggle() => state = !state;
}
