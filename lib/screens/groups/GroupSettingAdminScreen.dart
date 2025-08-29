import 'package:fava/core/constants/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/app_text_styles.dart';
import '../../widgets/auth/custom_app_bar.dart';

class GroupSettingAdminScreen extends StatefulWidget {
  const GroupSettingAdminScreen({super.key});

  @override
  State<GroupSettingAdminScreen> createState() =>
      _GroupSettingAdminScreenState();
}

class _GroupSettingAdminScreenState extends State<GroupSettingAdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20.h,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(backButton: true, title: 'Group Settings',appLogo: false,),

                // Four icon buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconButton(
                      icon: Icons.group_add_outlined,
                      onTap: () {
                        // Add member functionality
                      },
                    ),
                    _buildIconButton(
                      icon: Icons.search,
                      onTap: () {
                        // Search functionality
                      },
                    ),
                    _buildIconButton(
                      icon: Icons.notifications_outlined,
                      onTap: () {
                        // Notifications functionality
                      },
                    ),
                    _buildIconButton(
                      icon: Icons.delete_outline,
                      onTap: () {
                        // Delete functionality
                      },
                    ),
                  ],
                ),

                // Invitation Link option
                _buildSettingOption(
                  icon: Icons.link,
                  title: 'Invitation Link',
                  onTap: () {
                    // Handle invitation link
                  },
                ),

                // Edit Group Information option
                _buildSettingOption(
                  icon: Icons.edit_outlined,
                  title: 'Edit Group Information',
                  onTap: () {
                    // Handle edit group info
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70.w,
        height: 70.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.cyanGreen.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 28.sp, color: AppColors.darkGray),
      ),
    );
  }

  Widget _buildSettingOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: AppColors.darkGray, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 24.sp, color: Color(0xFF6B7280)),
            SizedBox(width: 15.w),
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: AppTextStyles.futuraBook400.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 24.sp, color: Color(0xFF4A90A4)),
          ],
        ),
      ),
    );
  }
}
