import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fava/core/utils/app_text_styles.dart';

class RequestTypeCard extends StatelessWidget {
  final String requestType;
  final String iconPath;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const RequestTypeCard({
    super.key,
    required this.requestType,
    required this.iconPath,
    required this.backgroundColor,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? 135.w,
        height: height ?? 135.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // rgba(0,0,0,0.25)
              offset: Offset(0, 4), // x:0, y:4
              blurRadius: 6.3, // matches "6.3px" blur
              spreadRadius: 0, // same as CSS spread:0px
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(iconPath, width: requestType == "Others" ? 25.w : 30.w,  height: requestType == "Others" ? 10 : 30.h),
            SizedBox(height: 5.h),
            Text(
              requestType,
              style: AppTextStyles.futuraBook400.copyWith(fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }
}
