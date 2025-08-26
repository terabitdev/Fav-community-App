import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fava/core/constants/colors.dart';

class DateTimeHelper {
  // Date picker
  static Future<DateTime?> pickDate(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
  }) async {
    return await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 2)),
      helpText: helpText ?? 'Select Date',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: buttonclr,
              onPrimary: bgclr,
              surface: bgclr,
              onSurface: Colors.black87,
              secondary: successclr,
              onSecondary: bgclr,
            ),
            dialogBackgroundColor: bgclr,
          ),
          child: child!,
        );
      },
    );
  }

  // Time picker
  static Future<TimeOfDay?> pickTime(
    BuildContext context, {
    TimeOfDay? initialTime,
    String? helpText,
  }) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      helpText: helpText ?? 'Select Time',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: buttonclr,
              onPrimary: bgclr,
              surface: bgclr,
              onSurface: Colors.black87,
              secondary: successclr,
              onSecondary: bgclr,
            ),
            dialogBackgroundColor: bgclr,
          ),
          child: child!,
        );
      },
    );
  }

  // Combined date and time picker
  static Future<DateTime?> pickDateTime(
    BuildContext context, {
    DateTime? initialDateTime,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final selectedDate = await pickDate(
      context,
      initialDate: initialDateTime,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return null;

    final selectedTime = await pickTime(
      context,
      initialTime: initialDateTime != null 
          ? TimeOfDay.fromDateTime(initialDateTime)
          : null,
    );

    if (selectedTime == null) return selectedDate;

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
  }

  // Time range picker
  static Future<Map<String, TimeOfDay>?> pickTimeRange(
    BuildContext context, {
    TimeOfDay? initialStartTime,
    TimeOfDay? initialEndTime,
  }) async {
    final startTime = await showTimePicker(
      context: context,
      initialTime: initialStartTime ?? TimeOfDay.now(),
      helpText: 'Select Start Time',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: buttonclr,
              onPrimary: bgclr,
              surface: bgclr,
              onSurface: Colors.black87,
              secondary: successclr,
              onSecondary: bgclr,
            ),
            dialogBackgroundColor: bgclr,
          ),
          child: child!,
        );
      },
    );

    if (startTime == null || !context.mounted) return null;

    final endTime = await showTimePicker(
      context: context,
      initialTime: initialEndTime ?? TimeOfDay(
        hour: (startTime.hour + 2) % 24,
        minute: startTime.minute,
      ),
      helpText: 'Select End Time',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: buttonclr,
              onPrimary: bgclr,
              surface: bgclr,
              onSurface: Colors.black87,
              secondary: successclr,
              onSecondary: bgclr,
            ),
            dialogBackgroundColor: bgclr,
          ),
          child: child!,
        );
      },
    );

    if (endTime == null) return null;

    return {
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}

class DateTimeFormatter {
  // Format date only
  static String formatDate(DateTime? dateTime, {String? pattern}) {
    if (dateTime == null) return '';
    return DateFormat(pattern ?? 'MMM dd, yyyy').format(dateTime);
  }

  // Format time only
  static String formatTime(TimeOfDay? time, {bool use24Hour = false}) {
    if (time == null) return '';
    
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    
    return DateFormat(use24Hour ? 'HH:mm' : 'h:mm a').format(dateTime);
  }

  // Format date and time
  static String formatDateTime(DateTime? dateTime, {String? pattern}) {
    if (dateTime == null) return '';
    return DateFormat(pattern ?? 'MMM dd, yyyy h:mm a').format(dateTime);
  }

  // Format time range
  static String formatTimeRange(TimeOfDay? startTime, TimeOfDay? endTime, {bool use24Hour = false}) {
    if (startTime == null || endTime == null) return '';
    
    final startFormatted = formatTime(startTime, use24Hour: use24Hour);
    final endFormatted = formatTime(endTime, use24Hour: use24Hour);
    
    return '$startFormatted - $endFormatted';
  }

  // Relative date formatting (Today, Tomorrow, etc.)
  static String formatRelativeDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    
    final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (inputDate == today) {
      return 'Today';
    } else if (inputDate == tomorrow) {
      return 'Tomorrow';
    } else if (inputDate == yesterday) {
      return 'Yesterday';
    } else {
      final difference = inputDate.difference(today).inDays;
      if (difference > 0 && difference <= 7) {
        return DateFormat('EEEE').format(dateTime); // Day name
      } else {
        return formatDate(dateTime);
      }
    }
  }

  // Smart date formatting with relative dates
  static String formatSmartDate(DateTime? dateTime, {bool includeTime = false}) {
    if (dateTime == null) return '';
    
    final relativeDate = formatRelativeDate(dateTime);
    if (!includeTime) return relativeDate;
    
    final timeFormatted = formatTime(TimeOfDay.fromDateTime(dateTime));
    return '$relativeDate at $timeFormatted';
  }

  // Duration formatting
  static String formatDuration(Duration? duration) {
    if (duration == null) return '';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  // Validate if date is in the future
  static bool isFutureDate(DateTime? dateTime) {
    if (dateTime == null) return false;
    return dateTime.isAfter(DateTime.now());
  }

  // Validate if time range is valid
  static bool isValidTimeRange(TimeOfDay? startTime, TimeOfDay? endTime) {
    if (startTime == null || endTime == null) return false;
    
    final start = Duration(hours: startTime.hour, minutes: startTime.minute);
    final end = Duration(hours: endTime.hour, minutes: endTime.minute);
    
    return end > start;
  }

  // Get next occurrence of a specific day
  static DateTime getNextWeekday(int weekday) {
    final now = DateTime.now();
    int daysUntilWeekday = (weekday - now.weekday) % 7;
    if (daysUntilWeekday == 0) daysUntilWeekday = 7; // Next week if today
    
    return now.add(Duration(days: daysUntilWeekday));
  }

  // Common date patterns
  static const String shortDate = 'MMM dd';
  static const String mediumDate = 'MMM dd, yyyy';
  static const String longDate = 'EEEE, MMMM dd, yyyy';
  static const String shortTime = 'h:mm a';
  static const String longTime = 'h:mm:ss a';
  static const String shortDateTime = 'MMM dd h:mm a';
  static const String mediumDateTime = 'MMM dd, yyyy h:mm a';
  static const String longDateTime = 'EEEE, MMMM dd, yyyy h:mm a';
}