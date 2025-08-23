import 'package:fava/core/constants/colors.dart';
import 'package:fava/navigation/bottom_nav_bar.dart';
import 'package:fava/providers/nav_provider.dart';
import 'package:fava/screens/community/feed_screen.dart';
import 'package:flutter/material.dart';
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
    'home',
    'Profile',
    'Add',
    'Notifications',
    'Account',
  ];

  final List<Widget> screens = [
    const FeedScreen(),
    const ProfileScreen(),
    const AddScreen(),
    const NotificationsScreen(),
    const AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      duration: const Duration(milliseconds: 300), // Slightly longer for smooth float
      vsync: this,
      value: 1.0, // Start at floated position
    );

    // Set the float controller in the provider after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NavProvider>(context, listen: false)
          .setFloatController(_floatController);
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
          backgroundColor: bgclr,
          body: SafeArea(
            child: PageView(
              controller: navProvider.pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
              children: screens,
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