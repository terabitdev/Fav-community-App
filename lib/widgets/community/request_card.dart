import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/widgets/common/custom_elevated_button.dart';

class RequestCard extends StatelessWidget {
  final String userName;
  final String timeAgo;
  final String requestTitle;
  final String requestDescription;
  final String distance;
  final String price;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String requestType;
  final String profileIconAsset;
  final String requestTypeIconAsset;

  const RequestCard({
    super.key,
    required this.userName,
    required this.timeAgo,
    required this.requestTitle,
    required this.requestDescription,
    required this.distance,
    required this.price,
    required this.buttonText,
    required this.onButtonPressed,
    required this.requestType,
    required this.profileIconAsset,
    required this.requestTypeIconAsset,
  });

  @override
  Widget build(BuildContext context) {
    Color getRequestColor(String requestType) {
      switch (requestType.toLowerCase()) {
        case "errand":
          return errandClr;
        case "favor":
          return favorClr;
        case "ride":
          return rideClr;
        default:
          return othersClr; // fallback
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bgclr,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            offset: Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              visualDensity: VisualDensity.compact,
              minVerticalPadding: 0,
              leading: CircleAvatar(
                child: SvgPicture.asset(profileIconAsset, width: 33.w),
              ),
              title: Text(
                userName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyles.futuraDemi.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              horizontalTitleGap: 12.w,
              subtitle: Text(
                timeAgo,
                style: AppTextStyles.futuraBook400.copyWith(
                  fontSize: 10.sp,
                  color: hintxtclr,
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    // width: 57.w,
                    // height: 15.h,
                    decoration: BoxDecoration(
                      color: getRequestColor(requestType).withOpacity(0.25),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 1.h,
                        horizontal: 9.w,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            requestTypeIconAsset,
                            width: 11.w,
                            height: 11.h,
                            color: getRequestColor(requestType),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            requestType,
                            style: AppTextStyles.futuraBook400.copyWith(
                              fontSize: 13.sp,
                              color: getRequestColor(requestType),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 21.w),
                  SvgPicture.asset(
                    'assets/icons/cancel.svg',
                    width: 15.w,
                    height: 15.h,
                  ),
                ],
              ),
            ),
            SizedBox(height: 19.h),
            Text(
              requestTitle,
              style: AppTextStyles.futuraDemi.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 62.h,
              width: double.infinity,
              child: Text(
                requestDescription,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: AppTextStyles.futuraBook400.copyWith(
                  fontSize: 15.sp,
                  color: Color.fromRGBO(94, 94, 94, 1),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  // width: 106.w,
                  // height: 24.h,
                  decoration: BoxDecoration(
                    color: errorclr.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 6.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/location1.svg',
                          width: 11.w,
                          height: 11.h,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          distance,
                          style: AppTextStyles.futuraBook400.copyWith(
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // width: 56.w,
                  // height: 24.h,
                  decoration: BoxDecoration(
                    color: successclr.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 3.h,
                      horizontal: 16.w,
                    ),
                    child: Text(
                      price,
                      style: AppTextStyles.futuraBook400.copyWith(
                        fontSize: 15.sp,
                        color: successclr,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 34.h),
            CustomElevatedButton(
              text: buttonText,
              onPressed: onButtonPressed,
              width: double.infinity,
              height: 39.h,
              textStyle: AppTextStyles.marlinRegular400.copyWith(
                color: bgclr,
                fontSize: 18.sp
              ),
            ),
          ],
        ),
      ),
    );
  }
}
