import 'package:fava/core/constants/assets.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/validators.dart';
import 'package:fava/providers/request_provider.dart';
import 'package:fava/widgets/auth/custom_text_field.dart';
import 'package:fava/widgets/common/location_selection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RequestDetailsSection extends StatelessWidget {
  final RequestProvider requestProvider;

  const RequestDetailsSection({super.key, required this.requestProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          labelText: "Title",
          hintText: "Enter title",
          controller: requestProvider.titleController,
          validator: AppValidators.validateTitle,
        ),
        SizedBox(height: 10.h),
        CustomTextFormField(
          
          labelText: "Description",
          maxLines: 8,
          controller: requestProvider.descriptionController,
          validator: AppValidators.validateDescription,
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationSelectionWidget(
                    labelText: "Destination",
                    hintText: "Enter destination",
                    provider: requestProvider,
                    initialValue: requestProvider.destinationAddress,
                    validationError: requestProvider.destinationError,
                    onLocationSelected: (address, position) {
                      requestProvider.setDestinationLocation(address, position);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationSelectionWidget(
                    labelText: "Pick Up",
                    hintText: "Enter pickup location",
                    initialValue: requestProvider.pickupAddress,
                    validationError: requestProvider.pickupError,
                    onLocationSelected: (address, position) {
                      requestProvider.setPickupLocation(address, position);
                    },
                    provider: requestProvider,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PaymentSection extends StatelessWidget {
  final RequestProvider requestProvider;

  const PaymentSection({super.key, required this.requestProvider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment',
          style: AppTextStyles.futuraDemi500.copyWith(fontSize: 16.sp),
        ),
        SizedBox(height: 10.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Offer Payment',
                  style: AppTextStyles.futuraBook400.copyWith(fontSize: 16.sp),
                ),
                Switch(
                  value: requestProvider.offerPayment,
                  onChanged: requestProvider.setOfferPayment,
                  activeColor: AppColors.buttonclr,
                ),
              ],
            ),
            Text(
              "Suggest a fee for this favor",
              style: AppTextStyles.futuraBook400.copyWith(
                fontSize: 12.sp,
                color: AppColors.hintxtclr,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        if (requestProvider.offerPayment)
          CustomTextFormField(
            labelText: "Suggested Fee",
            labelTextStyle: AppTextStyles.futuraBook400.copyWith(
              fontSize: 16.sp,
            ),
            hintText: "Enter Amount",
            controller: requestProvider.suggestedFeeController,
            prefixIcon: Icon(
              Icons.attach_money_rounded,
              color: AppColors.buttonclr,
            ),
          ),
      ],
    );
  }
}

class GroupsSection extends StatelessWidget {
  const GroupsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Groups',
          style: AppTextStyles.futuraDemi500.copyWith(fontSize: 16.sp),
        ),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.buttonclr, width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.asset(
                  AppAssets.sendDirectly,
                  width: 20.w,
                  height: 20.h,
                  colorFilter: ColorFilter.mode(
                    AppColors.buttonclr,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(
                  width: 185.w,
                  child: Text(
                    'Lincoln Elementary - 4th Grade 2026 - 2027',
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                Text(
                  'Change',
                  style: AppTextStyles.futuraBook400.copyWith(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          textAlign: TextAlign.center,
          'Requests will be posted on these groups only. Once someone accepts it will be removed from the feed',
          style: AppTextStyles.futuraBook400.copyWith(
            fontSize: 12.sp,
            color: AppColors.hintxtclr,
          ),
        ),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'People You May Know',
          style: AppTextStyles.futuraDemi500.copyWith(fontSize: 16.sp),
        ),
        SizedBox(height: 10.h),
        ListTile(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minVerticalPadding: 0,
          leading: CircleAvatar(
            radius: 20.r,
            child: SvgPicture.asset(AppAssets.profile),
          ),
          title: Text(
            "John Doe",
            style: AppTextStyles.futuraDemi500.copyWith(fontSize: 14.sp),
          ),
          trailing: SvgPicture.asset(AppAssets.checked),
        ),
        SizedBox(height: 12.h),
        Text(
          textAlign: TextAlign.center,
          'Requests will be sent to the selected person. Once accepted, it will be removed.',
          style: AppTextStyles.futuraBook400.copyWith(
            fontSize: 12.sp,
            color: AppColors.hintxtclr,
          ),
        ),
      ],
    );
  }
}
