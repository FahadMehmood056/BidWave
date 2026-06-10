import 'package:flutter/material.dart';
import 'responsive_extension.dart';

extension ResponsiveTextStyle on TextStyle {
  TextStyle responsive(BuildContext context) =>
      copyWith(fontSize: fontSize?.sp(context));
}
