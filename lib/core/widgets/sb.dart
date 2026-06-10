import 'package:flutter/material.dart';
import '../extensions/responsive_extension.dart';

class SB extends StatelessWidget {
  final Widget Function(BuildContext) _builder;

  const SB._(this._builder, {super.key});

  factory SB.h(double height, {Key? key}) {
    return SB._((context) => SizedBox(height: height.h(context)), key: key);
  }

  factory SB.w(double width, {Key? key}) {
    return SB._((context) => SizedBox(width: width.w(context)), key: key);
  }

  factory SB.hw(double height, double width, {Key? key}) {
    return SB._(
      (context) => SizedBox(height: height.h(context), width: width.w(context)),
      key: key,
    );
  }

  @override
  Widget build(BuildContext context) => _builder(context);
}
