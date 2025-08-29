import 'package:fava/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppBar extends StatelessWidget {
  final int? topHeight;
  final bool backButton;
  final String title;
  final String?
  subtitle; // Fixed: changed from Subtitle to subtitle (camelCase)
  final bool appLogo;

  const CustomAppBar({
    super.key,
    required this.backButton,
    required this.title,
    this.subtitle, // Fixed: parameter name
    required this.appLogo,
    this.topHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: topHeight!.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (backButton) // Fixed: cleaner conditional rendering
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: SvgPicture.asset(
                  "assets/icons/back_button.svg",
                  width: 12.w,
                  height: 23.h,
                ),
              ),
            if (backButton)
              SizedBox(width: 14.w), // Fixed: cleaner conditional spacing
            if (appLogo)
              SvgPicture.asset(
                'assets/logos/app_logo_horizontal.svg',
                width: 80.w,
                height: 28.h,
              )
            else
              Text(
                title, // Fixed: removed unnecessary null assertion operator
                style: AppTextStyles.futuraBook400.copyWith(fontSize: 16.sp),
              ),
          ],
        ),
        if (subtitle != null) ...[
          // Fixed: cleaner conditional rendering with spread operator
          SizedBox(height: 11.h),
          Center(
            child: Text(
              subtitle!, // Safe to use ! here since we checked null above
              style: AppTextStyles.futuraBook400.copyWith(fontSize: 32.sp),
            ),
          ),
        ],
      ],
    );
  }
}
