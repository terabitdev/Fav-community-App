import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? iconPath;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final String text;
  final Color bgColor;
  final VoidCallback? onPressed; // Made nullable for disabled state
  final bool isLoading; // Added loading state

  const CustomElevatedButton({
    super.key,
    this.width,
    required this.text,
    this.onPressed, // Can be null when loading
    this.bgColor = AppColors.buttonclr,
    this.iconPath,
    this.textStyle,
    this.height = 36,
    this.isLoading = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    // Determine if button should be disabled
    final bool isDisabled = onPressed == null || isLoading;

    // Handle colors for different states
    final Color effectiveBgColor = isDisabled
        ? (isLoading ? AppColors.buttonclr.withOpacity(0.7) : AppColors.buttonclr)
        : bgColor;

    return SizedBox(
      height: height?.h,
      width: width ?? double.infinity,
      child: ElevatedButton(
        
        style: ButtonStyle(
          
          backgroundColor: WidgetStateProperty.all(effectiveBgColor),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
          // Add elevation changes for disabled state
          elevation: WidgetStateProperty.all(0),
        ),
        onPressed: isDisabled ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  backgroundColor: Colors.white.withOpacity(0.3),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon (only show when not loading)
                  if (iconPath != null) ...[
                    SvgPicture.asset(iconPath!, width: 18.w, height: 18.h),
                    SizedBox(width: 8.w),
                  ],

                  // Text (only show when not loading)
                  Text(
                    text,
                    style:
                        textStyle ??
                        AppTextStyles.futuraBook400.copyWith(fontSize: 20.sp),
                  ),
                ],
              ),
      ),
    );
  }
}
