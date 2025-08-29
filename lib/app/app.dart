import 'package:fava/providers/auth_provider.dart';
import 'package:fava/providers/filter_provider.dart';
import 'package:fava/providers/nav_provider.dart';
import 'package:fava/providers/notification_provider.dart';
import 'package:fava/providers/payment_provider.dart';
import 'package:fava/providers/request_provider.dart';
import 'package:fava/providers/support_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // i want to initalize my flutter_screenutils pakage here
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => MultiProvider(
        providers: [

          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => NavProvider()),
          ChangeNotifierProvider(create: (_) => FilterProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => PaymentProvider()),
          ChangeNotifierProvider(create: (_) => RequestProvider()),
          ChangeNotifierProvider(create: (_) => SupportProvider()),
        ],
        child: MaterialApp.router(
          title: 'Fava',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: AppRoutes.router,
        ),
      ),
    );
  }
}
