import 'package:fava/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/app_text_styles.dart';
import '../../providers/user_profile_provider.dart';

class ProfileQuickSettings extends StatelessWidget {
  const ProfileQuickSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgclr,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Settings",
            style: AppTextStyles.futuraDemi.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          SizedBox(height: 16.h),
          Consumer<UserProfileProvider>(
            builder: (context, provider, child) {
              return Column(
                children: [
                  _buildToggleSettingItem(
                    iconAsset: AppAssets.members,
                    title: "Location Sharing",
                    subtitle: "Help others find you or requests",
                    value: provider.isLocationSharingEnabled,
                    onChanged: provider.toggleLocationSharing,
                  ),
                  SizedBox(height: 16.h),
                  _buildToggleSettingItem(
                    iconAsset: AppAssets.bell,
                    title: "Push Notifications",
                    subtitle: "Get notified about new requests",
                    value: provider.isPushNotificationsEnabled,
                    onChanged: provider.togglePushNotifications,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleSettingItem({
    required String iconAsset,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          child: SvgPicture.asset(
            iconAsset,
            width: 40.w,
            height: 40.w,
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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: AppTextStyles.futuraBook.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.hintxtclr,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFF00BCD4),
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.shade300,
        ),
      ],
    );
  
  }
}