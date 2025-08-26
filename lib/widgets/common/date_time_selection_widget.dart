import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/date_time_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateSelectionWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime?)? onDateSelected;
  final IconData? prefixIcon;
  final bool useRelativeFormatting;

  const DateSelectionWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.prefixIcon,
    this.useRelativeFormatting = true,
  });

  @override
  State<DateSelectionWidget> createState() => _DateSelectionWidgetState();
}

class _DateSelectionWidgetState extends State<DateSelectionWidget> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _selectDate() async {
    final selectedDate = await DateTimeHelper.pickDate(
      context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
      widget.onDateSelected?.call(selectedDate);
    }
  }

  String get _displayText {
    if (_selectedDate == null) return widget.hintText;
    
    return widget.useRelativeFormatting
        ? DateTimeFormatter.formatSmartDate(_selectedDate)
        : DateTimeFormatter.formatDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText.isNotEmpty) ...[
          Text(
            widget.labelText,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
        ],
        SizedBox(
          height: 36.h,
          child: GestureDetector(
            onTap: _selectDate,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: txtfieldbgclr,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: _selectedDate != null ? successclr : Colors.transparent,
                  width: 1,
                ),
              ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Icon(
                    widget.prefixIcon,
                    color: _selectedDate != null ? successclr : hintxtclr,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Text(
                    _displayText,
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 12.sp,
                      color: _selectedDate != null ? grayDark : hintxtclr,
                    ),
                  ),
                ),
                if (_selectedDate != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = null;
                      });
                      widget.onDateSelected?.call(null);
                    },
                    child: Icon(
                      Icons.clear,
                      color: grayMedium,
                      size: 18.sp,
                    ),
                  ),
              ],
            ),
          ),
        ),
        ),
      ],
    );
  }
}

class TimeRangeSelectionWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;
  final Function(TimeOfDay?, TimeOfDay?)? onTimeRangeSelected;
  final IconData? prefixIcon;
  final bool use24Hour;

  const TimeRangeSelectionWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    this.initialStartTime,
    this.initialEndTime,
    this.onTimeRangeSelected,
    this.prefixIcon,
    this.use24Hour = false,
  });

  @override
  State<TimeRangeSelectionWidget> createState() => _TimeRangeSelectionWidgetState();
}

class _TimeRangeSelectionWidgetState extends State<TimeRangeSelectionWidget> {
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = widget.initialStartTime;
    _endTime = widget.initialEndTime;
  }

  Future<void> _selectTimeRange() async {
    final timeRange = await DateTimeHelper.pickTimeRange(
      context,
      initialStartTime: _startTime,
      initialEndTime: _endTime,
    );

    if (timeRange != null) {
      setState(() {
        _startTime = timeRange['startTime'];
        _endTime = timeRange['endTime'];
      });
      widget.onTimeRangeSelected?.call(_startTime, _endTime);
    }
  }

  String get _displayText {
    if (_startTime == null || _endTime == null) return widget.hintText;
    
    return DateTimeFormatter.formatTimeRange(
      _startTime,
      _endTime,
      use24Hour: widget.use24Hour,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText.isNotEmpty) ...[
          Text(
            widget.labelText,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
        ],
        SizedBox(
          height: 36.h,
          child: GestureDetector(
            onTap: _selectTimeRange,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: txtfieldbgclr,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: (_startTime != null && _endTime != null) ? successclr : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Icon(
                    widget.prefixIcon,
                    color: (_startTime != null && _endTime != null) ? successclr : hintxtclr,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Text(
                    _displayText,
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 14.sp,
                      color: (_startTime != null && _endTime != null) ? Colors.black87 : hintxtclr,
                    ),
                  ),
                ),
                if (_startTime != null && _endTime != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _startTime = null;
                        _endTime = null;
                      });
                      widget.onTimeRangeSelected?.call(null, null);
                    },
                    child: Icon(
                      Icons.clear,
                      color: grayMedium,
                      size: 18.sp,
                    ),
                  ),
              ],
            ),
          ),
        ),
        ),
      ],
    );
  }
}

class DateTimeSelectionWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final DateTime? initialDateTime;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime?)? onDateTimeSelected;
  final IconData? prefixIcon;
  final bool useRelativeFormatting;

  const DateTimeSelectionWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    this.initialDateTime,
    this.firstDate,
    this.lastDate,
    this.onDateTimeSelected,
    this.prefixIcon,
    this.useRelativeFormatting = true,
  });

  @override
  State<DateTimeSelectionWidget> createState() => _DateTimeSelectionWidgetState();
}

class _DateTimeSelectionWidgetState extends State<DateTimeSelectionWidget> {
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime;
  }

  Future<void> _selectDateTime() async {
    final selectedDateTime = await DateTimeHelper.pickDateTime(
      context,
      initialDateTime: _selectedDateTime ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
    );

    if (selectedDateTime != null) {
      setState(() {
        _selectedDateTime = selectedDateTime;
      });
      widget.onDateTimeSelected?.call(selectedDateTime);
    }
  }

  String get _displayText {
    if (_selectedDateTime == null) return widget.hintText;
    
    return widget.useRelativeFormatting
        ? DateTimeFormatter.formatSmartDate(_selectedDateTime, includeTime: true)
        : DateTimeFormatter.formatDateTime(_selectedDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText.isNotEmpty) ...[
          Text(
            widget.labelText,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 4.h),
        ],
        SizedBox(
          height: 36.h,
          child: GestureDetector(
            onTap: _selectDateTime,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: txtfieldbgclr,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: _selectedDateTime != null ? successclr : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null) ...[
                  Icon(
                    widget.prefixIcon,
                    color: _selectedDateTime != null ? successclr : hintxtclr,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: Text(
                    _displayText,
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 14.sp,
                      color: _selectedDateTime != null ? Colors.black87 : hintxtclr,
                    ),
                  ),
                ),
                if (_selectedDateTime != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDateTime = null;
                      });
                      widget.onDateTimeSelected?.call(null);
                    },
                    child: Icon(
                      Icons.clear,
                      color: grayMedium,
                      size: 18.sp,
                    ),
                  ),
              ],
            ),
          ),
        ),
        ),
      ],
    );
  }
}