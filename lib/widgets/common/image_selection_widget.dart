import 'dart:typed_data';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/providers/request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageSelectionWidget extends StatelessWidget {
  final RequestProvider provider;
  final Function(Uint8List?) onImageSelected;
  final String? buttonText;
  final String? iconPath;
  final int maxSizeInMB;

  const ImageSelectionWidget({
    super.key,
    required this.provider,
    required this.onImageSelected,
    this.buttonText = 'Add Photo',
    this.iconPath = 'assets/icons/camera.svg',
    this.maxSizeInMB = 5,
  });

  void _showImageSourceDialog(BuildContext context) {
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
                icon: Icons.photo_library_outlined,
                title: 'Gallery',
                subtitle: 'Choose from your photo library',
                onTap: () async {
                  Navigator.pop(context);
                  await provider.pickSingleImageFromGallery(maxSizeInMB: maxSizeInMB);
                  onImageSelected(provider.selectedSingleImage);
                },
              ),
              SizedBox(height: 12.h),
              _buildOptionTile(
                icon: Icons.camera_alt_outlined,
                title: 'Camera',
                subtitle: 'Take a new photo',
                onTap: () async {
                  Navigator.pop(context);
                  await provider.pickSingleImageFromCamera(maxSizeInMB: maxSizeInMB);
                  onImageSelected(provider.selectedSingleImage);
                },
              ),
              if (provider.selectedSingleImage != null) ...[
                SizedBox(height: 12.h),
                _buildOptionTile(
                  icon: Icons.delete_outline,
                  title: 'Remove Photo',
                  subtitle: 'Clear selected image',
                  onTap: () {
                    Navigator.pop(context);
                    provider.removeSingleImage();
                    onImageSelected(null);
                  },
                  isDestructive: true,
                ),
              ],
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.errorclr : AppColors.buttonclr;
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: color.withOpacity(0.3),
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
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: color,
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
        if (provider.singleImageError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showErrorSnackBar(context, provider.singleImageError!);
            provider.clearSingleImageError();
          });
        }

        if (provider.selectedSingleImage != null) {
          return Stack(
            children: [
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  image: DecorationImage(
                    image: MemoryImage(provider.selectedSingleImage!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Row(
                  children: [
                    _buildImageActionButton(
                      icon: Icons.edit,
                      onTap: () => _showImageSourceDialog(context),
                    ),
                    SizedBox(width: 8.w),
                    _buildImageActionButton(
                      icon: Icons.close,
                      onTap: () {
                        provider.removeSingleImage();
                        onImageSelected(null);
                      },
                      isDestructive: true,
                    ),
                  ],
                ),
              ),
              if (provider.isSingleImageLoading)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.bgclr,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }

        return GestureDetector(
          onTap: provider.isSingleImageLoading ? null : () => _showImageSourceDialog(context),
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.buttonclr, width: 1),
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (provider.isSingleImageLoading)
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
      },
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.errorclr : AppColors.buttonclr,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Icon(
          icon,
          color: AppColors.bgclr,
          size: 16.sp,
        ),
      ),
    );
  }
}