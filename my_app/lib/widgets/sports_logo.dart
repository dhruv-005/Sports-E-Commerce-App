import 'package:flutter/material.dart';
import '../theme/app_style.dart';

class SportsLogo extends StatelessWidget {
  const SportsLogo({
    super.key,
    this.size = 44,
    this.showText = true,
    this.textColor,
  });

  final double size;
  final bool showText;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? Theme.of(context).colorScheme.onSurface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppStyle.accentGradient,
          ),
          child: Icon(
            Icons.sports_soccer,
            color: Colors.white,
            size: size * 0.55,
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 10),
          Text(
            'Sportify Store',
            style: TextStyle(
              color: color,
              fontSize: size * 0.38,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ],
    );
  }
}
