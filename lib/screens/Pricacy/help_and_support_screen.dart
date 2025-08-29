import 'package:fava/app/routes.dart';
import 'package:fava/core/constants/assets.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:fava/widgets/common/custom_LIst_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

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
                  title: "Help and Support",
                  backButton: true,
                  appLogo: true,
                  subtitle: "Help and Support",
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomListTile(
                        leadingIcon: AppAssets.email,
                        title: "Send Us a Message",
                        subtitle: "Let us know what’s on your mind",
                        trailingWidget: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color.fromRGBO(73, 73, 73, 1),
                        ),
                        onTap: () => context.pushNamed(
                          AppRoute.contactUsScreen.name,
                          queryParameters: {'from': 'send message'},
                        ),
                      ),
                      CustomListTile(
                        leadingIcon: AppAssets.feedBack,
                        title: "Give App feedback",
                        subtitle: "Let us know how is your experience",
                        trailingWidget: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color.fromRGBO(73, 73, 73, 1),
                        ),
                        onTap: () => context.pushNamed(
                          AppRoute.contactUsScreen.name,
                          queryParameters: {'from': 'feedback'},
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
