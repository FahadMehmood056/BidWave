import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'app_image_placeholder.dart';
import 'app_shimmer.dart';

class AppShimmerImage extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const AppShimmerImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    if (!hasImage) {
      return AppImagePlaceholder(
        width: width,
        height: height,
        borderRadius: borderRadius,
      );
    }

    final image = CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) =>
          ShimmerBox(width: width, height: height, borderRadius: borderRadius),
      errorWidget: (_, _, _) =>
          errorWidget ??
          AppImagePlaceholder(
            width: width,
            height: height,
            borderRadius: borderRadius,
          ),
    );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}
