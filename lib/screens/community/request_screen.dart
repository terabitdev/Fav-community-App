import 'package:fava/app/routes.dart';
import 'package:fava/core/constants/assets.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final requestTypes = Helpers.getRequestTypes();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Text(
            "Requests",
            style: AppTextStyles.futuraDemi.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12.h),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 23.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.0,
              padding: EdgeInsets.all(8.w),
              children: List.generate(requestTypes.length, (index) {
                final requestType = requestTypes[index];
                return GestureDetector(
                  onTap: () => context.pushNamed(
                    AppRoute.createRequestScreen.name,
                    queryParameters: {'requestType': requestType.title},
                  ),
                  child: RequestTypeWidget(
                    bgcolor: requestType.backgroundColor,
                    iconpath: requestType.icon,
                    title: requestType.title,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class RequestTypeWidget extends StatelessWidget {
  final Color bgcolor;
  final String iconpath;
  final String title;

  const RequestTypeWidget({
    super.key,
    required this.bgcolor,
    required this.iconpath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the title is "Other" to set different icon size
    final bool isOther = title.toLowerCase() == 'others';

    return Container(
      height: 135.h,
      width: 135.h,
      decoration: BoxDecoration(
        color: bgcolor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 6.3,
            color: Colors.black.withOpacity(0.15),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isOther ? AppAssets.others1 : iconpath,
            
            height: isOther ? 10.h : 30.h,
            // width: isOther ? 30.w : 30.w,
          ),
          SizedBox(height: 5.h),
          Text(
            title,
            style: AppTextStyles.futuraBook400.copyWith(fontSize: 15.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
