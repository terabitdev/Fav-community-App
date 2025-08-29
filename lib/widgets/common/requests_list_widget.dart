import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fava/models/request.dart';
import 'package:fava/widgets/common/empty_state_widget.dart';
import 'package:fava/widgets/community/request_card.dart';

class RequestsListWidget extends StatelessWidget {
  final List<RequestData> requests;
  final bool isLoading;
  final bool hasData;
  final String? error;
  final Future<void> Function() onRefresh;
  final void Function(RequestData)? onRequestAction;
  final String buttonText;
  final String loadingTitle;
  final String loadingSubtitle;

  const RequestsListWidget({
    super.key,
    required this.requests,
    required this.isLoading,
    required this.hasData,
    this.error,
    required this.onRefresh,
    this.onRequestAction,
    this.buttonText = "I GOT YOU!",
    this.loadingTitle = 'Loading Requests...',
    this.loadingSubtitle = 'Please wait while we fetch the latest requests',
  });

  @override
  Widget build(BuildContext context) {
    // Loading State
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              loadingTitle,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            Text(
              loadingSubtitle,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Error State
    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error!,
              style: TextStyle(
                color: Colors.red,
                fontSize: 16.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: onRefresh,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Empty State
    if (!hasData) {
      return EmptyStateWidget();
    }

    // Data State
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: requests.length,
        itemBuilder: (context, index) {
          // Add bounds checking to prevent RangeError
          if (index >= requests.length) {
            return const SizedBox.shrink();
          }

          final request = requests[index];
          return Column(
            children: [
              RequestCard(
                userName: request.userName,
                timeAgo: request.timeAgo,
                requestTitle: request.requestTitle,
                requestDescription: request.requestDescription,
                distance: request.distance,
                price: request.price,
                buttonText: buttonText,
                onButtonPressed: () => onRequestAction?.call(request),
                requestType: request.requestType,
                profileIconAsset: 'assets/icons/profile.svg',
                requestTypeIconAsset: 'assets/icons/${request.requestType.toLowerCase()}.svg',
              ),
              SizedBox(height: 12.h),
            ],
          );
        },
      ),
    );
  }
}