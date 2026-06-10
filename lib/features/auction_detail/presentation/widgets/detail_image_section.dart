import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_image_placeholder.dart';
import '../../../../core/widgets/app_shimmer_image.dart';

class DetailImageSection extends StatefulWidget {
  final List<String> images;
  final bool isLive;

  const DetailImageSection({
    super.key,
    required this.images,
    this.isLive = true,
  });

  @override
  State<DetailImageSection> createState() => _DetailImageSectionState();
}

class _DetailImageSectionState extends State<DetailImageSection> {
  final _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.images.isNotEmpty;

    return Stack(
      children: [
        SizedBox(
          height: 320.w(context),
          width: double.infinity,
          child: hasImages
              ? PageView.builder(
                  controller: _pageController,
                  itemCount: widget.images.length,
                  onPageChanged: (index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (_, index) {
                    final imageUrl = widget.images[index];

                    return AppShimmerImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      height: 320.w(context),
                    );
                  },
                )
              : AppImagePlaceholder(
                  height: 320.w(context),
                  width: double.infinity,
                ),
        ),

        if (widget.isLive)
          Positioned(
            top: 12.w(context),
            left: AppSizes.pagePadding.w(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w(context),
                vertical: 4.w(context),
              ),
              decoration: BoxDecoration(
                color: AppColors.emeraldLight,
                borderRadius: BorderRadius.circular(
                  AppSizes.radiusPill.w(context),
                ),
                border: Border.all(color: AppColors.emerald),
              ),
              child: Text(
                AppStrings.live,
                style: AppTextStyles.labelMedium
                    .responsive(context)
                    .copyWith(
                      color: AppColors.emeraldDark,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),

        if (widget.images.length > 1)
          Positioned(
            bottom: 12.w(context),
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                final isActive = index == _currentIndex;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(horizontal: 3.w(context)),
                  width: isActive ? 18.w(context) : 7.w(context),
                  height: 7.w(context),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.emerald
                        : AppColors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(20.w(context)),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
