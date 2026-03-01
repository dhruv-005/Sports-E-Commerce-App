import 'package:flutter/material.dart';

class ResponsiveLayout {
  const ResponsiveLayout._(this.width);

  final double width;

  static ResponsiveLayout of(BuildContext context) {
    return ResponsiveLayout._(MediaQuery.sizeOf(context).width);
  }

  bool get isPhone => width < 600;

  bool get isTablet => width >= 600 && width < 1100;

  bool get isDesktop => width >= 1100;

  bool get isCompact => width < 460;

  double get pagePadding {
    if (width >= 1100) return 28;
    if (width >= 700) return 20;
    return 12;
  }

  double get maxContentWidth {
    if (width >= 1400) return 1280;
    if (width >= 1100) return 1140;
    if (width >= 700) return 900;
    return width;
  }

  int productColumns() {
    return productColumnsForWidth(width);
  }

  double productAspectRatio() {
    return productAspectRatioForWidth(width);
  }

  static int productColumnsForWidth(double width) {
    if (width >= 1300) return 5;
    if (width >= 1024) return 4;
    if (width >= 760) return 3;
    if (width < 360) return 1;
    return 2;
  }

  static double productAspectRatioForWidth(double width) {
    if (width >= 1300) return 0.78;
    if (width >= 1024) return 0.74;
    if (width >= 760) return 0.69;
    if (width < 360) return 1.9;
    return 0.64;
  }
}
