import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/colors.dart';
import '../../core/utils/app_text_styles.dart';
import '../common/custom_elevated_button.dart';

class SupportFavaSection extends StatelessWidget {
  const SupportFavaSection({super.key});

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
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.favorite, color: Color(0xFFE57373), size: 24.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            "Support Fava",
            style: AppTextStyles.futuraDemi.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: black,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Love FAVA? Help us keep the community strong with a small tip.",
            textAlign: TextAlign.center,
            style: AppTextStyles.futuraBook.copyWith(
              fontSize: 14.sp,
              color: Colors.black,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),
          CustomElevatedButton(
            text: "Leave a Tip",
            onPressed: () {},
            width: double.infinity,
            height: 48.h,
            textStyle: AppTextStyles.marlinRegular.copyWith(
              color: bgclr,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
