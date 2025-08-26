import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({super.key, required this.message});
  
  final String message;

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: txtfieldbgclr,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: errorclr, width: 1),
      ),
      child: Text(
        message,
        style: AppTextStyles.futuraBook400.copyWith(
          fontSize: 12.sp,
          color: errorclr,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
