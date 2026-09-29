import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/employment/presentation/empleado_detail_page.dart';
import '../../features/employment/presentation/empleados_page.dart';
import '../../features/organizations/presentation/organization_tree_page.dart';
import '../../features/organizations/presentation/companies_page.dart';
import '../../features/locations/data/location_models.dart';
import '../../features/locations/presentation/locations_page.dart';
import '../../features/persons/presentation/person_detail_page.dart';
import '../../features/persons/presentation/persons_page.dart';
import '../../features/placeholders/presentation/module_placeholder_page.dart';
import '../../features/positions/presentation/positions_page.dart';
import '../../features/positions/presentation/puestos_page.dart';
import '../../features/schedules/presentation/asignaciones_horario_page.dart';
import '../../features/schedules/presentation/asignaciones_ubicacion_page.dart';
import '../../features/schedules/presentation/catorcenas_page.dart';
import '../../features/schedules/presentation/tipos_horario_page.dart';
import '../auth/auth_models.dart';
import '../auth/session_gate_page.dart';
import '../design_system/colors.dart';
import '../design_system/motion.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/empty_state.dart';
import 'navigation.dart';

GoRouter createAppRouter({
  String? initialLocation,
  required SessionState Function() session,
  required Listenable refreshListenable,
}) => GoRouter(
  initialLocation: initialLocation,
  refreshListenable: refreshListenable,
  redirect: (context, route) {
    final status = session().status;
    final path = route.uri.path;
    final isSessionRoute = path == '/login' || path == '/session';
    final requested = isSessionRoute
        ? route.uri.queryParameters['from']
        : route.uri.toString();
    final from = appDestinations.any((item) => item.path == requested)
        ? requested!
        : '/dashboard';
    if (status == SessionStatus.restoring ||
        status == SessionStatus.unavailable) {
      return path == '/session'
          ? null
          : Uri(path: '/session', queryParameters: {'from': from}).toString();
    }
    if (status == SessionStatus.signedOut) {
      return path == '/login'
          ? null
          : Uri(path: '/login', queryParameters: {'from': from}).toString();
    }
    return isSessionRoute ? from : null;
  },
  routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) =>
          _sessionPage(context, state, const LoginPage()),
    ),
    GoRoute(
      path: '/session',
      pageBuilder: (context, state) =>
          _sessionPage(context, state, const SessionGatePage()),
    ),
    GoRoute(path: '/', redirect: (context, state) => '/dashboard'),
    ShellRoute(
      builder: (context, state, child) =>
          AppScaffold(location: state.uri.path, child: child),
      routes: [
        for (final destination in appDestinations)
          GoRoute(
            path: destination.path,
            pageBuilder: (context, state) => CustomTransitionPage<void>(
              key: state.pageKey,
              transitionDuration: AppMotion.duration(context, AppMotion.page),
              reverseTransitionDuration: AppMotion.duration(
                context,
                AppMotion.page,
              ),
              child: switch (destination.path) {
                '/dashboard' => const DashboardPage(),
                '/organizacion/organigrama' => const OrganizationTreePage(),
                '/organizacion/empresas' => const CompaniesPage(),
                '/ubicaciones' => const LocationsPage(
                  kind: LocationKind.ubicaciones,
                ),
                '/ubicaciones/naves' => const LocationsPage(
                  kind: LocationKind.naves,
                ),
                '/ubicaciones/areas' => const LocationsPage(
                  kind: LocationKind.areas,
                ),
                '/personas' => const PersonsPage(),
                '/empleados' => const EmpleadosPage(),
                '/posiciones' => const PositionsPage(),
                '/posiciones/puestos' => const PuestosPage(),
                '/horarios/catorcenas' => const CatorcenasPage(),
                '/horarios/tipos' => const TiposHorarioPage(),
                '/horarios/asignaciones-horario' => const AsignacionesHorarioPage(),
                '/horarios/asignaciones-ubicacion' => const AsignacionesUbicacionPage(),
                _ => ModulePlaceholderPage(destination: destination),
              },
              // FadeThroughTransition, no un fade cruzado a mano: la página
              // saliente y la entrante casi nunca comparten layout/altura,
              // así que superponerlas con opacidad se ve como texto de
              // ambas encimado (justo el "se queda pegada" reportado). Este
              // patrón pinta un fondo sólido entre una y otra — ver el
              // razonamiento completo en design_system/motion.dart.
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    if (MediaQuery.disableAnimationsOf(context)) return child;
                    return FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      fillColor: AppColors.background,
                      child: child,
                    );
                  },
            ),
          ),
        // Rutas de detalle: no son destinos de la barra lateral (no están
        // en appDestinations), pero viven en el mismo ShellRoute para
        // conservar sidebar/topbar. destinationFor() en navigation.dart
        // resuelve el resaltado correcto por prefijo.
        GoRoute(
          path: '/personas/:id',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: AppMotion.duration(context, AppMotion.page),
            reverseTransitionDuration: AppMotion.duration(context, AppMotion.page),
            child: PersonDetailPage(personaId: state.pathParameters['id']!),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              if (MediaQuery.disableAnimationsOf(context)) return child;
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                fillColor: AppColors.background,
                child: child,
              );
            },
          ),
        ),
        GoRoute(
          path: '/empleados/:id',
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            transitionDuration: AppMotion.duration(context, AppMotion.page),
            reverseTransitionDuration: AppMotion.duration(context, AppMotion.page),
            child: EmpleadoDetailPage(empleadoId: state.pathParameters['id']!),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              if (MediaQuery.disableAnimationsOf(context)) return child;
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                fillColor: AppColors.background,
                child: child,
              );
            },
          ),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: SafeArea(
      child: EmptyState(
        icon: Icons.explore_off_outlined,
        title: 'No encontramos esta sección',
        message: 'Puedes volver al inicio y continuar desde el menú.',
        action: TextButton(
          onPressed: () => context.go('/dashboard'),
          child: const Text('Volver al inicio'),
        ),
      ),
    ),
  ),
);

CustomTransitionPage<void> _sessionPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) => CustomTransitionPage<void>(
  key: state.pageKey,
  transitionDuration: AppMotion.duration(context, AppMotion.page),
  reverseTransitionDuration: AppMotion.duration(context, AppMotion.page),
  child: child,
  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      MediaQuery.disableAnimationsOf(context)
      ? child
      : FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          fillColor: AppColors.background,
          child: child,
        ),
);
