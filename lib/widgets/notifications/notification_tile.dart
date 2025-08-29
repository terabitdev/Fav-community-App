import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

/// Reusable Notification Tile
class NotificationTile extends StatelessWidget {
  final String title;
  final String? notificationId;

  const NotificationTile({
    super.key,
    required this.title,
    this.notificationId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 16.sp,
            ),
          ),
        ),
        Consumer<NotificationProvider>(
          builder: (context, notificationProvider, _) {
            return Switch(
              value: notificationId != null
                  ? notificationProvider.getNotificationState(notificationId!)
                  : notificationProvider.notificationsEnabled,
              onChanged: (value) {
                if (notificationId != null) {
                  notificationProvider.toggleSpecificNotification(
                      notificationId!, value);
                } else {
                  notificationProvider.toggleNotifications(value);
                }
              },
               activeColor: AppColors.buttonclr,
              inactiveThumbColor: AppColors.grayDark,
              inactiveTrackColor: AppColors.grayLight,
            );
          },
        ),
      ],
    );
  }
}

/// Outer Card renamed to NotificationCard
class NotificationCard extends StatelessWidget {
  final List<NotificationTile> tiles;

  const NotificationCard({super.key, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgclr,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            color: const Color.fromRGBO(0, 0, 0, 0.25),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tiles,
      ),
    );
  }
}
