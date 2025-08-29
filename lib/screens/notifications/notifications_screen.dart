import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:fava/widgets/notifications/notification_tile.dart';
import 'package:fava/widgets/profile/payment_methods_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  topHeight: 22,
                  title: "Payment Methods",
                  backButton: true,
                  appLogo: true,
                  subtitle: "Notification Settings",
                ),
                SizedBox(height: 12.h),

                NotificationCard(
                  tiles: const [
                    NotificationTile(
                      title: "Receive Notifications From Fava",
                      notificationId: "fava",
                    ),
                    NotificationTile(
                      title: "Message Notifications",
                      notificationId: "message",
                    ),
                    NotificationTile(
                      title: "Request Status Update",
                      notificationId: "status",
                    ),
                    NotificationTile(
                      title: "New Request Update",
                      notificationId: "push",
                    ),
                  ],
                ),

                //Make this reusable widget and the row being used should also be reusable widget
              ],
            ),
          ),
        ),
      ),
    );
  
  }
}
