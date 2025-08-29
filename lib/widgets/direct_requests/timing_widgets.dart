import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/providers/request_provider.dart';
import 'package:fava/widgets/common/request_date_time_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecurringAndDaysSection extends StatelessWidget {
  final RequestProvider requestProvider;

  const RecurringAndDaysSection({
    super.key,
    required this.requestProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recurring Request Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recurring Request',
              style: AppTextStyles.futuraBook400.copyWith(fontSize: 16.sp),
            ),
            Switch(
              value: requestProvider.recurringRequest,
              onChanged: requestProvider.setRecurringRequest,
              activeColor: AppColors.buttonclr,
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // Frequency Options - only show if recurring is enabled
        if (requestProvider.recurringRequest) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FrequencyChip(
                text: 'Weekly',
                isSelected: requestProvider.selectedFrequency == 'Weekly',
                onTap: () => requestProvider.setSelectedFrequency('Weekly'),
              ),
              FrequencyChip(
                text: 'Bi Weekly',
                isSelected: requestProvider.selectedFrequency == 'Bi Weekly',
                onTap: () => requestProvider.setSelectedFrequency('Bi Weekly'),
              ),
              FrequencyChip(
                text: 'Monthly',
                isSelected: requestProvider.selectedFrequency == 'Monthly',
                onTap: () => requestProvider.setSelectedFrequency('Monthly'),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Days of the Week
          Text(
            'Days of the Week',
            style: AppTextStyles.futuraBook400.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DayChip(day: 'Mon'),
              DayChip(day: 'Tue'),
              DayChip(day: 'Wed'),
              DayChip(day: 'Thu'),
              DayChip(day: 'Fri'),
              DayChip(day: 'Sat'),
              DayChip(day: 'Sun'),
            ],
          ),
        ],
      ],
    );
  }
}

class SetStartDateSection extends StatelessWidget {
  final RequestProvider requestProvider;

  const SetStartDateSection({
    super.key,
    required this.requestProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Set Start Date',
              style: AppTextStyles.futuraBook400.copyWith(fontSize: 16.sp),
            ),
            Switch(
              value: requestProvider.setStartDate,
              onChanged: requestProvider.setStartDateEnabled,
              activeColor: AppColors.buttonclr,
            ),
          ],
        ),
        if (requestProvider.setStartDate) ...[
          SizedBox(height: 10.h),
          RequestDatePicker(
            labelText: "Start Date",
            hintText: "Next Tuesday",
            provider: requestProvider,
            prefixIcon: Icons.calendar_today_outlined,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            onDateSelected: (DateTime? selectedDate) {
              debugPrint('Selected start date: $selectedDate');
            },
          ),
        ],
      ],
    );
  }
}

class FrequencyChip extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const FrequencyChip({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36.h,
        width: 90.w,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonclr : AppColors.txtfieldbgclr,
          borderRadius: BorderRadius.circular(10.r),
          border: isSelected
              ? Border.all(color: AppColors.buttonclr, width: 1)
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 12.sp,
              color: !isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class DayChip extends StatelessWidget {
  final String day;

  const DayChip({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 29.w,
      height: 29.h,
      decoration: BoxDecoration(
        color: AppColors.txtfieldbgclr,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Center(
        child: Text(
          day,
          style: AppTextStyles.futuraBook400.copyWith(fontSize: 10.sp),
        ),
      ),
    );
  }
}