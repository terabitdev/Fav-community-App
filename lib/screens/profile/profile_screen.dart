import 'package:fava/core/constants/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/utils/app_text_styles.dart';
import '../../providers/user_profile_provider.dart';
import '../../widgets/auth/custom_app_bar.dart';
import '../../widgets/common/custom_elevated_button.dart';
import '../../widgets/profile/profile_avatar.dart';
import '../../widgets/profile/profile_stats.dart';
import '../../widgets/profile/profile_quick_settings.dart';
import '../../widgets/profile/profile_menu_items.dart';
import '../../widgets/profile/support_fava_section.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileProvider(),
      child: Scaffold(
         backgroundColor: Color.fromRGBO(255, 255, 255, 1),
        body: SingleChildScrollView(
          child: Column(
            spacing: 20.h,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomAppBar(
                title: "Profile",
                backButton: false,
                appLogo: true,
              ),
              Center(
                child: ProfileAvatar(
                  name: "Emma Johnson",
                  knownAs: "Known as Emma J.",
                ),
              ),
                
              ProfileStats(
                completedCount: "24",
                rating: "4.9",
                reviewsCount: "18",
                groupsCount: "3",
              ),
                
              ProfileQuickSettings(),
                
              ProfileMenuItems(),
                
              SupportFavaSection(),
                
              SizedBox(height: 10.h),
                
              CustomElevatedButton(
                
                text: "Sign Out",
                onPressed: () {},
                width: double.infinity,
                height: 48.h,
                textStyle: AppTextStyles.marlinRegular.copyWith(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
                
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
