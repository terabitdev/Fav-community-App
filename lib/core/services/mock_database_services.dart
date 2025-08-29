// lib/services/mock_database_service.dart


import 'package:fava/data/mock/mock_auth_data.dart';
import 'package:fava/models/request.dart';

class MockDatabaseServices {
  static final MockDatabaseServices _instance = MockDatabaseServices._internal();
  factory MockDatabaseServices() => _instance;
  MockDatabaseServices._internal();

  // In-memory storage
  final List<Request> _requests = [];
  final List<RequestData> _requestData = mockRequests;
  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Fetch all requests
  Future<List<RequestData>> fetchRequests() async {
    await _simulateNetworkDelay();
    return List.from(_requestData);
  }

  // Get all requests
  Future<List<Request>> getAllRequests() async {
    await _simulateNetworkDelay();
    return List.from(_requests);
  }

  // Filter requests by type
  Future<List<RequestData>> filterRequestsByType(String requestType) async {
    await _simulateNetworkDelay();
    
    if (requestType.toLowerCase() == 'all') {
      return List.from(_requestData);
    }
    
    return _requestData
        .where((request) => 
            request.requestType.toLowerCase() == requestType.toLowerCase())
        .toList();
  }

  // Search requests by type (case-insensitive)
  Future<List<RequestData>> searchRequestsByType(String query) async {
    await _simulateNetworkDelay();
    
    if (query.isEmpty) {
      return List.from(_requestData);
    }
    
    return _requestData
        .where((request) => 
            request.requestType.toLowerCase().contains(query.toLowerCase()) ||
            request.requestTitle.toLowerCase().contains(query.toLowerCase()) ||
            request.requestDescription.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Combined filter and search
  Future<List<RequestData>> filterAndSearchRequests({
    required String requestType,
    required String searchQuery,
  }) async {
    await _simulateNetworkDelay();
    
    List<RequestData> filteredData = List.from(_requestData);
    
    // Apply type filter
    if (requestType.toLowerCase() != 'all') {
      filteredData = filteredData
          .where((request) => 
              request.requestType.toLowerCase() == requestType.toLowerCase())
          .toList();
    }
    
    // Apply search query
    if (searchQuery.isNotEmpty) {
      filteredData = filteredData
          .where((request) => 
              request.requestType.toLowerCase().contains(searchQuery.toLowerCase()) ||
              request.requestTitle.toLowerCase().contains(searchQuery.toLowerCase()) ||
              request.requestDescription.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    
    return filteredData;
  }

  // Add new request
  Future<bool> addRequest(Request request) async {
    await _simulateNetworkDelay();
    _requests.add(request);
    
    // Also add to _requestData for the feed
    final requestData = RequestData(
      userName: request.userName,
      timeAgo: "Just now",
      requestTitle: request.requestTitle,
      requestDescription: request.requestDescription,
      distance: request.distance ?? "0.5 mi",
      price: request.suggestedFee ?? "Free",
      requestType: request.requestType,
    );
    _requestData.insert(0, requestData); // Add at beginning for newest first
    
    return true;
  }

  // Update request
  Future<bool> updateRequest(String requestId, Request request) async {
    await _simulateNetworkDelay();
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _requests[index] = request;
      return true;
    }
    return false;
  }

  // Delete request
  Future<bool> deleteRequest(String requestId) async {
    await _simulateNetworkDelay();
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _requests.removeAt(index);
      return true;
    }
    return false;
  }

  // Get requests by user ID
  Future<List<RequestData>> getUserRequests(String userId) async {
    await _simulateNetworkDelay();
    
    // Filter _requestData by userId (assuming RequestData has userId field)
    // For now, return mock data filtered by userName
    return _requestData.where((request) {
      // Find matching user by name from mockUsers
      final user = mockUsers.firstWhere(
        (u) => u.fullName == request.userName,
        orElse: () => mockUsers.first,
      );
      return user.id == userId;
    }).toList();
  }

  // Get all requests (both Request and RequestData combined)
  Future<List<RequestData>> getAllRequestsData() async {
    await _simulateNetworkDelay();
    
    // Convert Request objects to RequestData and combine with existing _requestData
    final requestDataFromRequests = _requests.map((request) => RequestData(
      userName: request.userName,
      timeAgo: _calculateTimeAgo(request.createdAt),
      requestTitle: request.requestTitle,
      requestDescription: request.requestDescription,
      distance: request.distance ?? "0.5 mi",
      price: request.suggestedFee ?? "Free",
      requestType: request.requestType,
    )).toList();
    
    // Combine and return all requests
    return [...requestDataFromRequests, ..._requestData];
  }

  // Helper method to calculate time ago
  String _calculateTimeAgo(DateTime createdAt) {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}