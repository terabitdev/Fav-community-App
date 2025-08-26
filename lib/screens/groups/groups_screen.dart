import 'package:fava/core/constants/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../core/constants/colors.dart';
import '../../providers/groups_provider.dart';
import '../../widgets/auth/custom_auth_header.dart';
import '../../widgets/groups/my_group_card.dart';

class MyGroupsScreen extends StatefulWidget {
  const MyGroupsScreen({super.key});

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GroupsProvider(),
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05),
            child: SingleChildScrollView(
              child: Column(
                spacing: 20.h,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAuthHeader(backButton: true, title: 'My Groups'),
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
                                context.pushNamed(AppRoute.groupSettingAdminScreen.name);
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
          ),
        ),
      ),
    );
  }

}
