import 'package:fava/models/request.dart';
import 'package:fava/providers/filter_provider.dart';
import 'package:fava/widgets/auth/custom_auth_header.dart';
import 'package:fava/widgets/common/empty_state_widget.dart';
import 'package:fava/widgets/common/loading_widget.dart';
import 'package:fava/widgets/community/custom_filter_chips.dart';
import 'package:fava/widgets/community/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgclr,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15.h),
          const SimpleChipList(),
          SizedBox(height: 14.h),
          _buildRequestsHeader(),
          SizedBox(height: 12.h),
          Expanded(child: _buildRequestsList()),
        ],
      ),
    );
  }

  // Widget buildSearchField() {
  //   return Consumer<FilterProvider>(
  //     builder: (context, filterProvider, _) {
  //       return SizedBox(
  //         height: 36.h,
  //         child: TextField(
  //           onChanged: filterProvider.setSearch,
  //           decoration: InputDecoration(
  //             filled: true,
  //             suffixIcon: Icon(Icons.search, color: hintxtclr),
  //             fillColor: txtfieldbgclr,
  //             hintText: 'Search requests...',
  //             hintStyle: AppTextStyles.futuraBook400.copyWith(color: hintxtclr),
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(10.r),
  //               borderSide: BorderSide.none,
  //             ),
  //             contentPadding: EdgeInsets.symmetric(
  //               horizontal: 16.w,
  //               vertical: 0,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildRequestsHeader() {
    return Selector<FilterProvider, bool>(
      selector: (_, provider) => provider.hasActiveFilters,
      builder: (context, hasActiveFilters, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Requests",
              style: AppTextStyles.futuraDemi.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (hasActiveFilters)
              GestureDetector(
                onTap: () => context.read<FilterProvider>().clearFilters(),
                child: Text(
                  "Clear Filters",
                  style: AppTextStyles.futuraBook400.copyWith(
                    color: buttonclr,
                    fontSize: 14.sp,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRequestsList() {
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, _) {
        // Loading State
        if (filterProvider.isLoading) {
          return const LoadingStateWidget(
            animationPath: 'assets/animations/loading.json',
            title: 'Loading Requests...',
            subtitle: 'Please wait while we fetch the latest requests',
          );
        }

        // Empty State
        if (!filterProvider.hasData) {
          return EmptyStateWidget();
        }

        // Data State
        return RefreshIndicator(
          onRefresh: filterProvider.refresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: filterProvider.requests.length,
            itemBuilder: (context, index) {
              // Add bounds checking to prevent RangeError
              if (index >= filterProvider.requests.length) {
                return const SizedBox.shrink();
              }

              final request = filterProvider.requests[index];
              return Column(
                children: [
                  RequestCard(
                    userName: request.userName,
                    timeAgo: request.timeAgo,
                    requestTitle: request.requestTitle,
                    requestDescription: request.requestDescription,
                    distance: request.distance,
                    price: request.price,
                    buttonText: "I GOT YOU!",
                    onButtonPressed: () => _handleRequestAction(request),
                    requestType: request.requestType,
                    profileIconAsset: 'assets/icons/profile.svg',
                    requestTypeIconAsset:
                        'assets/icons/${request.requestType.toLowerCase()}.svg',
                  ),
                  SizedBox(height: 12.h),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _handleRequestAction(RequestData request) {
    debugPrint('Button pressed for ${request.userName}');
    // TODO: Implement request action logic
  }
}

// Refactored SimpleChipList - Now Stateless
class SimpleChipList extends StatelessWidget {
  const SimpleChipList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 24.h,
      child: Selector<FilterProvider, String>(
        selector: (_, provider) => provider.selectedRequestType,
        builder: (context, selectedType, _) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: FilterProvider.filterTypes.length,
            separatorBuilder: (context, index) => SizedBox(width: 9.w),
            itemBuilder: (context, index) {
              final chipType = FilterProvider.filterTypes[index];
              return CustomFilterChip(
                title: chipType,
                isActive: selectedType == chipType,
                onTap: () => context.read<FilterProvider>().setFilter(chipType),
              );
            },
          );
        },
      ),
    );
  }
}
