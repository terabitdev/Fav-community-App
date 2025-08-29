import 'package:fava/app/routes.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/widgets/auth/custom_arch_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgclr,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 52.h),
            SvgPicture.asset(
              'assets/logos/app_logo.svg',
              // height: 65.h,
            ),
            SizedBox(height: 38.h),
            _buildImageStack(context),
            SizedBox(height: 38.h),
            _buildTextContent(context),
            SizedBox(height: 64.h),
            CircularButtonWithArc(
              buttonclr: AppColors.buttonclr,
              onPressed: () => context.goNamed(AppRoute.home.name),
              size: 0.25,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageStack(BuildContext context) {
    return Stack(
      children: [
        Positioned(child: SvgPicture.asset("assets/images/onboarding1.svg")),
        Positioned(
          bottom: 23.h,
          left: 0,
          right: 0,
          child: SvgPicture.asset(
            "assets/images/onboarding2.svg",
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Column(
        children: [
          Text(
            textAlign: TextAlign.center,
            "Join Your Local Community",
            style: AppTextStyles.futuraDemi.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 24.sp,
              // height: 1.2,
            ),
          ),
          SizedBox(height: 9.h),
          Text(
            textAlign: TextAlign.center,
            "They say it takes a village. FAVA brings yours together to post requests, offer help, and build a stronger community.",
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 16.sp,
              height: 1.2,
              color: AppColors.grayDark,
            ),
          ),
        ],
      ),
    );
  }
}
