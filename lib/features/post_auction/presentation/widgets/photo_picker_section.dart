import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class PhotoPickerSection extends StatelessWidget {
  final List<String> imagePaths;
  final VoidCallback onAddPhoto;
  final ValueChanged<int> onRemovePhoto;

  const PhotoPickerSection({
    super.key,
    required this.imagePaths,
    required this.onAddPhoto,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    final photoCount = imagePaths.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (photoCount == 0)
          _buildEmptyState(context)
        else
          _buildPhotoGrid(context),
        SB.h(8),
        Text(
          '${AppStrings.maxPhotos} ($photoCount/3)',
          style: AppTextStyles.labelMedium.responsive(context),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return GestureDetector(
      onTap: onAddPhoto,
      child: Container(
        width: double.infinity,
        height: 160.w(context),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppIcons.camera, size: 36.w(context), color: AppColors.muted),
            SB.h(12),
            Text(
              AppStrings.addPhotos,
              style: AppTextStyles.labelLarge.responsive(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid(BuildContext context) {
    final photoCount = imagePaths.length;
    final itemCount = photoCount < 3 ? photoCount + 1 : photoCount;
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.w(context),
        crossAxisSpacing: 10.w(context),
      ),
      itemCount: itemCount,
      itemBuilder: (_, index) {
        if (index == photoCount && photoCount < 3) {
          return _buildAddButton(context);
        }

        return _buildPhotoItem(context, index);
      },
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return GestureDetector(
      onTap: onAddPhoto,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppIcons.camera, size: 24.w(context), color: AppColors.muted),
            SB.h(4),
            Text(
              AppStrings.addPhotos,
              style: AppTextStyles.labelMedium.responsive(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoItem(BuildContext context, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
          child: Image.file(File(imagePaths[index]), fit: BoxFit.cover),
        ),
        Positioned(
          top: 6.w(context),
          right: 6.w(context),
          child: GestureDetector(
            onTap: () => onRemovePhoto(index),
            child: Container(
              padding: EdgeInsets.all(4.w(context)),
              decoration: BoxDecoration(
                color: AppColors.charcoal.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.close,
                size: 12.w(context),
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
