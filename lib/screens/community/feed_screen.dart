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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 22.h),
            CustomAuthHeader(backButton: false),
            SizedBox(height: 17.h),
            _buildSearchField(),
            SizedBox(height: 15.h),
            const SimpleChipList(),
            SizedBox(height: 14.h),
            _buildRequestsHeader(),
            SizedBox(height: 12.h),
            Expanded(child: _buildRequestsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Consumer<FilterProvider>(
      builder: (context, filterProvider, _) {
        return SizedBox(
          height: 36.h,
          child: TextField(
            onChanged: filterProvider.setSearch,
            decoration: InputDecoration(
              filled: true,
              suffixIcon: Icon(Icons.search, color: hintxtclr),
              fillColor: txtfieldbgclr,
              hintText: 'Search requests...',
              hintStyle: AppTextStyles.futuraBook400.copyWith(color: hintxtclr),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 0,
              ),
            ),
          ),
        );
      },
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

//   String _getEmptyStateTitle(FilterProvider provider) {
//   //   if (provider.searchQuery.isNotEmpty) {
//   //     return 'No results found';
//   //   }
//   //   if (provider.selectedRequestType != 'All') {
//   //     return 'No ${provider.selectedRequestType.toLowerCase()} requests';
//   //   }
//   //   return 'No requests available';
//   // }

//   // String _getEmptyStateSubtitle(FilterProvider provider) {
//   //   if (provider.searchQuery.isNotEmpty) {
//   //     return 'Try adjusting your search terms or clearing filters to see more results.';
//   //   }
//   //   if (provider.selectedRequestType != 'All') {
//   //     String requestType = provider.selectedRequestType.toLowerCase();
//   //     if (requestType == 'errand') requestType = 'errand';
//   //     if (requestType == 'favor') requestType = 'favor';
//   //     return 'There are currently no $requestType requests in your area.';
//   //   }
//   //   return 'Check back later for new requests from your community.';
//   // }

  
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profile Screen',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Add Screen',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Notifications Screen',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Account Screen',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}








// class FeedScreen extends StatelessWidget {
//   const FeedScreen({super.key});

//   // Sample data - you can move this to a separate service/repository later
//   List<RequestData> get _sampleRequests => mockRequests;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgclr,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 22.h),
//             CustomAuthHeader(backButton: false),
//             SizedBox(height: 17.h),
//             SizedBox(
//               height: 36.h,
//               child: TextField(
//                 decoration: InputDecoration(
//                   filled: true,
//                   suffixIcon: Icon(Icons.search, color: hintxtclr),
//                   fillColor: txtfieldbgclr,
//                   hintText: 'Search',
//                   hintStyle: AppTextStyles.futuraBook400.copyWith(
//                     color: hintxtclr,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.r),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 16.w,
//                     vertical: 0,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 15.h),
//             SimpleChipList(
//               chipTitles: const ['All', 'Ride', 'Errands', 'Favors', 'Others'],
//             ),
//             SizedBox(height: 14.h),
//             Text(
//               "Requests",
//               style: AppTextStyles.futuraDemi.copyWith(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             SizedBox(height: 12.h),
//             // REPLACED: The Card widget with ListView.builder showing RequestCards
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _sampleRequests.length,
//                 itemBuilder: (context, index) {
//                   final request = _sampleRequests[index];
//                   return Column(
//                     children: [
//                       RequestCard(
//                         userName: request.userName,
//                         timeAgo: request.timeAgo,
//                         requestTitle: request.requestTitle,
//                         requestDescription: request.requestDescription,
//                         distance: request.distance,
//                         price: request.price,
//                         buttonText: "I GOT YOU",
//                         onButtonPressed: () {
//                           // Handle button press for this specific request
//                           print('Button pressed for ${request.userName}');
//                         },
//                         requestType: request.requestType,
//                         profileIconAsset: 'assets/icons/profile.svg',
//                         requestTypeIconAsset:
//                             'assets/icons/${request.requestType.toLowerCase()}.svg',
//                       ),
//                       // if (index < _sampleRequests.length - 1)
//                       SizedBox(height: 12.h),
//                     ],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SimpleChipList extends StatefulWidget {
//   final List<String> chipTitles;

//   const SimpleChipList({super.key, required this.chipTitles});

//   @override
//   State<SimpleChipList> createState() => _SimpleChipListState();
// }

// class _SimpleChipListState extends State<SimpleChipList> {
//   int activeIndex = 0; // First chip is active by default

//   void _onChipTapped(int index) {
//     setState(() {
//       activeIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 24.h,
//       child: ListView.separated(
//         padding: EdgeInsets.zero,
//         physics: const BouncingScrollPhysics(),
//         shrinkWrap: true,
//         scrollDirection: Axis.horizontal,
//         itemCount: widget.chipTitles.length,
//         separatorBuilder: (context, index) => SizedBox(width: 9.w),
//         itemBuilder: (context, index) {
//           return CustomFilterChip(
//             title: widget.chipTitles[index],
//             isActive: activeIndex == index,
//             onTap: () => _onChipTapped(index),
//           );
//         },
//       ),
//     );
//   }
// }

// class FeedScreen extends StatelessWidget {
//   const FeedScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgclr,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 22.h),
//             CustomAuthHeader(backButton: false),
//             SizedBox(height: 17.h),
//             _buildSearchField(),
//             SizedBox(height: 15.h),
//             const SimpleChipList(),
//             SizedBox(height: 14.h),
//             _buildRequestsHeader(),
//             SizedBox(height: 12.h),
//             Expanded(child: _buildRequestsList()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return Consumer<FilterProvider>(
//       builder: (context, filterProvider, _) {
//         return SizedBox(
//           height: 36.h,
//           child: TextField(
//             onChanged: filterProvider.setSearch,
//             decoration: InputDecoration(
//               filled: true,
//               suffixIcon: Icon(Icons.search, color: hintxtclr),
//               fillColor: txtfieldbgclr,
//               hintText: 'Search requests...',
//               hintStyle: AppTextStyles.futuraBook400.copyWith(color: hintxtclr),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.r),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 16.w,
//                 vertical: 0,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildRequestsHeader() {
//     return Selector<FilterProvider, bool>(
//       selector: (_, provider) => provider.hasActiveFilters,
//       builder: (context, hasActiveFilters, _) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Requests",
//               style: AppTextStyles.futuraDemi.copyWith(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             if (hasActiveFilters)
//               GestureDetector(
//                 onTap: () => context.read<FilterProvider>().clearFilters(),
//                 child: Text(
//                   "Clear Filters",
//                   style: AppTextStyles.futuraBook400.copyWith(
//                     color: buttonclr,
//                     fontSize: 14.sp,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildRequestsList() {
//     return Consumer<FilterProvider>(
//       builder: (context, filterProvider, _) {
//         // Loading State
//         if (filterProvider.isLoading) {
//           return const LoadingStateWidget(
//             animationPath: 'assets/animations/loading.json',
//             title: 'Loading Requests...',
//             subtitle: 'Please wait while we fetch the latest requests',
//           );
//         }

//         // Empty State
//         if (!filterProvider.hasData) {
//           return EmptyStateWidget(
//             iconPath: 'assets/icons/app_logo.svg',
//             title: _getEmptyStateTitle(filterProvider),
//             subtitle: _getEmptyStateSubtitle(filterProvider),
//             actionText: filterProvider.hasActiveFilters
//                 ? 'Clear Filters'
//                 : null,
//             onActionPressed: filterProvider.hasActiveFilters
//                 ? filterProvider.clearFilters
//                 : null,
//           );
//         }

//         // Data State
//         return RefreshIndicator(
//           onRefresh: filterProvider.refresh,
//           child: ListView.builder(
//             physics: const AlwaysScrollableScrollPhysics(),
//             itemCount: filterProvider.requests.length,
//             itemBuilder: (context, index) {
//               final request = filterProvider.requests[index];
//               return Column(
//                 children: [
//                   RequestCard(
//                     userName: request.userName,
//                     timeAgo: request.timeAgo,
//                     requestTitle: request.requestTitle,
//                     requestDescription: request.requestDescription,
//                     distance: request.distance,
//                     price: request.price,
//                     buttonText: "I GOT YOU",
//                     onButtonPressed: () => _handleRequestAction(request),
//                     requestType: request.requestType,
//                     profileIconAsset: 'assets/icons/profile.svg',
//                     requestTypeIconAsset:
//                         'assets/icons/${request.requestType.toLowerCase()}.svg',
//                   ),
//                   SizedBox(height: 12.h),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   String _getEmptyStateTitle(FilterProvider provider) {
//     if (provider.searchQuery.isNotEmpty) {
//       return 'No results found';
//     }
//     if (provider.selectedRequestType != 'All') {
//       return 'No ${provider.selectedRequestType.toLowerCase()} requests';
//     }
//     return 'No requests available';
//   }

//   String _getEmptyStateSubtitle(FilterProvider provider) {
//     if (provider.searchQuery.isNotEmpty) {
//       return 'Try adjusting your search terms or clearing filters to see more results.';
//     }
//     if (provider.selectedRequestType != 'All') {
//       return 'There are currently no ${provider.selectedRequestType.toLowerCase()} requests in your area.';
//     }
//     return 'Check back later for new requests from your community.';
//   }

//   void _handleRequestAction(RequestData request) {
//     debugPrint('Button pressed for ${request.userName}');
//     // TODO: Implement request action logic

//     debugPrint('Button pressed for ${request.userName}');
//   }
// }

// // Refactored SimpleChipList - Now Stateless
// class SimpleChipList extends StatelessWidget {
//   const SimpleChipList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 24.h,
//       child: Selector<FilterProvider, String>(
//         selector: (_, provider) => provider.selectedRequestType,
//         builder: (context, selectedType, _) {
//           return ListView.separated(
//             padding: EdgeInsets.zero,
//             physics: const BouncingScrollPhysics(),
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             itemCount: FilterProvider.filterTypes.length,
//             separatorBuilder: (context, index) => SizedBox(width: 9.w),
//             itemBuilder: (context, index) {
//               final chipType = FilterProvider.filterTypes[index];
//               return CustomFilterChip(
//                 title: chipType,
//                 isActive: selectedType == chipType,
//                 onTap: () => context.read<FilterProvider>().setFilter(chipType),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// version 2
// class FeedScreen extends StatelessWidget {
//   const FeedScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: bgclr,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 22.h),
//             CustomAuthHeader(backButton: false),
//             SizedBox(height: 17.h),
//             _buildSearchField(),
//             SizedBox(height: 15.h),
//             const SimpleChipList(),
//             SizedBox(height: 14.h),
//             _buildRequestsHeader(),
//             SizedBox(height: 12.h),
//             Expanded(child: _buildRequestsList()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchField() {
//     return Consumer<FilterProvider>(
//       builder: (context, filterProvider, _) {
//         return SizedBox(
//           height: 36.h,
//           child: TextField(
//             onChanged: filterProvider.setSearch,
//             decoration: InputDecoration(
//               filled: true,
//               suffixIcon: Icon(Icons.search, color: hintxtclr),
//               fillColor: txtfieldbgclr,
//               hintText: 'Search requests...',
//               hintStyle: AppTextStyles.futuraBook400.copyWith(
//                 color: hintxtclr,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.r),
//                 borderSide: BorderSide.none,
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: 16.w,
//                 vertical: 0,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildRequestsHeader() {
//     return Selector<FilterProvider, bool>(
//       selector: (_, provider) => provider.hasActiveFilters,
//       builder: (context, hasActiveFilters, _) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Requests",
//               style: AppTextStyles.futuraDemi.copyWith(
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             if (hasActiveFilters)
//               GestureDetector(
//                 onTap: () => context.read<FilterProvider>().clearFilters(),
//                 child: Text(
//                   "Clear Filters",
//                   style: AppTextStyles.futuraBook400.copyWith(
//                     color: buttonclr,
//                     fontSize: 14.sp,
//                   ),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildRequestsList() {
//     return Consumer<FilterProvider>(
//       builder: (context, filterProvider, _) {
//         // Loading State
//         if (filterProvider.isLoading) {
//           return const LoadingStateWidget(
//             animationPath: 'assets/animations/loading.json',
//             title: 'Loading Requests...',
//             subtitle: 'Please wait while we fetch the latest requests',
//           );
//         }

//         // Empty State
//         if (!filterProvider.hasData) {
//           return EmptyStateWidget(
//             iconPath: 'assets/icons/empty_requests.svg',
//             title: _getEmptyStateTitle(filterProvider),
//             subtitle: _getEmptyStateSubtitle(filterProvider),
//             actionText: filterProvider.hasActiveFilters ? 'Clear Filters' : null,
//             onActionPressed: filterProvider.hasActiveFilters
//                 ? filterProvider.clearFilters
//                 : null,
//           );
//         }

//         // Data State
//         return RefreshIndicator(
//           onRefresh: filterProvider.refresh,
//           child: ListView.builder(
//             physics: const AlwaysScrollableScrollPhysics(),
//             itemCount: filterProvider.requests.length,
//             itemBuilder: (context, index) {
//               // Add bounds checking to prevent RangeError
//               if (index >= filterProvider.requests.length) {
//                 return const SizedBox.shrink();
//               }

//               final request = filterProvider.requests[index];
//               return Column(
//                 children: [
//                   RequestCard(
//                     userName: request.userName,
//                     timeAgo: request.timeAgo,
//                     requestTitle: request.requestTitle,
//                     requestDescription: request.requestDescription,
//                     distance: request.distance,
//                     price: request.price,
//                     buttonText: "I GOT YOU",
//                     onButtonPressed: () => _handleRequestAction(request),
//                     requestType: request.requestType,
//                     profileIconAsset: 'assets/icons/profile.svg',
//                     requestTypeIconAsset:
//                         'assets/icons/${request.requestType.toLowerCase()}.svg',
//                   ),
//                   SizedBox(height: 12.h),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   String _getEmptyStateTitle(FilterProvider provider) {
//     if (provider.searchQuery.isNotEmpty) {
//       return 'No results found';
//     }
//     if (provider.selectedRequestType != 'All') {
//       return 'No ${provider.selectedRequestType.toLowerCase()} requests';
//     }
//     return 'No requests available';
//   }

//   String _getEmptyStateSubtitle(FilterProvider provider) {
//     if (provider.searchQuery.isNotEmpty) {
//       return 'Try adjusting your search terms or clearing filters to see more results.';
//     }
//     if (provider.selectedRequestType != 'All') {
//       String requestType = provider.selectedRequestType.toLowerCase();
//       if (requestType == 'errand') requestType = 'errand';
//       if (requestType == 'favor') requestType = 'favor';
//       return 'There are currently no $requestType requests in your area.';
//     }
//     return 'Check back later for new requests from your community.';
//   }

//   void _handleRequestAction(RequestData request) {
//     debugPrint('Button pressed for ${request.userName}');
//     // TODO: Implement request action logic
//   }
// }

// // Refactored SimpleChipList - Now Stateless
// class SimpleChipList extends StatelessWidget {
//   const SimpleChipList({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: double.infinity,
//       height: 24.h,
//       child: Selector<FilterProvider, String>(
//         selector: (_, provider) => provider.selectedRequestType,
//         builder: (context, selectedType, _) {
//           return ListView.separated(
//             padding: EdgeInsets.zero,
//             physics: const BouncingScrollPhysics(),
//             shrinkWrap: true,
//             scrollDirection: Axis.horizontal,
//             itemCount: FilterProvider.filterTypes.length,
//             separatorBuilder: (context, index) => SizedBox(width: 9.w),
//             itemBuilder: (context, index) {
//               final chipType = FilterProvider.filterTypes[index];
//               return CustomFilterChip(
//                 title: chipType,
//                 isActive: selectedType == chipType,
//                 onTap: () => context.read<FilterProvider>().setFilter(chipType),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

//Final version
