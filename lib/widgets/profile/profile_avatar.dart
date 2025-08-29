import 'dart:typed_data';
import 'package:fava/core/constants/assets.dart';
import 'package:fava/core/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/app_text_styles.dart';
import '../../providers/request_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../common/image_selection_widget.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final String knownAs;

  const ProfileAvatar({super.key, required this.name, required this.knownAs});

  void _showFullImage(BuildContext context, Uint8List image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.memory(
                  image,
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImagePicker(BuildContext context) {
    final userProfileProvider = context.read<UserProfileProvider>();
    final requestProvider = RequestProvider();
    
    // Directly show the ImageSelectionWidget's built-in modal
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
                subtitle: 'Choose from your photo library',
                onTap: () async {
                  Navigator.pop(context);
                  await requestProvider.pickSingleImageFromGallery(maxSizeInMB: 5);
                  userProfileProvider.setProfileImage(requestProvider.selectedSingleImage);
                },
              ),
              SizedBox(height: 12.h),
              _buildOptionTile(
                context: context,
                icon: Icons.camera_alt_outlined,
                title: 'Camera',
                subtitle: 'Take a new photo',
                onTap: () async {
                  Navigator.pop(context);
                  await requestProvider.pickSingleImageFromCamera(maxSizeInMB: 5);
                  userProfileProvider.setProfileImage(requestProvider.selectedSingleImage);
                },
              ),
              if (userProfileProvider.profileImage != null) ...[
                SizedBox(height: 12.h),
                _buildOptionTile(
                  context: context,
                  icon: Icons.delete_outline,
                  title: 'Remove Photo',
                  subtitle: 'Clear selected image',
                  onTap: () {
                    Navigator.pop(context);
                    requestProvider.removeSingleImage();
                    userProfileProvider.setProfileImage(null);
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
    required BuildContext context,
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
                    style: AppTextStyles.futuraBook.copyWith(
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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProfileProvider, child) {
        return Column(
          children: [
            Stack(
              children: [
                if (userProfileProvider.profileImage != null)
                  GestureDetector(
                    onTap: () => _showFullImage(context, userProfileProvider.profileImage!),
                    child: Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: MemoryImage(userProfileProvider.profileImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                else
                  SvgPicture.asset(AppAssets.profileIcon, width: 80.w, height: 80.h),
                Positioned(
                  bottom: 0,
                  right: 5,
                  width: 25,
                  height: 25,
                  child: GestureDetector(
                    onTap: () => _showImagePicker(context),
                    child: SvgPicture.asset(AppAssets.selectedCamera),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              name,
              style: AppTextStyles.futuraDemi.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              knownAs,
              style: AppTextStyles.futuraBook.copyWith(
                fontSize: 14.sp,
                color: AppColors.darkGray,
              ),
            ),
          ],
        );
      },
    );
  }
}
