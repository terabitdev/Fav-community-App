import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constants/appImage.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/app_text_styles.dart';

class ProfileAvatar extends StatelessWidget {
  final String name;
  final String knownAs;

  const ProfileAvatar({super.key, required this.name, required this.knownAs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SvgPicture.asset(AppImages.profileIcon, width: 80.w, height: 80.h),
            Positioned(
              bottom: 0,
              right: 5,
              child: SvgPicture.asset(AppImages.selectedCamera),
              width: 25,
              height: 25,
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          name,
          style: AppTextStyles.futuraDemi.copyWith(
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: black,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          knownAs,
          style: AppTextStyles.futuraBook.copyWith(
            fontSize: 14.sp,
            color: darkGray,
          ),
        ),
      ],
    );
  }
}
