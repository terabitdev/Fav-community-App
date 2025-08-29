import 'package:fava/core/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/app_text_styles.dart';
import '../../providers/groups_provider.dart';
import '../common/cloud_widget.dart';
import '../common/custom_elevated_button.dart';

class MyGroupCard extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onViewGroup;
  final VoidCallback onSettings;

  const MyGroupCard({
    super.key,
    required this.group,
    required this.onViewGroup,
    required this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgclr,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildImageHeader(), _buildContent()],
      ),
    );
  }

  Widget _buildImageHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
          child: Container(
            width: double.infinity,
            child: Image.asset(AppAssets.myGroupImage),
          ),
        ),
      ],
    );
  }

  Widget _buildBuildingSilhouettes() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 120.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2E7D8F).withOpacity(0.8), Color(0xFF1A5F7A)],
          ),
        ),
      ),
    );
  }

  Widget _buildGreenTrees() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
          ),
        ),
      ),
    );
  }

  Widget _buildClouds() {
    return Stack(
      children: [
        Positioned(top: 30.h, right: 50.w, child: CloudWidget()),
        Positioned(top: 60.h, left: 40.w, child: CloudWidget()),
        Positioned(top: 20.h, left: 150.w, child: CloudWidget()),
      ],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleAndMembersRow(),
          SizedBox(height: 12.h),
          _buildDescription(),
          SizedBox(height: 16.h),
          _buildLocationAndDateRow(),
          SizedBox(height: 20.h),
          _buildButtonRow(),
        ],
      ),
    );
  }

  Widget _buildTitleAndMembersRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            group.title,
            style: AppTextStyles.futuraDemi.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              height: 1.3,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              AppAssets.member,
              width: 14.w,
              height: 14.h,
              color: AppColors.darkGray,
            ),
            SizedBox(width: 4.w),
            Text(
              '${group.memberCount} members',
              style: AppTextStyles.futuraBook.copyWith(
                fontSize: 12.sp,
                color: AppColors.darkGray,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      group.description,
      style: AppTextStyles.futuraBook.copyWith(
        fontSize: 14.sp,
        color: AppColors.darkGray,
        height: 1.4,
      ),
    );
  }

  Widget _buildLocationAndDateRow() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: AppColors.darkGray.withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/location1.svg',
                  width: 16.w,
                  height: 16.h,
                  color: AppColors.darkGray,
                ),
                SizedBox(width: 6.w),
                Text(
                  group.location,
                  style: AppTextStyles.futuraBook.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.darkGray,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(width: 24.w),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.r),
            color: AppColors.darkGray.withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              group.joinedDate,
              style: AppTextStyles.futuraBook.copyWith(
                fontSize: 14.sp,
                color: AppColors.darkGray,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonRow() {
    return Row(
      children: [
        Expanded(
          child: CustomElevatedButton(
            text: "View Group",
            onPressed: onViewGroup,
            height: 48.h,
            textStyle: AppTextStyles.marlinRegular.copyWith(
              color: AppColors.bgclr,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.darkGray, width: 1),
          ),
          child: IconButton(
            onPressed: onSettings,
            icon: SvgPicture.asset(
              AppAssets.settings,
              width: 20.w,
              height: 20.h,
              color: AppColors.darkGray,
            ),
          ),
        ),
      ],
    );
  }
}
