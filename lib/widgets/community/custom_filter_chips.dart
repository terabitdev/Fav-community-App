import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFilterChip extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const CustomFilterChip({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 24.h,
        width: 59.w,
        // padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: isActive ? AppColors.buttonclr : AppColors.bgclr,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.buttonclr, width: 1.w),
        ),
        child: Center(
          child: Text(
            title,
            style: AppTextStyles.futuraBook400.copyWith(
              color: isActive ? Colors.white : AppColors.buttonclr,
              fontSize: 11.sp,
              // fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}