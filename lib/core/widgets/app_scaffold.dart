import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../design_system/brand.dart';
import '../auth/auth_models.dart';
import '../auth/session_controller.dart';
import '../design_system/breakpoints.dart';
import '../design_system/colors.dart';
import '../design_system/motion.dart';
import '../design_system/spacing.dart';
import '../routing/navigation.dart';
import '../routing/sidebar_controller.dart';
import 'app_avatar.dart';

class AppScaffold extends ConsumerStatefulWidget {
  const AppScaffold({required this.child, required this.location, super.key});

  final Widget child;
  final String location;

  @override
  ConsumerState<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ConsumerState<AppScaffold> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _sidebarScroll = ScrollController();
  final _drawerScroll = ScrollController();

  @override
  void dispose() {
    _sidebarScroll.dispose();
    _drawerScroll.dispose();
    super.dispose();
  }

  void _navigate(String path) {
    _scaffoldKey.currentState?.closeDrawer();
    if (path != widget.location) context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    final collapsed = ref.watch(sidebarControllerProvider);
    final destination = destinationFor(widget.location);

    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth > AppBreakpoints.desktop;
        final mobile = constraints.maxWidth < AppBreakpoints.mobile;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: AppColors.background,
          drawer: desktop
              ? null
              : Drawer(
                  width: 280,
                  backgroundColor: AppColors.surface,
                  child: SafeArea(
                    child: _Sidebar(
                      collapsed: false,
                      drawer: true,
                      currentPath: destination.path,
                      scrollController: _drawerScroll,
                      onNavigate: _navigate,
                      onToggle: () => _scaffoldKey.currentState?.closeDrawer(),
                    ),
                  ),
                ),
          body: SafeArea(
            bottom: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (desktop)
                  AnimatedContainer(
                    duration: AppMotion.duration(context, AppMotion.page),
                    curve: AppMotion.curve,
                    width: collapsed ? 80 : 264,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      border: Border(
                        right: BorderSide(color: AppColors.border),
                      ),
                    ),
                    // RepaintBoundary: al animar el ancho, el contenido de la barra
                    // se repinta en su propia capa y no arrastra a la página.
                    child: RepaintBoundary(
                      child: _Sidebar(
                        collapsed: collapsed,
                        drawer: false,
                        currentPath: destination.path,
                        scrollController: _sidebarScroll,
                        onNavigate: _navigate,
                        onToggle: () => ref
                            .read(sidebarControllerProvider.notifier)
                            .toggle(),
                      ),
                    ),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      _Topbar(
                        user: ref.watch(sessionControllerProvider).user,
                        onLogout: () => ref
                            .read(sessionControllerProvider.notifier)
                            .logout(),
                        destination: destination,
                        mobile: mobile,
                        showMenu: !desktop,
                        onOpenMenu: () =>
                            _scaffoldKey.currentState?.openDrawer(),
                      ),
                      // La página en su propia capa: sus animaciones (carga,
                      // fundidos) no repintan la barra lateral ni el encabezado.
                      Expanded(child: RepaintBoundary(child: widget.child)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.collapsed,
    required this.drawer,
    required this.currentPath,
    required this.scrollController,
    required this.onNavigate,
    required this.onToggle,
  });

  final bool collapsed;
  final bool drawer;
  final String currentPath;
  final ScrollController scrollController;
  final ValueChanged<String> onNavigate;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final groups = appDestinations.map((item) => item.group).toSet();

    return Column(
      children: [
        SizedBox(
          height: 104,
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.centerLeft,
              minWidth: collapsed ? 80 : 264,
              maxWidth: collapsed ? 80 : 264,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: collapsed ? AppSpacing.md : AppSpacing.xl,
                ),
                child: BrandWordmark(compact: collapsed),
              ),
            ),
          ),
        ),
        Expanded(
          child: Scrollbar(
            controller: scrollController,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              children: [
                for (final group in groups) ...[
                  SizedBox(
                    height: 40,
                    child: collapsed
                        ? Center(
                            child: Container(
                              height: 1,
                              width: 20,
                              color: AppColors.border,
                            ),
                          )
                        : ClipRect(
                            child: OverflowBox(
                              minWidth: 220,
                              maxWidth: 220,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: AppSpacing.md,
                                ),
                                child: Text(
                                  group.toUpperCase(),
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        letterSpacing: 1.4,
                                      ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  for (final item in appDestinations.where(
                    (item) => item.group == group,
                  ))
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: _SidebarItem(
                        destination: item,
                        selected: item.path == currentPath,
                        collapsed: collapsed,
                        onTap: () => onNavigate(item.path),
                      ),
                    ),
                ],
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
        Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              if (!collapsed)
                Positioned(
                  left: AppSpacing.sm,
                  width: 140,
                  child: Text(
                    'Grupo GPA',
                    style: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: drawer
                      ? 'Cerrar menú'
                      : collapsed
                      ? 'Expandir barra lateral'
                      : 'Contraer barra lateral',
                  onPressed: onToggle,
                  icon: Icon(
                    drawer
                        ? Icons.close_rounded
                        : collapsed
                        ? Icons.keyboard_double_arrow_right_rounded
                        : Icons.keyboard_double_arrow_left_rounded,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.destination,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  final AppDestination destination;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      onTap: onTap,
      child: Tooltip(
        message: collapsed ? destination.label : '',
        excludeFromSemantics: true,
        child: Material(
          color: selected ? AppColors.primarySurface : AppColors.transparent,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            excludeFromSemantics: true,
            child: SizedBox(
              height: 46,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  if (selected)
                    const Positioned(
                      left: 0,
                      top: 14,
                      bottom: 14,
                      child: SizedBox(
                        width: 3,
                        child: ColoredBox(color: AppColors.accent),
                      ),
                    ),
                  Positioned(
                    left: 20,
                    top: 12,
                    child: ExcludeSemantics(
                      child: Icon(
                        destination.icon,
                        size: 22,
                        color: selected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 54,
                    top: 0,
                    bottom: 0,
                    width: 186,
                    child: AnimatedOpacity(
                      opacity: collapsed ? 0 : 1,
                      duration: AppMotion.duration(
                        context,
                        AppMotion.interaction,
                      ),
                      curve: AppMotion.curve,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ExcludeSemantics(
                          child: Text(
                            destination.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.text,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Topbar extends StatelessWidget {
  const _Topbar({
    required this.user,
    required this.onLogout,
    required this.destination,
    required this.mobile,
    required this.showMenu,
    required this.onOpenMenu,
  });

  final AppDestination destination;
  final bool mobile;
  final bool showMenu;
  final VoidCallback onOpenMenu;
  final SessionUser? user;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: mobile ? 72 : 88,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? AppSpacing.sm : AppSpacing.xl,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (showMenu) ...[
            IconButton(
              tooltip: 'Abrir menú de navegación',
              onPressed: onOpenMenu,
              icon: const Icon(Icons.menu_rounded),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mobile
                      ? destination.group
                      : 'Capital Humano  /  ${destination.group}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  destination.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: mobile ? textTheme.titleMedium : textTheme.titleLarge,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: mobile ? 56 : 230),
            child: PopupMenuButton<String>(
              tooltip: 'Menú de usuario',
              position: PopupMenuPosition.under,
              onSelected: (value) {
                if (value == 'logout') onLogout();
              },
              itemBuilder: (context) => const [
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Cerrar sesión'),
                ),
              ],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppAvatar(name: user?.displayName ?? '', size: 40),
                    if (!mobile) ...[
                      const SizedBox(width: AppSpacing.sm),
                      // Flexible + ellipsis: sin esto, a escala de texto 1.5x
                      // este bloque puede pedir más ancho del que el topbar
                      // tiene disponible y desbordar (visto en pruebas).
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.displayName ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.labelLarge,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user?.username ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.textSecondary,
                        size: 18,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
