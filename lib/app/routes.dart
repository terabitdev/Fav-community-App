import 'package:fava/screens/Pricacy/contact_us_screen.dart';
import 'package:fava/screens/Pricacy/help_and_support_screen.dart';
import 'package:fava/screens/auth/forgot_password_screen.dart';
import 'package:fava/screens/auth/new_password.dart';
import 'package:fava/screens/auth/onboarding_screen_2.dart';
import 'package:fava/screens/community/home_screen.dart';
import 'package:fava/screens/direct_requests/direct_request_screen.dart';
import 'package:fava/screens/direct_requests/my_requests_screen.dart';
import 'package:fava/screens/direct_requests/update_request_view_detail_screen.dart';
import 'package:fava/screens/notifications/notifications_screen.dart';
import 'package:fava/screens/Pricacy/privacy_screen.dart';
import 'package:fava/screens/profile/payment_methods_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/onboarding_screen1.dart';
import '../screens/community/feed_screen.dart';
import '../screens/groups/GroupSettingAdminScreen.dart';
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
  updatesrequestacceptedviewdetailsscreen('/updatesrequestacceptedviewdetailsscreen',),
  userProfileScreen('/user-profile-screen'),
  myGroupsScreen('/my-groups-screen'),
  groupSettingAdminScreen('/group-setting-admin-screen'),
  createRequestScreen('/create-request'),
  paymentMethodsScreen('/payment-methods-screen'),
  notificationsScreen('/notifications-screen'),
  privacyScreen('/privacy-screen'),
  helpAndSupportScreen('/help-and-support-screen'),
  contactUsScreen('/contact-us-screen'),
  myRequestsScreen('/my-requests-screen');

  final String path;
  const AppRoute(this.path);
}

class AppRoutes {
  static GoRouter router = GoRouter(
    initialLocation: AppRoute.home.path,
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
        path: AppRoute.contactUsScreen.path,
        name: AppRoute.contactUsScreen.name,
        
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child:  ContactUsScreen(
             from: state.uri.queryParameters['from'] ?? 'send message',
          ),
        ),
      ),
       GoRoute(
        path: AppRoute.helpAndSupportScreen.path,
        name: AppRoute.helpAndSupportScreen.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const HelpAndSupportScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.notificationsScreen.path,
        name: AppRoute.notificationsScreen.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.privacyScreen.path,
        name: AppRoute.privacyScreen.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const PrivacyScreen(),
        ),
      ),

      GoRoute(
        path: AppRoute.myRequestsScreen.path,
        name: AppRoute.myRequestsScreen.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const MyRequestsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoute.paymentMethodsScreen.path,
        name: AppRoute.paymentMethodsScreen.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const PaymentMethodsScreen(),
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
          child: const Updatesrequestacceptedviewdetailsscreen(),
        ),
      ),

      GoRoute(
        path: AppRoute.groupSettingAdminScreen.path,
        name: AppRoute.groupSettingAdminScreen.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: const GroupSettingAdminScreen(),
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
      GoRoute(
        path: AppRoute.createRequestScreen.path,
        name: AppRoute.createRequestScreen.name,
        pageBuilder: (context, state) => _buildCupertinoPage(
          context: context,
          state: state,
          child: CreateRequestScreen(
            requestType: state.uri.queryParameters['requestType'] ?? 'Ride',
          ),
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
