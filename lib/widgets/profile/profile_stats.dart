import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/app_text_styles.dart';

class ProfileStats extends StatelessWidget {
  final String completedCount;
  final String rating;
  final String reviewsCount;
  final String groupsCount;

  const ProfileStats({
    super.key,
    required this.completedCount,
    required this.rating,
    required this.reviewsCount,
    required this.groupsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(completedCount, "Completed"),
          _buildVerticalDivider(),
          _buildRatingItem(rating, "$reviewsCount Reviews"),
          _buildVerticalDivider(),
          _buildStatItem(groupsCount, "Groups"),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: AppTextStyles.futuraDemi.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: black,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.futuraBook.copyWith(
            fontSize: 12.sp,
            color: darkGray,
          ),
        ),
      ],
    );
  }

  Widget _buildRatingItem(String rating, String label) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star,
              color: Colors.amber,
              size: 20.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              rating,
              style: AppTextStyles.futuraDemi.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: black,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: AppTextStyles.futuraBook.copyWith(
            fontSize: 12.sp,
            color: darkGray,
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40.h,
      width: 1.w,
      color: darkGray
    );
  }
}