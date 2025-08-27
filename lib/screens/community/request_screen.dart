import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Text(
            "Requests",
            style: AppTextStyles.futuraDemi.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          RequestTypeWidget(bgcolor: , iconpath: iconpath, title: title)

        ],
      ),
    );
  }
}



class RequestTypeWidget extends StatelessWidget {
  final Color bgcolor;
  final String iconpath;
  final String title;

  const RequestTypeWidget({
    super.key,
    required this.bgcolor,
    required this.iconpath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135.h,
      width: 135.h,
      decoration: BoxDecoration(
        color: bgcolor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 6.3,
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconpath,
            height: 40.h,
            width: 40.w,
          ),
          SizedBox(height: 5.h),
          Text(
            title,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 15.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
