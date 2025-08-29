import 'package:fava/core/constants/assets.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/helpers.dart';
import 'package:fava/providers/request_provider.dart';
import 'package:fava/widgets/common/multi_image_selection_widget.dart';
import 'package:fava/widgets/direct_requests/form_sections.dart';
import 'package:fava/widgets/direct_requests/timing_widgets.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:fava/widgets/common/custom_elevated_button.dart';
import 'package:fava/widgets/common/horizontal_divider.dart';
import 'package:fava/widgets/common/request_type_chip.dart';
import 'package:fava/widgets/common/request_date_time_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CreateRequestScreen extends StatelessWidget {
  final String requestType;

  const CreateRequestScreen({super.key, required this.requestType});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = RequestProvider();
        provider.setInitialRequestType(requestType);
        return provider;
      },
      child: Consumer<RequestProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: AppColors.bgclr,
            body: SafeArea(
              child: Form(
                key: provider.formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      CustomAppBar(
                        backButton: true,
                        title: requestType,
                        appLogo: false,
                        topHeight: 25,
                      ),
                      SizedBox(height: 12.h),

                      // Request Type Selection (for "send directly" only)
                      if (requestType.toLowerCase() == "send directly") ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: Helpers.getRequestTypes()
                              .where(
                                (requestTypeData) =>
                                    requestTypeData.title.toLowerCase() !=
                                    'send directly',
                              )
                              .map((requestTypeData) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                  ),
                                  child: RequestTypeChip(
                                    requestType: requestTypeData.title,
                                    requestTypeIconAsset: requestTypeData.icon,
                                    isSelected:
                                        provider.selectedRequestType ==
                                        requestTypeData.title,
                                    onTap: () =>
                                        provider.setSelectedRequestType(
                                          requestTypeData.title,
                                        ),
                                  ),
                                );
                              })
                              .toList(),
                        ),
                        // Error message for request type validation
                        if (provider.requestTypeError != null) ...[
                          SizedBox(height: 8.h),
                          Text(
                            provider.requestTypeError!,
                            style: AppTextStyles.futuraBook400.copyWith(
                              fontSize: 12.sp,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        SizedBox(height: 16.h),
                      ],

                      Text(
                        'Request Details',
                        style: AppTextStyles.futuraDemi.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),

                      // Section 1 - Request Details
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RequestDetailsSection(requestProvider: provider),
                            SizedBox(height: 10.h),

                            // Add Reference Photo
                            Text(
                              'Add reference Photo (Optional)',
                              style: AppTextStyles.futuraDemi500.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            MultiImageSelectionWidget(
                              provider: provider,
                              maxImages: 3,
                              buttonText: "Add Photos",
                              iconPath: AppAssets.camera,
                            ),
                            SizedBox(height: 10.h),

                            // Timing Section
                            Text(
                              'Timing',
                              style: AppTextStyles.futuraDemi500.copyWith(
                                fontSize: 16.sp,
                              ),
                            ),

                            RecurringAndDaysSection(requestProvider: provider),
                            SizedBox(height: 10.h),

                            // Time picker with validation
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RequestTimePicker(
                                  labelText: "Time",
                                  hintText: "e.g., 3:00 PM",
                                  provider: provider,
                                  prefixIcon: Icons.watch_later_outlined,
                                  validationError: provider.timeError,
                                  onTimeSelected: (TimeOfDay? selectedTime) {
                                    debugPrint('Selected time: $selectedTime');
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 14.h),
                      const HorizontalDivider(),
                      SizedBox(height: 11.h),

                      // Section 2 - Start Date and Payment
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SetStartDateSection(requestProvider: provider),
                            SizedBox(height: 12.h),
                            PaymentSection(requestProvider: provider),
                          ],
                        ),
                      ),

                      SizedBox(height: 10.h),
                      const HorizontalDivider(),
                      SizedBox(height: 10.h),

                      // Section 3 - Groups/Profile and Submit
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            requestType.toLowerCase() == 'send directly'
                                ? const ProfileCard()
                                : const GroupsSection(),
                            SizedBox(height: 15.h),

                            // Submit Button with Loading State
                            CustomElevatedButton(
                              text: "Post Request",
                              textStyle: AppTextStyles.marlinRegular400
                                  .copyWith(fontSize: 16.sp),
                              isLoading: provider.isSubmitting,
                              onPressed: provider.isSubmitting
                                  ? null
                                  : () => provider.submitRequest(context),
                            ),
                            SizedBox(height: 65.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
