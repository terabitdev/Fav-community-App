import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomOutlinedButton extends StatelessWidget {
  final String iconPath;
  final String title;
  final VoidCallback onpressed;
  const CustomOutlinedButton({
    super.key,
    required this.iconPath,
    required this.title,
    required this.onpressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onpressed,
        style: ButtonStyle(
          side: WidgetStateProperty.all(
            BorderSide(color: successclr, width: 1),
          ),
          foregroundColor: WidgetStateProperty.all(Colors.black),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          // foregroundColor: WidgetStateProperty.all()
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            SvgPicture.asset(iconPath, width: 18.w, height: 18.h),
            SizedBox(width: 10.w),
            Text(
              title,
              style: AppTextStyles.futuraBook400.copyWith(fontSize: 15.sp),
            ),
          ],
        ),
      ),
    );
  }
}
