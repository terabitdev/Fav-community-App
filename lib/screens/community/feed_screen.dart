import 'package:fava/models/request.dart';
import 'package:fava/providers/filter_provider.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:fava/widgets/common/requests_list_widget.dart';
import 'package:fava/widgets/community/custom_filter_chips.dart';
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
      backgroundColor: AppColors.bgclr,
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
                    color: AppColors.buttonclr,
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
        return RequestsListWidget(
          requests: filterProvider.requests,
          isLoading: filterProvider.isLoading,
          hasData: filterProvider.hasData,
          onRefresh: filterProvider.refresh,
          onRequestAction: _handleRequestAction,
          buttonText: "I GOT YOU!",
          loadingTitle: 'Loading Requests...',
          loadingSubtitle: 'Please wait while we fetch the latest requests',
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
