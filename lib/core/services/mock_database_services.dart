// lib/services/mock_database_service.dart


import 'package:fava/data/mock/mock_auth_data.dart';
import 'package:fava/models/request.dart';

class MockDatabaseService {
  static final MockDatabaseService _instance = MockDatabaseService._internal();
  factory MockDatabaseService() => _instance;
  MockDatabaseService._internal();

  // In-memory storage
  final List<RequestData> _requests = mockRequests;
  // Simulate network delay
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  // Fetch all requests
  Future<List<RequestData>> fetchRequests() async {
    await _simulateNetworkDelay();
    return List.from(_requests);
  }

  // Filter requests by type
  Future<List<RequestData>> filterRequestsByType(String requestType) async {
    await _simulateNetworkDelay();
    
    if (requestType.toLowerCase() == 'all') {
      return List.from(_requests);
    }
    
    return _requests
        .where((request) => 
            request.requestType.toLowerCase() == requestType.toLowerCase())
        .toList();
  }

  // Search requests by type (case-insensitive)
  Future<List<RequestData>> searchRequestsByType(String query) async {
    await _simulateNetworkDelay();
    
    if (query.isEmpty) {
      return List.from(_requests);
    }
    
    return _requests
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
    
    List<RequestData> filteredData = List.from(_requests);
    
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

  // Add new request (for future CRUD operations)
  Future<bool> addRequest(RequestData request) async {
    await _simulateNetworkDelay();
    _requests.add(request);
    return true;
  }

  // Update request (for future CRUD operations)
  Future<bool> updateRequest(int index, RequestData request) async {
    await _simulateNetworkDelay();
    if (index >= 0 && index < _requests.length) {
      _requests[index] = request;
      return true;
    }
    return false;
  }

  // Delete request (for future CRUD operations)
  Future<bool> deleteRequest(int index) async {
    await _simulateNetworkDelay();
    if (index >= 0 && index < _requests.length) {
      _requests.removeAt(index);
      return true;
    }
    return false;
  }
}