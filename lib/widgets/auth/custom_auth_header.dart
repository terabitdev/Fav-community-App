import 'package:fava/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomAuthHeader extends StatelessWidget {
  final bool backButton;
  final String? title;
  const CustomAuthHeader({super.key, required this.backButton, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          
          children: [
            backButton
                ? GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: SvgPicture.asset(
                      "assets/icons/back_button.svg",
                      // color: buttonclr,
                      width: 12.w,
                      height: 23.h,
                    ),
                )
                : SizedBox.shrink(),
            SizedBox(width: backButton ? 14.w : 0),      
            SvgPicture.asset(
              'assets/logos/app_logo_horizontal.svg',
              width: 80.w,
              height: 28.h,
            ),
          ],
        ),

        title != null
            ? Column(
                children: [
                  SizedBox(height: 11.h),
                  Center(
                    child: Text(
                      title!,
                      style: AppTextStyles.futuraBook400.copyWith(
                        fontSize: 32.sp,
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
