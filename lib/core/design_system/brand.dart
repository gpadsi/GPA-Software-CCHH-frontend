import 'package:flutter/material.dart';

import 'colors.dart';
import 'spacing.dart';
import 'typography.dart';

const gpaLogoAsset = 'lib/core/design_system/company-logo.png';
const gpaMarkAsset = 'lib/core/design_system/gpa-mark.png';
const gpaGearAsset = 'lib/core/design_system/agroindustry-gear.png';

// La identidad conserva su letra; su color se adapta al fondo de la barra.
const _brandTitle = TextStyle(
  fontFamily: AppFonts.manrope,
  fontSize: 14,
  height: 1.4,
  fontWeight: FontWeight.w600,
  color: Color(0xFF1F1214),
  letterSpacing: 1.4,
);
const _brandSubtitle = TextStyle(
  fontFamily: AppFonts.manrope,
  fontSize: 11,
  height: 1.4,
  fontWeight: FontWeight.w500,
  color: Color(0xFF5A4549),
  letterSpacing: 2.1,
);

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({
    super.key,
    this.compact = false,
    this.onSidebar = false,
  });
  final bool compact;
  final bool onSidebar;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Grupo GPA · Capital Humano',
    image: true,
    child: ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GpaEmblem(size: compact ? 44 : 52, animateOnHover: onSidebar),
          if (!compact) ...[
            const SizedBox(width: AppSpacing.md),
            // Flexible + ellipsis: sin esto, a escala de texto grande
            // (accesibilidad) este wordmark desborda su espacio en la
            // barra lateral (visto en pruebas a 1.5x).
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'CAPITAL',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _brandTitle.copyWith(
                      color: onSidebar
                          ? context.colors.sidebarText
                          : context.colors.text,
                    ),
                  ),
                  Text(
                    'HUMANO',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _brandSubtitle.copyWith(
                      color: onSidebar
                          ? context.colors.sidebarText
                          : context.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

/// En reposo no programa frames. Solo el engrane gira al pasar el cursor.
class GpaEmblem extends StatefulWidget {
  const GpaEmblem({super.key, this.size = 52, this.animateOnHover = false});
  final double size;
  final bool animateOnHover;

  @override
  State<GpaEmblem> createState() => _GpaEmblemState();
}

class _GpaEmblemState extends State<GpaEmblem>
    with SingleTickerProviderStateMixin {
  late final _rotation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  late final _turns = CurvedAnimation(
    parent: _rotation,
    curve: Curves.easeInOutCubic,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) _rotation.reset();
  }

  @override
  void dispose() {
    _turns.dispose();
    _rotation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) {
      if (widget.animateOnHover &&
          !MediaQuery.disableAnimationsOf(context) &&
          TickerMode.valuesOf(context).enabled &&
          !_rotation.isAnimating) {
        _rotation.forward(from: 0);
      }
    },
    child: RepaintBoundary(
      child: SizedBox.square(
        dimension: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // El blanco termina dentro del engrane, nunca detrás del nombre.
            SizedBox.square(
              dimension: widget.size * .70,
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            RotationTransition(
              turns: _turns,
              child: Image.asset(gpaGearAsset, excludeFromSemantics: true),
            ),
            Image.asset(gpaMarkAsset, excludeFromSemantics: true),
          ],
        ),
      ),
    ),
  );
}
