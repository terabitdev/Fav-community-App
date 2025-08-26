import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';

class CustomSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? hintColor;
  final Color? iconColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool enabled;

  const CustomSearchField({
    super.key,
    this.hintText = 'Search...',
    this.onChanged,
    this.controller,
    this.height,
    this.contentPadding,
    this.fillColor,
    this.hintColor,
    this.iconColor,
    this.suffixIcon,
    this.prefixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 36.h,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        enabled: enabled,
        decoration: InputDecoration(
          filled: true,
          suffixIcon: suffixIcon ?? Icon(Icons.search, color: iconColor ?? hintxtclr),
          prefixIcon: prefixIcon,
          fillColor: fillColor ?? txtfieldbgclr,
          hintText: hintText,
          hintStyle: AppTextStyles.futuraBook400.copyWith(
            color: hintColor ?? hintxtclr,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: contentPadding ?? EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 0,
          ),
        ),
      ),
    );
  }
}