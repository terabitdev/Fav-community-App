import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes.dart';
import '../../core/constants/appImage.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/app_text_styles.dart';

class ProfileMenuItems extends StatelessWidget {
  const ProfileMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          _buildMenuItem(
            iconAsset: AppImages.add,
            title: "My Requests",
            subtitle: "View your requests",
            hasArrow: true,
            onTap: () {},
          ),

          _buildMenuItem(
            iconAsset: AppImages.members,
            title: "My Groups",
            subtitle: "",
            hasArrow: true,
            onTap: () {
              context.pushNamed(AppRoute.myGroupsScreen.name);
            },
          ),

          _buildMenuItem(
            iconAsset: AppImages.wallet,
            title: "Payment Methods",
            subtitle: "Manage Venmo and Zelle",
            hasArrow: false,
            onTap: () {},
          ),

          _buildMenuItem(
            iconAsset: AppImages.vector,
            title: "Notification Settings",
            subtitle: "Customize you alerts",
            hasArrow: false,
            onTap: () {},
          ),

          _buildMenuItem(
            iconAsset: AppImages.privacy,
            title: "Privacy & Safety",
            subtitle: "Control your visibility",
            hasArrow: false,
            onTap: () {},
          ),
          _buildMenuItem(
            iconAsset: AppImages.support,
            title: "Help and Support",
            subtitle: "Get assistance",
            hasArrow: false,
            onTap: () {},
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
                  ? Image.asset(
                      iconAsset,
                      width: 40.w,
                      height: 40.w,
                    )
                  : SvgPicture.asset(
                      iconAsset,
                      width: 40.w,
                      height: 40.h,
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
                      color: black,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.futuraBook.copyWith(
                        fontSize: 12.sp,
                        color: hintxtclr,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasArrow)
              SvgPicture.asset(
                AppImages.navigate,
                width: 16.w,
                height: 16.h,
              )
            else
              SvgPicture.asset(
                AppImages.settings,
                width: 18.w,
                height: 18.h,
              ),
          ],
        ),
      ),
    );
  }


}