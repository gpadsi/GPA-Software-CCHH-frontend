import 'package:flutter/material.dart';

import 'spacing.dart';

const gpaLogoAsset = 'lib/core/design_system/company-logo.png';

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.compact = false});
  final bool compact;
  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Grupo GPA · Capital Humano',
    image: true,
    child: ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            gpaLogoAsset,
            width: compact ? 48 : 64,
            height: 56,
            fit: BoxFit.contain,
          ),
          if (!compact) ...[
            const SizedBox(width: AppSpacing.sm),
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
                    style: Theme.of(context).textTheme.labelLarge!
                        .copyWith(letterSpacing: 1.4),
                  ),
                  Text(
                    'HUMANO',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall!
                        .copyWith(letterSpacing: 2.1),
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
