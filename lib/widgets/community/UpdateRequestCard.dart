import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/widgets/common/custom_elevated_button.dart';
class UpdateRequestCard extends StatelessWidget {
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
  final String acceptedBy; // New field for accepted by

  const UpdateRequestCard({
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
    required this.acceptedBy,
  });

  @override
  Widget build(BuildContext context) {
    Color getRequestColor(String requestType) {
      switch (requestType.toLowerCase()) {
        case "errand":
          return AppColors.errandClr;
        case "favor":
          return AppColors.favorClr;
        case "ride":
          return AppColors.rideClr;
        default:
          return AppColors.othersClr; // fallback
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
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
            // Profile Section
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              visualDensity: VisualDensity.compact,
              minVerticalPadding: 0,
              leading: CircleAvatar(
                radius: 20.r,
               // backgroundColor: Color(0xFF4A90E2),
                child: SvgPicture.asset(profileIconAsset, width: 33.w,height: 33.h,),
              ),
              title: Text(
                userName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: AppTextStyles.futuraDemi.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
              horizontalTitleGap: 12.w,
              subtitle: Text(
                timeAgo,
                style: AppTextStyles.futuraBook400.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grayMedium,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Request Accepted By
            RichText(
              text: TextSpan(
                style: AppTextStyles.futuraDemi.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(text: "Request Accepted By: "),
                  TextSpan(
                    text: acceptedBy,
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Request Type
            Row(
              children: [
                Text(
                  "Request Type: ",
                  style: AppTextStyles.futuraDemi.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: getRequestColor(requestType).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 4.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        requestTypeIconAsset,
                        width: 12.w,
                        height: 12.h,
                        color: getRequestColor(requestType),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        requestType,
                        style: AppTextStyles.futuraBook400.copyWith(
                          fontSize: 12.sp,
                          color: getRequestColor(requestType),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Title
            RichText(
              text: TextSpan(
                style: AppTextStyles.futuraDemi.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(text: "Title: "),
                  TextSpan(
                    text: requestTitle,
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.darkGray,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Description
            Text(
              "Description:",
              style: AppTextStyles.futuraDemi.copyWith(
                fontSize: 14.sp,
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 8.h),

            Text(
              requestDescription,
              style: AppTextStyles.futuraBook400.copyWith(
                fontSize: 14.sp,
                color: AppColors.darkGray,
                height: 1.4,
              ),
            ),

            SizedBox(height: 16.h),

            // Offered and Distance Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Offered
                Row(
                  children: [
                    Text(
                      "Offered: ",
                      style: AppTextStyles.futuraDemi.copyWith(
                        fontSize: 14.sp,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color:AppColors.lightYellow,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      child: Text(
                        price,
                        style: AppTextStyles.futuraBook400.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.buttonclr,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Distance
            Row(
              children: [
                Text(
                  "Distance: ",
                  style: AppTextStyles.futuraDemi.copyWith(
                    fontSize: 14.sp,
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Container(

                  decoration: BoxDecoration(
                    color:AppColors.lightGray,
                    borderRadius: BorderRadius.circular(5.r),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/location1.svg',
                          width: 14.w,
                          height: 14.h,
                          color: AppColors.errorclr,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          distance,
                          style: AppTextStyles.futuraBook400.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),

            SizedBox(height: 24.h),

            // Message Button
            CustomElevatedButton(
              text: buttonText,
              onPressed: onButtonPressed,
              width: double.infinity,
              height: 48.h,
              textStyle: AppTextStyles.marlinRegular400.copyWith(
                color: AppColors.bgclr,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}