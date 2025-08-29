import 'package:fava/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../app/routes.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/app_text_styles.dart';

class ProfileMenuItems extends StatelessWidget {
  const ProfileMenuItems({super.key});

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
        children: [
          _buildMenuItem(
            iconAsset: AppAssets.add,
            title: "My Requests",
            subtitle: "View your requests",
            hasArrow: true,
            onTap: () => context.pushNamed(AppRoute.myRequestsScreen.name),
          ),

          _buildMenuItem(
            iconAsset: AppAssets.members,
            title: "My Groups",
            subtitle: "",
            hasArrow: true,
            onTap: () {
              context.pushNamed(AppRoute.myGroupsScreen.name);
            },
          ),

          _buildMenuItem(
            iconAsset: AppAssets.wallet,
            title: "Payment Methods",
            subtitle: "Manage Venmo and Zelle",
            hasArrow: false,
            onTap: () => context.pushNamed(AppRoute.paymentMethodsScreen.name),
          ),

          _buildMenuItem(
            iconAsset: AppAssets.vector,
            title: "Notification Settings",
            subtitle: "Customize you alerts",
            hasArrow: false,
            onTap: () => context.pushNamed(AppRoute.notificationsScreen.name),
          ),

          _buildMenuItem(
            iconAsset: AppAssets.privacy,
            title: "Privacy & Safety",
            subtitle: "Control your visibility",
            hasArrow: false,
            onTap: () => context.pushNamed(AppRoute.privacyScreen.name),
          ),
          _buildMenuItem(
            iconAsset: AppAssets.support,
            title: "Help and Support",
            subtitle: "Get assistance",
            hasArrow: false,
            onTap: () => context.pushNamed(AppRoute.helpAndSupportScreen.name),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String iconAsset,
    required String title,
    required String subtitle,
    required bool hasArrow,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              child: iconAsset.endsWith('.png')
                  ? Image.asset(iconAsset, width: 40.w, height: 40.w)
                  : SvgPicture.asset(iconAsset, width: 40.w, height: 40.h),
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
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.futuraBook.copyWith(
                        fontSize: 12.sp,
                        color: AppColors.hintxtclr,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasArrow)
              SvgPicture.asset(AppAssets.navigate, width: 16.w, height: 16.h)
            else
              SvgPicture.asset(AppAssets.settings, width: 18.w, height: 18.h),
          ],
        ),
      ),
    );
  }
}
