import 'dart:math';
import 'package:flutter/material.dart';

extension ContextResponsiveExtension on num {
  static const double _baseWidth = 375;
  static const double _baseHeight = 810;

  double w(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return this * (screenWidth / _baseWidth);
  }

  double h(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final padding = MediaQuery.paddingOf(context);
    final usableHeight = screenHeight - padding.top - padding.bottom;
    return this * (usableHeight / _baseHeight);
  }

  double sp(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final baseMinDimension = min(_baseWidth, _baseHeight);
    final currentMinDimension = min(size.width, size.height);
    final scaleFactor = currentMinDimension / baseMinDimension;
    return (this * scaleFactor).roundToDouble();
  }
}
