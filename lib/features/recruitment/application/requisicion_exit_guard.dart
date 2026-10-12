import 'package:flutter_riverpod/flutter_riverpod.dart';

final requisicionExitGuardProvider = Provider((ref) => RequisicionExitGuard());

class RequisicionExitGuard {
  Future<bool> Function()? confirm;
  Future<bool> mayLeave() async => await confirm?.call() ?? true;
}
