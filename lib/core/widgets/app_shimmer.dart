import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../extensions/responsive_extension.dart';
import '../theme/app_colors.dart';

class AppShimmer extends StatefulWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController.unbounded(vsync: this)
      ..repeat(min: -1.0, max: 2.0, period: const Duration(milliseconds: 1300));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = AppColors.muted.withValues(alpha: 0.12);
    final highlightColor = AppColors.white.withValues(alpha: 0.75);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.1, 0.35, 0.6],
              colors: [baseColor, highlightColor, baseColor],
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final ShapeBorder? shape;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.shape,
  });

  const ShimmerBox.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = null,
      shape = const CircleBorder();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: AppColors.muted.withValues(alpha: 0.16),
          shape:
              shape ??
              RoundedRectangleBorder(
                borderRadius:
                    borderRadius ??
                    BorderRadius.circular(AppSizes.radiusButton.w(context)),
              ),
        ),
      ),
    );
  }
}

class ShimmerLine extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerLine({
    super.key,
    required this.width,
    this.height = 12,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      width: width.w(context),
      height: height.w(context),
      borderRadius: BorderRadius.circular(radius.w(context)),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}
