import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomListTile extends StatelessWidget {
  final String leadingIcon;
  final String title;
  final String? subtitle;
  final Widget? trailingWidget;
  final VoidCallback? onTap;

  const CustomListTile({
    super.key,
    required this.leadingIcon,
    required this.title,
    this.subtitle,
    this.trailingWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
    
      contentPadding: EdgeInsets.zero,
      // onTap: onTap,
      leading: SvgPicture.asset(leadingIcon, width: 29.w, height: 27.h),
      title: Text(
        title,
        style: AppTextStyles.futuraBook400.copyWith(fontSize: 16.sp),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: AppTextStyles.futuraBook400.copyWith(
                fontSize: 12.sp,
                color: AppColors.txtfieldbgclr,
              ),
            )
          : null,
      trailing: GestureDetector(onTap: onTap, child: trailingWidget),
    );
  }
}
