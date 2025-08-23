import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LoadingStateWidget extends StatelessWidget {
  final String animationPath;
  final String title;
  final String? subtitle;
  final double? animationSize;

  const LoadingStateWidget({
    super.key,
    required this.animationPath,
    this.title = 'Loading...',
    this.subtitle,
    this.animationSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 40.w,
            vertical: 32.h,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie Animation
              _buildLottieAnimation(context),
              
              SizedBox(height: 24.h),
              
              // Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.textTheme.headlineSmall?.color,
                ),
              ),
              
              // Subtitle (optional)
              if (subtitle != null) ...[
                SizedBox(height: 8.h),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLottieAnimation(BuildContext context) {
    final size = animationSize?.r ?? 120.r;
    return Lottie.asset(
      animationPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      repeat: true,
      animate: true,
    );
  }
}