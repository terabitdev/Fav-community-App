import 'package:fava/core/constants/assets.dart';
import 'package:fava/core/constants/responsive_layout.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/widgets/common/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../core/constants/colors.dart';
import '../../providers/groups_provider.dart';
import '../../widgets/auth/custom_app_bar.dart';
import '../../widgets/groups/my_group_card.dart';

class MyGroupsScreen extends StatelessWidget {
  const MyGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupsProvider(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 17.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CreateGroupButton(
                  icon: Icons.add,
                  title: "Create Group",
                  onPressed: () {},
                ),
                CreateGroupButton(
                  icon: Icons.person_2_rounded,
                  title: "Join Group",
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              "Groups Joined",
              style: AppTextStyles.futuraDemi500.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 12.h),
            Consumer<GroupsProvider>(
              builder: (context, groupsProvider, child) {
                return Column(
                  children: groupsProvider.groups.map((group) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: MyGroupCard(
                        group: group,
                        onViewGroup: () {
                          print("View Group pressed: ${group.title}");
                        },
                        onSettings: () {
                          context.pushNamed(
                            AppRoute.groupSettingAdminScreen.name,
                          );
                          print("Group settings pressed: ${group.title}");
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyGroups extends StatefulWidget {
  const MyGroups({super.key});

  @override
  State<MyGroups> createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupsProvider(),
      child: Column(
        spacing: 20.h,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}

class CreateGroupButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onPressed;
  const CreateGroupButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 39.h,
        width: 160.w,
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.buttonclr,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 3.w),
              Text(
                title,
                style: AppTextStyles.marlinRegular400.copyWith(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
