import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.icon,
    required this.gradient,
    this.onTap,
    this.showLabel = true,
  });

  final String title;
  final String subtitle;
  final String cta;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback? onTap;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight <= 110;
        final verticalPadding = compact ? 10.0 : 14.0;
        final titleSize = compact ? 14.5 : 16.0;
        final subtitleLines = compact ? 1 : 2;
        final badgeVertical = compact ? 4.0 : 6.0;
        final badgeHorizontal = compact ? 8.0 : 10.0;
        final iconSize = compact ? 38.0 : 42.0;

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Ink(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: verticalPadding,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: titleSize,
                              height: 1.12,
                            ),
                          ),
                          SizedBox(height: compact ? 4 : 6),
                          Text(
                            subtitle,
                            maxLines: subtitleLines,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFE2E8F0),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              height: 1.1,
                            ),
                          ),
                          if (showLabel) ...[
                            SizedBox(height: compact ? 7 : 10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: badgeHorizontal,
                                vertical: badgeVertical,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                cta,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
