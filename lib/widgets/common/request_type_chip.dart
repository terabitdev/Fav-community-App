import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RequestTypeChip extends StatelessWidget {
  final String requestType;
  final String requestTypeIconAsset;
  final bool isSelected;
  final VoidCallback? onTap;

  const RequestTypeChip({
    super.key,
    required this.requestType,
    required this.requestTypeIconAsset,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected 
              ? Helpers.getRequestColor(requestType).withOpacity(0.4)
              : Helpers.getRequestColor(requestType).withOpacity(0.25),
          borderRadius: BorderRadius.circular(5.r),
          border: isSelected 
              ? Border.all(color: Helpers.getRequestColor(requestType), width: 1.5)
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 1.h,
            horizontal: 9.w,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                requestTypeIconAsset,
                width: 11.w,
                height: 11.h,
                color: Helpers.getRequestColor(requestType),
              ),
              SizedBox(width: 4.w),
              Text(
                requestType,
                style: AppTextStyles.futuraBook400.copyWith(
                  fontSize: 13.sp,
                  color: Helpers.getRequestColor(requestType),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}