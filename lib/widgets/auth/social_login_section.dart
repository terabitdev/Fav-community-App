import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/widgets/auth/custom_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "Or" text
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.grayLight, thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Text(
                "Or",
                style: AppTextStyles.manropebold.copyWith(
                  fontSize: 15.sp,
                  color: AppColors.grayDark,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.grayLight, thickness: 1)),
          ],
        ),
        SizedBox(height: 16.h),
        
        // Social Login Buttons
        CustomOutlinedButton(
          iconPath: "assets/icons/apple.svg",
          title: "Continue with Apple",
          onpressed: () {},
        ),
        SizedBox(height: 10.h),
        CustomOutlinedButton(
          iconPath: "assets/icons/google.svg",
          title: "Continue with Google",
          onpressed: () {},
        ),
      ],
    );
  }
}
