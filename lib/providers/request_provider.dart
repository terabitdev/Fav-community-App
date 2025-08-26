import 'package:flutter/material.dart';
import 'package:fava/models/request.dart';
import 'package:fava/core/services/mock_database_services.dart';
import 'package:fava/data/mock/mock_auth_data.dart';
import 'package:fava/core/utils/date_time_helper.dart';
import 'package:fava/core/utils/validators.dart';
import 'dart:typed_data';

class RequestProvider extends ChangeNotifier {
  final MockDatabaseServices _databaseService = MockDatabaseServices();
  
  List<Request> _requests = [];
  bool _isLoading = false;
  String? _error;
  
  // Form validation state variables
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // Form controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController suggestedFeeController = TextEditingController();
  
  // Focus nodes
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  
  // Form data state
  bool _recurringRequest = true;
  bool _setStartDate = true;
  bool _offerPayment = true;
  String _selectedFrequency = 'Weekly';
  List<String> _selectedDays = ['Mon'];
  List<Uint8List> _selectedImages = [];
  String? _pickupLocation;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _startDate;
  
  // Constructor - Initialize with default user for testing
  RequestProvider() {
    // Initialize with default user if none is set
    if (MockAuthData.currentUser == null) {
      MockAuthData.initializeWithDefaultUser();
    }
  }
  
  // Getters
  List<Request> get requests => List.unmodifiable(_requests);
  List<Request> get userRequests => _requests.where((r) => r.userId == MockAuthData.currentUser?.id).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // Form data getters
  bool get recurringRequest => _recurringRequest;
  bool get setStartDate => _setStartDate;
  bool get offerPayment => _offerPayment;
  String get selectedFrequency => _selectedFrequency;
  List<String> get selectedDays => _selectedDays;
  List<Uint8List> get selectedImages => _selectedImages;
  String? get pickupLocation => _pickupLocation;
  TimeOfDay? get startTime => _startTime;
  TimeOfDay? get endTime => _endTime;
  DateTime? get startDate => _startDate;
  
  // Get requests by type
  List<Request> getRequestsByType(String type) {
    return _requests.where((r) => r.requestType.toLowerCase() == type.toLowerCase()).toList();
  }
  
  // Get recent requests
  List<Request> get recentRequests {
    final sorted = List<Request>.from(_requests);
    sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(10).toList();
  }
  
  // Initialize and load requests
  Future<void> initializeRequests() async {
    _setLoading(true);
    try {
      _requests = await _databaseService.getAllRequests();
      _clearError();
    } catch (e) {
      _setError('Failed to load requests: $e');
    } finally {
      _setLoading(false);
    }
  }
  
  // Create new request
  Future<bool> createRequest({
    required String requestTitle,
    required String requestDescription,
    required String requestType,
    String? pickupLocation,
    String? destinationLocation,
    List<String> imageUrls = const [],
    bool isRecurring = false,
    String frequency = 'Weekly',
    List<String> selectedDays = const [],
    String? timeRange,
    DateTime? startDate,
    bool offerPayment = false,
    String? suggestedFee,
    String? groupId,
    String? distance,
  }) async {
    if (MockAuthData.currentUser == null) {
      _setError('User not authenticated');
      return false;
    }
    
    _setLoading(true);
    try {
      final newRequest = Request(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: MockAuthData.currentUser!.id,
        userName: MockAuthData.currentUser!.fullName,
        requestTitle: requestTitle,
        requestDescription: requestDescription,
        requestType: requestType,
        pickupLocation: pickupLocation,
        destinationLocation: destinationLocation,
        imageUrls: imageUrls,
        isRecurring: isRecurring,
        frequency: frequency,
        selectedDays: selectedDays,
        timeRange: timeRange,
        startDate: startDate,
        offerPayment: offerPayment,
        suggestedFee: suggestedFee,
        groupId: groupId,
        createdAt: DateTime.now(),
        status: 'active',
        distance: distance,
      );
      
      final success = await _databaseService.addRequest(newRequest);
      if (success) {
        _requests.add(newRequest);
        _clearError();
        debugPrint('Request created successfully: ${newRequest.requestTitle}');
        return true;
      } else {
        _setError('Failed to create request');
        return false;
      }
    } catch (e) {
      _setError('Error creating request: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Update request
  Future<bool> updateRequest(String requestId, Request updatedRequest) async {
    _setLoading(true);
    try {
      final success = await _databaseService.updateRequest(requestId, updatedRequest);
      if (success) {
        final index = _requests.indexWhere((r) => r.id == requestId);
        if (index != -1) {
          _requests[index] = updatedRequest;
          _clearError();
          return true;
        }
      }
      _setError('Failed to update request');
      return false;
    } catch (e) {
      _setError('Error updating request: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Delete request
  Future<bool> deleteRequest(String requestId) async {
    _setLoading(true);
    try {
      final success = await _databaseService.deleteRequest(requestId);
      if (success) {
        _requests.removeWhere((r) => r.id == requestId);
        _clearError();
        return true;
      }
      _setError('Failed to delete request');
      return false;
    } catch (e) {
      _setError('Error deleting request: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }
  
  // Get request by ID
  Request? getRequestById(String requestId) {
    try {
      return _requests.firstWhere((r) => r.id == requestId);
    } catch (e) {
      return null;
    }
  }
  
  // Filter requests
  List<Request> filterRequests({
    String? type,
    String? status,
    String? userId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _requests.where((request) {
      if (type != null && request.requestType.toLowerCase() != type.toLowerCase()) {
        return false;
      }
      if (status != null && request.status != status) {
        return false;
      }
      if (userId != null && request.userId != userId) {
        return false;
      }
      if (startDate != null && request.createdAt.isBefore(startDate)) {
        return false;
      }
      if (endDate != null && request.createdAt.isAfter(endDate)) {
        return false;
      }
      return true;
    }).toList();
  }
  
  // Search requests
  List<Request> searchRequests(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _requests.where((request) {
      return request.requestTitle.toLowerCase().contains(lowercaseQuery) ||
             request.requestDescription.toLowerCase().contains(lowercaseQuery) ||
             request.requestType.toLowerCase().contains(lowercaseQuery) ||
             request.userName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
  
  // Get requests for feed (convert to RequestData for compatibility)
  List<RequestData> getRequestsForFeed() {
    return _requests
        .where((r) => r.status == 'active')
        .map((r) => r.toRequestData())
        .toList();
  }
  
  // Utility methods for Create Request Screen
  String generateTimeRangeString(TimeOfDay? startTime, TimeOfDay? endTime) {
    if (startTime == null || endTime == null) return '';
    return DateTimeFormatter.formatTimeRange(startTime, endTime);
  }

  // Form state management methods
  void updateRecurringRequest(bool value) {
    _recurringRequest = value;
    notifyListeners();
  }

  void updateSetStartDate(bool value) {
    _setStartDate = value;
    if (!value) {
      _startDate = null;
    }
    notifyListeners();
  }

  void updateOfferPayment(bool value) {
    _offerPayment = value;
    if (!value) {
      suggestedFeeController.clear();
    }
    notifyListeners();
  }

  void updateSelectedFrequency(String frequency) {
    _selectedFrequency = frequency;
    notifyListeners();
  }

  void updateSelectedDays(List<String> days) {
    _selectedDays = days;
    notifyListeners();
  }

  void updateSelectedImages(List<Uint8List> images) {
    _selectedImages = images;
    notifyListeners();
  }

  void updatePickupLocation(String? location) {
    _pickupLocation = location;
    notifyListeners();
  }

  void updateStartTime(TimeOfDay? time) {
    _startTime = time;
    notifyListeners();
  }

  void updateEndTime(TimeOfDay? time) {
    _endTime = time;
    notifyListeners();
  }

  void updateStartDate(DateTime? date) {
    _startDate = date;
    notifyListeners();
  }

  // Form validation methods for TextFormField validator
  String? validateTitle(String? value) {
    return AppValidators.validateTitle(value);
  }

  String? validateDescription(String? value) {
    return AppValidators.validateDescription(value);
  }

  String? validateLocation(String? value) {
    return AppValidators.validateLocation(value);
  }

  String? validateDate(DateTime? value) {
    return AppValidators.validateDate(value);
  }

  // Clear all form data
  void clearFormData() {
    titleController.clear();
    descriptionController.clear();
    suggestedFeeController.clear();
    _recurringRequest = true;
    _setStartDate = true;
    _offerPayment = true;
    _selectedFrequency = 'Weekly';
    _selectedDays = ['Mon'];
    _selectedImages.clear();
    _pickupLocation = null;
    _startTime = null;
    _endTime = null;
    _startDate = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clearState() {
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  // Submit request using Form validation
  Future<bool> submitRequest(String requestType) async {
    clearState();
    
    // Validate form using Flutter's default validation
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Validate required fields that are not in the form
    if (_pickupLocation == null || _pickupLocation!.trim().isEmpty) {
      _setError('Location is required');
      return false;
    }

    if (_setStartDate && _startDate == null) {
      _setError('Deadline is required');
      return false;
    }

    // Check authentication (but don't show error as specified)
    if (MockAuthData.currentUser == null) {
      return false;
    }

    _setLoading(true);

    try {
      // Create time range string
      String? timeRange;
      if (_startTime != null && _endTime != null) {
        timeRange = generateTimeRangeString(_startTime!, _endTime!);
      }

      final success = await createRequest(
        requestTitle: titleController.text.trim(),
        requestDescription: descriptionController.text.trim(),
        requestType: requestType,
        pickupLocation: _pickupLocation?.trim(),
        timeRange: timeRange,
        startDate: _startDate,
        offerPayment: _offerPayment,
        suggestedFee: _offerPayment && suggestedFeeController.text.isNotEmpty 
            ? suggestedFeeController.text.trim() 
            : null,
        isRecurring: _recurringRequest,
        frequency: _selectedFrequency,
        selectedDays: _selectedDays,
      );

      if (success) {
        clearFormData();
      }

      return success;
    } catch (e) {
      _setError('Failed to create request');
      return false;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    suggestedFeeController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    locationFocusNode.dispose();
    super.dispose();
  }
  
  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
  
  void _setError(String error) {
    _error = error;
    debugPrint('RequestProvider Error: $error');
    notifyListeners();
  }
  
  void _clearError() {
    _error = null;
    notifyListeners();
  }
  
  // Clear all data (useful for logout)
  void clear() {
    _requests.clear();
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
  
  // Refresh requests from database
  Future<void> refresh() async {
    await initializeRequests();
  }
}