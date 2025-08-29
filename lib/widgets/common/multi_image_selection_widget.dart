import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/providers/request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MultiImageSelectionWidget extends StatelessWidget {
  final RequestProvider provider;
  final int maxImages;
  final String? buttonText;
  final String? iconPath;
  final int maxSizeInMB;

  const MultiImageSelectionWidget({
    super.key,
    required this.provider,
    this.maxImages = 3,
    this.buttonText = 'Add Photos',
    this.iconPath = 'assets/icons/camera.svg',
    this.maxSizeInMB = 5,
  });

  void _showImageSourceDialog(BuildContext context) {
    if (provider.selectedImages.length >= maxImages) {
      _showErrorSnackBar(context, 'Maximum $maxImages images can be selected');
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgclr,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grayMedium,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Select Image Source',
                style: AppTextStyles.futuraDemi.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20.h),
              _buildOptionTile(
                context: context,
                icon: Icons.photo_library_outlined,
                title: 'Gallery',
                subtitle: provider.selectedImages.length < maxImages - 1
                    ? 'Choose multiple photos'
                    : 'Choose a photo',
                onTap: () {
                  Navigator.pop(context);
                  if (provider.selectedImages.length < maxImages - 1) {
                    provider.pickMultipleImagesFromGallery(
                      maxSizeInMB: maxSizeInMB,
                      maxImages: maxImages,
                    );
                  } else {
                    provider.pickImageFromGallery(
                      maxSizeInMB: maxSizeInMB,
                      maxImages: maxImages,
                    );
                  }
                },
              ),
              SizedBox(height: 12.h),
              _buildOptionTile(
                context: context,
                icon: Icons.camera_alt_outlined,
                title: 'Camera',
                subtitle: 'Take a new photo',
                onTap: () {
                  Navigator.pop(context);
                  provider.pickImageFromCamera(
                    maxSizeInMB: maxSizeInMB,
                    maxImages: maxImages,
                  );
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.buttonclr.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 45.w,
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.buttonclr.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: AppColors.buttonclr,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.futuraDemi.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.grayMedium,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.grayMedium,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorclr,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: provider,
      builder: (context, child) {
        // Listen to provider state and show errors
        if (provider.imageError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorSnackBar(context, provider.imageError!);
            provider.clearImageError();
          });
        }

        return _buildContent(context);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (provider.selectedImages.isNotEmpty) {
      return SizedBox(
        height: 80.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: provider.selectedImages.length + 
              (provider.selectedImages.length < maxImages ? 1 : 0),
          itemBuilder: (context, index) {
            // Show image cards
            if (index < provider.selectedImages.length) {
              return Container(
                margin: EdgeInsets.only(right: 8.w),
                child: Stack(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        image: DecorationImage(
                          image: MemoryImage(provider.selectedImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4.h,
                      right: 4.w,
                      child: GestureDetector(
                        onTap: () => provider.removeImage(index),
                        child: Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: AppColors.errorclr,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            color: AppColors.bgclr,
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            // Show add card at the end
            else {
              return GestureDetector(
                onTap: provider.isImageLoading ? null : () => _showImageSourceDialog(context),
                child: Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.buttonclr,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: provider.isImageLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.buttonclr,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: AppColors.buttonclr,
                                size: 20.sp,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Add',
                                style: AppTextStyles.futuraBook400.copyWith(
                                  color: AppColors.buttonclr,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '${provider.selectedImages.length}/$maxImages',
                                style: AppTextStyles.futuraBook400.copyWith(
                                  color: AppColors.buttonclr,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            }
          },
        ),
      );
    }

    return GestureDetector(
      onTap: provider.isImageLoading ? null : () => _showImageSourceDialog(context),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.buttonclr, width: 1),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (provider.isImageLoading)
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.buttonclr,
                ),
              )
            else ...[
              SvgPicture.asset(
                iconPath!,
                width: 19.w,
                height: 16.h,
                colorFilter: ColorFilter.mode(
                  AppColors.buttonclr,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                buttonText!,
                style: AppTextStyles.futuraBook400.copyWith(
                  color: AppColors.grayMedium,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}