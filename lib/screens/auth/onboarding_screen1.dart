import 'package:fava/app/routes.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/widgets/auth/custom_arch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgclr,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 169.h),
            SvgPicture.asset(
              'assets/logos/app_logo.svg',
              // height: 65.h,
            ),
            SizedBox(height: 7.h),
            SvgPicture.asset(
              'assets/logos/fava.svg',
              // height: 32.h,
            ),
            SizedBox(height: 13.h),
            Text(
              "You Got Me. I Got You.",
              style: AppTextStyles.futuraDemi600.copyWith(
                fontSize: 20.sp,
                color: AppColors.coralDark,
              ),
            ),
            SizedBox(height: 39.h),
            _buildInfoContainer(context),
            SizedBox(height: 169.h),
            CircularButtonWithArc(buttonclr: AppColors.buttonclr, onPressed: () => context.pushNamed(AppRoute.onboarding2.name)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.coralMedium,
          width: 1.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 30.w,
          right: 27.w,
          top: 14.h,
          bottom: 19.h,
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.coralLight,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(18.w),
                child: SvgPicture.asset(
                  "assets/icons/hollow_heart.svg",
                  // width: 22.w,
                  // height: 22.h,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Community First",
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 24.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Connect with trusted neighbors, parents, and friends - share support when it matters most.",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.grayDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

