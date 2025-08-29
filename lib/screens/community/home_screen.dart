import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/navigation/bottom_nav_bar.dart';
import 'package:fava/providers/filter_provider.dart';
import 'package:fava/providers/nav_provider.dart';
import 'package:fava/screens/community/request_screen.dart';
import 'package:fava/screens/community/feed_screen.dart';
import 'package:fava/screens/groups/groups_screen.dart';
import 'package:fava/screens/profile/profile_screen.dart';
import 'package:fava/screens/updates/updates_screen.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  final List<IconData> iconList = [
    Icons.home,
    Icons.person,
    Icons.add,
    Icons.notifications,
    Icons.account_circle,
  ];

  final List<String> titles = [
    'Feed',
    'Groups',
    'Request',
    'Updates',
    'Profile',
  ];

  final List<Widget> screens = [
    const FeedScreen(),
    const MyGroupsScreen(),
    const RequestScreen(),
    const UpdateScreen(),
    const UserProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(
        milliseconds: 300,
      ), // Slightly longer for smooth float
      vsync: this,
      value: 1.0, // Start at floated position
    );

    // Set the float controller in the provider after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavProvider>(
        context,
        listen: false,
      ).setFloatController(_floatController);
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavProvider>(
      builder: (context, navProvider, child) {
        return Scaffold(
          extendBody: true,
          backgroundColor: AppColors.bgclr,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // if the profile page is not selected show this column
                  navProvider.selectedIndex != 4
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomAppBar(
                                backButton: false,
                                title: "Feed Screen",
                                appLogo: true,
                              ),
                              SizedBox(height: 17.h),
                              buildSearchField(),
                            ],
                          ),
                        )
                      : SizedBox.shrink(),
                  Expanded(
                    child: PageView(
                      controller: navProvider.pageController,
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable swipe navigation
                      children: screens,
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            iconList: iconList,
            titles: titles,
          ),
        );
      },
    );
  }
}

Widget buildSearchField() {
  return Consumer<FilterProvider>(
    builder: (context, filterProvider, _) {
      return SizedBox(
        height: 36.h,
        child: TextField(
          onChanged: filterProvider.setSearch,
          decoration: InputDecoration(
            filled: true,
            suffixIcon: Icon(Icons.search, color: AppColors.hintxtclr),
            fillColor: AppColors.txtfieldbgclr,
            hintText: 'Search requests...',
            hintStyle: AppTextStyles.futuraBook400.copyWith(
              color: AppColors.hintxtclr,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
          ),
        ),
      );
    },
  );
}
