import 'package:fava/data/mock/mock_auth_data.dart';
import 'package:fava/models/request.dart';
import 'package:fava/providers/request_provider.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:fava/widgets/common/requests_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user requests when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserRequests();
    });
  }

  void _fetchUserRequests() {
    // Use first mock user specifically
    final specificUser = mockUsers.first;
    context.read<RequestProvider>().fetchUserRequests(specificUser.id);
  }

  void _handleRequestAction(RequestData request) {
    debugPrint('Edit/View request: ${request.requestTitle}');
    // TODO: Implement edit/view request logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              CustomAppBar(
                topHeight: 22,
                backButton: true,
                title: "My Requests",
                appLogo: true,
                subtitle: "My Requests",
                
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: Consumer<RequestProvider>(
                  builder: (context, requestProvider, _) {
                    return RequestsListWidget(
                      requests: requestProvider.userRequests,
                      isLoading: requestProvider.isLoadingUserRequests,
                      hasData: requestProvider.hasUserRequests,
                      error: requestProvider.userRequestsError,
                      onRefresh: () async {
                        await requestProvider.refreshUserRequests(mockUsers.first.id);
                      },
                      onRequestAction: _handleRequestAction,
                      buttonText: "Delete",
                      loadingTitle: 'Loading Your Requests...',
                      loadingSubtitle: 'Please wait while we fetch your requests',
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
