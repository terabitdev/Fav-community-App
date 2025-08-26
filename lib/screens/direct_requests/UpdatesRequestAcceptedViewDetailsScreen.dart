// import 'package:fava/core/constants/responsive_layout.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';

// import '../../app/routes.dart';
// import '../../core/constants/appImage.dart';
// import '../../core/constants/colors.dart';
// import '../../core/utils/app_text_styles.dart';
// import '../../widgets/auth/custom_auth_header.dart';
// import '../../widgets/community/UpdateRequestCard.dart';


// class Updatesrequestacceptedviewdetailsscreen extends StatefulWidget {
//   const Updatesrequestacceptedviewdetailsscreen({super.key});

//   @override
//   State<Updatesrequestacceptedviewdetailsscreen> createState() =>
//       _UpdatesrequestacceptedviewdetailsscreenState();
// }

// class _UpdatesrequestacceptedviewdetailsscreenState
//     extends State<Updatesrequestacceptedviewdetailsscreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.05),
//           child: SingleChildScrollView(
//             child: Column(
//               spacing: 10,
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CustomAuthHeader(backButton: true, title: 'View Details'),
//                 Text(
//                   'Details',
//                   style: AppTextStyles.futuraDemi.copyWith(
//                     color: black,
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 UpdateRequestCard(
//                   userName: "Emma Johnson",
//                   timeAgo: "2 hours ago",
//                   requestTitle: "Looking for a ride to downtown for groceries",
//                   requestDescription:
//                       "My car broke down. I need to go get some groceries. Is someone available to give me a ride to downtown?",
//                   distance: "0.3 miles away",
//                   price: "\$10",
//                   buttonText: "Message Paul",
//                   acceptedBy: "Paul Jack", // New parameter
//                   onButtonPressed: () {
//                     // Handle message action
//                     print("Message Paul pressed");
//                   },
//                   requestType: "favor",
//                   profileIconAsset: 'assets/icons/profile.svg',
//                   requestTypeIconAsset: 'assets/icons/favor.svg',
//                 ),
//                 UpdateRequestCard(
//                   userName: "Emma Johnson",
//                   timeAgo: "2 hours ago",
//                   requestTitle: "Looking for a ride to downtown for groceries",
//                   requestDescription:
//                       "My car broke down. I need to go get some groceries. Is someone available to give me a ride to downtown?",
//                   distance: "0.3 miles away",
//                   price: "\$10",
//                   buttonText: "Send Message",
//                   acceptedBy: "Paul Jack", // New parameter
//                   onButtonPressed: () {
//                     context.pushNamed(AppRoute.userProfileScreen.name);
//                     print("Send Message pressed");
//                   },
//                   requestType: "Ride",
//                   profileIconAsset: 'assets/icons/profile.svg',
//                   requestTypeIconAsset: AppImages.car,
//                 ),
//                 SizedBox(height: 10.h),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }