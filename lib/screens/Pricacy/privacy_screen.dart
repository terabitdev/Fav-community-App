import 'package:fava/app/routes.dart';
import 'package:fava/core/constants/assets.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/helpers.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:fava/widgets/common/custom_LIst_tile.dart';
import 'package:fava/widgets/notifications/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
                  subtitle: "Privacy & Safety",
                ),
                SizedBox(height: 12.h),
                NotificationCard(
                  tiles: const [
                    NotificationTile(
                      title: "Everyone can view my profile",
                      notificationId: "profile",
                    ),
                    NotificationTile(
                      title: "Show my location on requests",
                      notificationId: "location",
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Delete Account",
                        style: AppTextStyles.futuraDemi500.copyWith(
                          fontSize: 16.sp,
                        ),
                      ),

                      CustomListTile(
                        leadingIcon: AppAssets.delete,
                        title: "Delete Account",
                        subtitle: "Account will be deleted once you press delete",
                        trailingWidget: CustomDeleteButton(
                          bgColor: Helpers.getRequestBgColor("errand"),
                          iconPath: AppAssets.delete,
                          onPressed: () {
                            context.pushReplacementNamed(AppRoute.login.name);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  
  }
}

class CustomDeleteButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color bgColor;
  final String iconPath;
  const CustomDeleteButton({
    super.key,
    required this.onPressed,
    required this.bgColor,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Helpers.getRequestBgColor("errand"),
          borderRadius: BorderRadius.circular(10.r),
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            "Delete",
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 10.sp,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
