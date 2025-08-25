import 'package:fava/screens/auth/forgot_password_screen.dart';
import 'package:fava/screens/auth/new_password.dart';
import 'package:fava/screens/auth/onboarding_screen_2.dart';
import 'package:fava/screens/community/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/onboarding_screen1.dart';
import '../screens/community/feed_screen.dart';
import '../screens/direct_requests/UpdatesRequestAcceptedViewDetailsScreen.dart';
import '../screens/groups/groups_screen.dart';
import '../screens/profile/profile_screen.dart';

enum AppRoute {
  login('/login'),
  signup('/signup'),
  onboarding1('/onboarding1'),
  onboarding2('/onboarding2'),
  home('/'),
  feed('/feed'),
  forgotPassword('/forgot-password'),
  setNewPassword('/new-password'),
  updatesrequestacceptedviewdetailsscreen('/updatesrequestacceptedviewdetailsscreen'),
  userProfileScreen('/user-profile-screen'),
  myGroupsScreen('/my-groups-screen');

  final String path;
  const AppRoute(this.path);
}

class AppRoutes {
  static GoRouter router = GoRouter(
    initialLocation: AppRoute.updatesrequestacceptedviewdetailsscreen.path,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoute.myGroupsScreen.path,
        name: AppRoute.myGroupsScreen.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const MyGroupsScreen(),
        ),
      ),

      GoRoute(
        path: AppRoute.userProfileScreen.path,
        name: AppRoute.userProfileScreen.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const UserProfileScreen(),
        ),
      ),

      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const LoginScreen(),
        ),
      ),
      
      GoRoute(
        path: AppRoute.setNewPassword.path,
        name: AppRoute.setNewPassword.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const SetNewPassword(),
        ),
      ),

      GoRoute(
        path: AppRoute.updatesrequestacceptedviewdetailsscreen.path,
        name: AppRoute.updatesrequestacceptedviewdetailsscreen.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const  Updatesrequestacceptedviewdetailsscreen(),
        ),
      ),



      GoRoute(
        path: AppRoute.signup.path,
        name: AppRoute.signup.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.forgotPassword.path,
        name: AppRoute.forgotPassword.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.onboarding1.path,
        name: AppRoute.onboarding1.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const OnboardingScreen1(),
        ),
      ),
      GoRoute(
        path: AppRoute.onboarding2.path,
        name: AppRoute.onboarding2.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const OnboardingScreen2(),
        ),
      ),
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.feed.path,
        name: AppRoute.feed.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const FeedScreen(),
        ),
      ),
    ],
    errorBuilder: (context, state) => CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Error')),
      child: Center(child: Text('Page not found: ${state.uri.path}')),
    ),
  );

  static CupertinoPage<dynamic> _buildCupertinoPage({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) {
    return CupertinoPage(key: state.pageKey, child: child);
  }

  // Navigation helper methods
  static void go(BuildContext context, AppRoute route) {
    context.go(route.path);
  }

  static void push(BuildContext context, AppRoute route) {
    context.push(route.path);
  }

  static void goNamed(BuildContext context, AppRoute route) {
    context.goNamed(route.name);
  }

  static void pushNamed(BuildContext context, AppRoute route) {
    context.pushNamed(route.name);
  }

  static void pop(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoute.home.path);
    }
  }

  static bool canPop(BuildContext context) => context.canPop();
}