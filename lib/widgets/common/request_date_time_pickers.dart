import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/date_time_helper.dart';
import 'package:fava/providers/request_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestDatePicker extends StatelessWidget {
  final String labelText;
  final String hintText;
  final RequestProvider provider;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime?)? onDateSelected;
  final IconData? prefixIcon;
  final bool useRelativeFormatting;

  const RequestDatePicker({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.provider,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.prefixIcon,
    this.useRelativeFormatting = true,
  });

  String get _displayText {
    if (provider.selectedDateTime == null) return hintText;

    return useRelativeFormatting
        ? DateTimeFormatter.formatSmartDate(provider.selectedDateTime)
        : DateTimeFormatter.formatDate(provider.selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          
          Text(
            labelText,
            style: AppTextStyles.futuraBook400.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 4.h),
        ],
        SizedBox(
          height: 36.h,
          child: GestureDetector(
            onTap: provider.isDateTimeLoading
                ? null
                : () {
                    provider.openDatePicker(
                      context,
                      initialDate: initialDate ?? provider.selectedDateTime,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      onDateSelected: onDateSelected,
                    );
                  },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.txtfieldbgclr,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: provider.selectedDateTime != null
                      ? AppColors.buttonclr
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  if (prefixIcon != null) ...[
                    Icon(
                      prefixIcon,
                      color: provider.selectedDateTime != null
                          ? AppColors.buttonclr
                          : AppColors.hintxtclr,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    child: provider.isDateTimeLoading
                        ? Row(
                            children: [
                              SizedBox(
                                width: 16.w,
                                height: 16.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.buttonclr,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Loading...',
                                style: AppTextStyles.futuraBook400.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColors.grayMedium,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            _displayText,
                            style: AppTextStyles.futuraBook400.copyWith(
                              fontSize: 12.sp,
                              color: provider.selectedDateTime != null
                                  ? AppColors.grayDark
                                  : AppColors.hintxtclr,
                            ),
                          ),
                  ),
                  if (provider.selectedDateTime != null &&
                      !provider.isDateTimeLoading)
                    GestureDetector(
                      onTap: () {
                        provider.clearDateTime();
                        onDateSelected?.call(null);
                      },
                      child: Icon(
                        Icons.clear,
                        color: AppColors.grayMedium,
                        size: 18.sp,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (provider.dateTimeError != null) ...[
          SizedBox(height: 4.h),
          Text(
            provider.dateTimeError!,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 10.sp,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}

class RequestTimePicker extends StatelessWidget {
  final String labelText;
  final String hintText;
  final RequestProvider provider;
  final TimeOfDay? initialTime;
  final Function(TimeOfDay?)? onTimeSelected;
  final IconData? prefixIcon;
  final bool use24Hour;
  final String? validationError;

  const RequestTimePicker({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.provider,
    this.initialTime,
    this.onTimeSelected,
    this.prefixIcon,
    this.use24Hour = false,
    this.validationError,
  });

  String get _displayText {
    if (provider.selectedTime == null) return hintText;

    return DateTimeFormatter.formatTime(
      provider.selectedTime,
      use24Hour: use24Hour,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          Text(
            labelText,
            style: AppTextStyles.futuraBook400.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 4.h),
        ],
        GestureDetector(
          onTap: provider.isDateTimeLoading
              ? null
              : () {
                  provider.openTimePicker(
                    context,
                    initialTime: initialTime ?? provider.selectedTime,
                    onTimeSelected: onTimeSelected,
                  );
                },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.txtfieldbgclr,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: validationError != null
                    ? AppColors.errorclr
                    : (provider.selectedTime != null
                        ? AppColors.buttonclr
                        : Colors.transparent),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                if (prefixIcon != null) ...[
                  Icon(
                    prefixIcon,
                    color: validationError != null
                        ? AppColors.errorclr
                        : (provider.selectedTime != null
                            ? AppColors.buttonclr
                            : AppColors.hintxtclr),
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: provider.isDateTimeLoading
                      ? Row(
                          children: [
                            SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.buttonclr,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Loading...',
                              style: AppTextStyles.futuraBook400.copyWith(
                                fontSize: 12.sp,
                                color: AppColors.grayMedium,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          _displayText,
                          style: AppTextStyles.futuraBook400.copyWith(
                            fontSize: 12.sp,
                            color: provider.selectedTime != null
                                ? AppColors.grayDark
                                : AppColors.hintxtclr,
                          ),
                        ),
                ),
                if (provider.selectedTime != null && !provider.isDateTimeLoading)
                  GestureDetector(
                    onTap: () {
                      provider.clearSelectedTime();
                      onTimeSelected?.call(null);
                    },
                    child: Icon(
                      Icons.clear,
                      color: AppColors.grayMedium,
                      size: 18.sp,
                    ),
                  ),
              ],
            ),
          ),
          // child: CustomTextFormField(
          //   enabled: false,
          //   validator: AppValidators.validateTime,
          //   labelText: labelText,
          //   hintText: hintText,
          //   controller: TextEditingController(text: _displayText),
          //   prefixIcon: Icon(
          //     prefixIcon,
          //     color: provider.selectedTime != null
          //         ? AppColors.buttonclr
          //         : AppColors.hintxtclr,
          //     size: 20.sp,
          //   ),
          // ),
        ),
        if (validationError != null) ...[
          SizedBox(height: 4.h),
          Text(
            validationError!,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 10.sp,
              color: AppColors.errorclr,
            ),
          ),
        ] else if (provider.dateTimeError != null) ...[
          SizedBox(height: 4.h),
          Text(
            provider.dateTimeError!,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 10.sp,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}

class RequestDateTimePicker extends StatelessWidget {
  final String labelText;
  final String hintText;
  final RequestProvider provider;
  final DateTime? initialDateTime;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime?)? onDateTimeSelected;
  final IconData? prefixIcon;
  final bool useRelativeFormatting;

  const RequestDateTimePicker({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.provider,
    this.initialDateTime,
    this.firstDate,
    this.lastDate,
    this.onDateTimeSelected,
    this.prefixIcon,
    this.useRelativeFormatting = true,
  });

  String get _displayText {
    if (provider.selectedDateTime == null) return hintText;

    return useRelativeFormatting
        ? DateTimeFormatter.formatSmartDate(
            provider.selectedDateTime,
            includeTime: true,
          )
        : DateTimeFormatter.formatDateTime(provider.selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          Text(
            labelText,
            style: AppTextStyles.futuraBook400.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 4.h),
        ],
        SizedBox(
          height: 36.h,
          child: GestureDetector(
            onTap: provider.isDateTimeLoading
                ? null
                : () {
                    provider.openDateTimePicker(
                      context,
                      initialDateTime:
                          initialDateTime ?? provider.selectedDateTime,
                      firstDate: firstDate,
                      lastDate: lastDate,
                      onDateTimeSelected: onDateTimeSelected,
                    );
                  },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.txtfieldbgclr,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: provider.selectedDateTime != null
                      ? AppColors.buttonclr
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  if (prefixIcon != null) ...[
                    Icon(
                      prefixIcon,
                      color: provider.selectedDateTime != null
                          ? AppColors.buttonclr
                          : AppColors.hintxtclr,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    child: provider.isDateTimeLoading
                        ? Row(
                            children: [
                              SizedBox(
                                width: 16.w,
                                height: 16.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.buttonclr,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Loading...',
                                style: AppTextStyles.futuraBook400.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColors.grayMedium,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            _displayText,
                            style: AppTextStyles.futuraBook400.copyWith(
                              fontSize: 12.sp,
                              color: provider.selectedDateTime != null
                                  ? AppColors.grayDark
                                  : AppColors.hintxtclr,
                            ),
                          ),
                  ),
                  if (provider.selectedDateTime != null &&
                      !provider.isDateTimeLoading)
                    GestureDetector(
                      onTap: () {
                        provider.clearDateTime();
                        onDateTimeSelected?.call(null);
                      },
                      child: Icon(
                        Icons.clear,
                        color: AppColors.grayMedium,
                        size: 18.sp,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (provider.dateTimeError != null) ...[
          SizedBox(height: 4.h),
          Text(
            provider.dateTimeError!,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 10.sp,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}

class RequestTimeRangePicker extends StatelessWidget {
  final String labelText;
  final String hintText;
  final RequestProvider provider;
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;
  final Function(TimeOfDay?, TimeOfDay?)? onTimeRangeSelected;
  final IconData? prefixIcon;
  final bool use24Hour;

  const RequestTimeRangePicker({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.provider,
    this.initialStartTime,
    this.initialEndTime,
    this.onTimeRangeSelected,
    this.prefixIcon,
    this.use24Hour = false,
  });

  String get _displayText {
    if (provider.startTime == null || provider.endTime == null) {
      return hintText;
    }

    return DateTimeFormatter.formatTimeRange(
      provider.startTime,
      provider.endTime,
      use24Hour: use24Hour,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText.isNotEmpty) ...[
          Text(
            labelText,
            style: AppTextStyles.futuraBook400.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 4.h),
        ],
        SizedBox(
          height: 36.h,
          child: GestureDetector(
            onTap: provider.isDateTimeLoading
                ? null
                : () {
                    provider.openTimeRangePicker(
                      context,
                      initialStartTime: initialStartTime ?? provider.startTime,
                      initialEndTime: initialEndTime ?? provider.endTime,
                      onTimeRangeSelected: onTimeRangeSelected,
                    );
                  },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.txtfieldbgclr,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color:
                      (provider.startTime != null && provider.endTime != null)
                      ? AppColors.buttonclr
                      : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  if (prefixIcon != null) ...[
                    Icon(
                      prefixIcon,
                      color:
                          (provider.startTime != null &&
                              provider.endTime != null)
                          ? AppColors.buttonclr
                          : AppColors.hintxtclr,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    child: provider.isDateTimeLoading
                        ? Row(
                            children: [
                              SizedBox(
                                width: 16.w,
                                height: 16.h,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.buttonclr,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Loading...',
                                style: AppTextStyles.futuraBook400.copyWith(
                                  fontSize: 12.sp,
                                  color: AppColors.grayMedium,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            _displayText,
                            style: AppTextStyles.futuraBook400.copyWith(
                              fontSize: 12.sp,
                              color:
                                  (provider.startTime != null &&
                                      provider.endTime != null)
                                  ? AppColors.grayDark
                                  : AppColors.hintxtclr,
                            ),
                          ),
                  ),
                  if (provider.startTime != null &&
                      provider.endTime != null &&
                      !provider.isDateTimeLoading)
                    GestureDetector(
                      onTap: () {
                        provider.clearTimeRange();
                        onTimeRangeSelected?.call(null, null);
                      },
                      child: Icon(
                        Icons.clear,
                        color: AppColors.grayMedium,
                        size: 18.sp,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (provider.dateTimeError != null) ...[
          SizedBox(height: 4.h),
          Text(
            provider.dateTimeError!,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 10.sp,
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }
}
