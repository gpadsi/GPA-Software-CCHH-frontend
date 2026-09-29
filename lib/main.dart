import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'core/design_system/theme.dart';
import 'core/auth/auth_models.dart';
import 'core/auth/session_controller.dart';
import 'core/localization/app_localizations.dart';
import 'core/routing/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  Intl.defaultLocale = 'es_MX';
  runApp(const ProviderScope(child: CapitalHumanoApp()));
}

class CapitalHumanoApp extends ConsumerStatefulWidget {
  const CapitalHumanoApp({super.key, this.router});
  final GoRouter? router;

  @override
  ConsumerState<CapitalHumanoApp> createState() => _CapitalHumanoAppState();
}

class _CapitalHumanoAppState extends ConsumerState<CapitalHumanoApp> {
  late final ValueNotifier<SessionState> _session;
  late final GoRouter _router =
      widget.router ??
      createAppRouter(
        session: () => _session.value,
        refreshListenable: _session,
      );
  @override
  void initState() {
    super.initState();
    _session = ValueNotifier(ref.read(sessionControllerProvider));
    ref.listenManual(
      sessionControllerProvider,
      (_, next) => _session.value = next,
    );
  }

  @override
  void dispose() {
    if (widget.router == null) _router.dispose();
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    debugShowCheckedModeBanner: false,
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    theme: AppTheme.light,
    locale: const Locale('es', 'MX'),
    supportedLocales: const [Locale('es', 'MX')],
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    routerConfig: _router,
  );
}
