import 'dart:typed_data';
import 'dart:math';
import 'package:fava/core/services/mock_database_services.dart';
import 'package:fava/core/utils/image_helper.dart';
import 'package:fava/core/utils/date_time_helper.dart';
import 'package:fava/models/request.dart';
import 'package:fava/providers/filter_provider.dart';
import 'package:fava/data/mock/mock_auth_data.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class RequestProvider extends ChangeNotifier {
  // Form fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController suggestedFeeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // User requests state
  List<RequestData> _userRequests = [];
  bool _isLoadingUserRequests = false;
  String? _userRequestsError;
  
  RequestProvider();
  
  // Method to set initial request type from navigation
  void setInitialRequestType(String requestType) {
    _initialRequestType = requestType;
    _selectedRequestType = requestType;
    notifyListeners();
  }
  
  
  // Submission state
  bool _isSubmitting = false;
  String? _submissionError;
  
  // Switch states
  bool _recurringRequest = true;
  bool _setStartDate = true;
  bool _offerPayment = true;
  String _selectedFrequency = 'Weekly';
  String _selectedRequestType = 'Ride';
  String? _initialRequestType; // Track the initial request type from navigation
  
  // Multi-image selection state (for existing widgets)
  List<Uint8List> _selectedImages = [];
  bool _isImageLoading = false;
  String? _imageError;
  
  // Single image selection state (for ImageSelectionWidget)
  Uint8List? _selectedSingleImage;
  bool _isSingleImageLoading = false;
  String? _singleImageError;
  
  // Location selection state
  String? _pickupAddress;
  Position? _pickupPosition;
  String? _destinationAddress;
  Position? _destinationPosition;
  
  // DateTime selection state
  DateTime? _selectedDateTime;
  DateTime? _startDate;
  DateTime? _endDate;
  
  // Validation error states
  String? _destinationError;
  String? _pickupError;
  String? _timeError;
  String? _requestTypeError;
  TimeOfDay? _selectedTime;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _isDateTimeLoading = false;
  String? _dateTimeError;
  
  
  // Submission getters
  bool get isSubmitting => _isSubmitting;
  String? get submissionError => _submissionError;
  
  // Switch getters
  bool get recurringRequest => _recurringRequest;
  bool get setStartDate => _setStartDate;
  bool get offerPayment => _offerPayment;
  String get selectedFrequency => _selectedFrequency;
  String get selectedRequestType => _selectedRequestType;
  
  // Getters for multi-image selection
  List<Uint8List> get selectedImages => _selectedImages;
  bool get hasImages => _selectedImages.isNotEmpty;
  int get imageCount => _selectedImages.length;
  bool get isImageLoading => _isImageLoading;
  String? get imageError => _imageError;
  
  // Getters for single image selection
  Uint8List? get selectedSingleImage => _selectedSingleImage;
  bool get hasSingleImage => _selectedSingleImage != null;
  bool get isSingleImageLoading => _isSingleImageLoading;
  String? get singleImageError => _singleImageError;
  
  // Getters for locations
  String? get pickupAddress => _pickupAddress;
  Position? get pickupPosition => _pickupPosition;
  String? get destinationAddress => _destinationAddress;
  Position? get destinationPosition => _destinationPosition;
  
  // Getters for validation errors
  String? get destinationError => _destinationError;
  String? get pickupError => _pickupError;
  String? get timeError => _timeError;
  String? get requestTypeError => _requestTypeError;
  
  // Getters for DateTime
  DateTime? get selectedDateTime => _selectedDateTime;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  TimeOfDay? get selectedTime => _selectedTime;
  TimeOfDay? get startTime => _startTime;
  TimeOfDay? get endTime => _endTime;
  bool get isDateTimeLoading => _isDateTimeLoading;
  String? get dateTimeError => _dateTimeError;
  
  // Getters for user requests
  List<RequestData> get userRequests => _userRequests;
  bool get isLoadingUserRequests => _isLoadingUserRequests;
  String? get userRequestsError => _userRequestsError;
  bool get hasUserRequests => _userRequests.isNotEmpty;
  
  // Image logic methods
  Future<void> pickImageFromCamera({int maxSizeInMB = 5, int maxImages = 3}) async {
    if (_selectedImages.length >= maxImages) {
      _imageError = 'Maximum $maxImages images can be selected';
      notifyListeners();
      return;
    }

    _isImageLoading = true;
    _imageError = null;
    notifyListeners();

    try {
      final imageBytes = await ImageHelper.pickImageFromCamera();
      
      if (imageBytes != null) {
        if (!ImageHelper.isImageSizeValid(imageBytes, maxSizeInMB: maxSizeInMB)) {
          _imageError = 'Image size must be less than ${maxSizeInMB}MB';
        } else {
          _selectedImages.add(imageBytes);
        }
      }
    } catch (e) {
      _imageError = 'Failed to pick image from camera. Please try again.';
      debugPrint('Camera error: $e');
    } finally {
      _isImageLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickImageFromGallery({int maxSizeInMB = 5, int maxImages = 3}) async {
    if (_selectedImages.length >= maxImages) {
      _imageError = 'Maximum $maxImages images can be selected';
      notifyListeners();
      return;
    }

    _isImageLoading = true;
    _imageError = null;
    notifyListeners();

    try {
      final imageBytes = await ImageHelper.pickImageFromGallery();
      
      if (imageBytes != null) {
        if (!ImageHelper.isImageSizeValid(imageBytes, maxSizeInMB: maxSizeInMB)) {
          _imageError = 'Image size must be less than ${maxSizeInMB}MB';
        } else {
          _selectedImages.add(imageBytes);
        }
      }
    } catch (e) {
      _imageError = 'Failed to pick image from gallery. Please try again.';
      debugPrint('Gallery error: $e');
    } finally {
      _isImageLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickMultipleImagesFromGallery({int maxSizeInMB = 5, int maxImages = 3}) async {
    final remainingSlots = maxImages - _selectedImages.length;
    if (remainingSlots <= 0) {
      _imageError = 'Maximum $maxImages images can be selected';
      notifyListeners();
      return;
    }

    _isImageLoading = true;
    _imageError = null;
    notifyListeners();

    try {
      final imageBytesList = await ImageHelper.pickMultipleImages();

      if (imageBytesList != null && imageBytesList.isNotEmpty) {
        final imagesToAdd = imageBytesList.take(remainingSlots).toList();
        int validImages = 0;
        
        for (final imageBytes in imagesToAdd) {
          if (ImageHelper.isImageSizeValid(imageBytes, maxSizeInMB: maxSizeInMB)) {
            _selectedImages.add(imageBytes);
            validImages++;
          }
        }

        if (validImages < imagesToAdd.length) {
          _imageError = 'Some images exceed ${maxSizeInMB}MB limit and were skipped';
        }

        if (imageBytesList.length > remainingSlots) {
          _imageError = 'Only first $remainingSlots images were selected (max $maxImages)';
        }
      }
    } catch (e) {
      _imageError = 'Failed to pick images. Please try again.';
      debugPrint('Multiple images error: $e');
    } finally {
      _isImageLoading = false;
      notifyListeners();
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      _imageError = null;
      notifyListeners();
    }
  }

  void clearImageError() {
    _imageError = null;
    notifyListeners();
  }
  
  // Single image selection methods
  Future<void> pickSingleImageFromCamera({int maxSizeInMB = 5}) async {
    _isSingleImageLoading = true;
    _singleImageError = null;
    notifyListeners();

    try {
      final imageBytes = await ImageHelper.pickImageFromCamera();
      
      if (imageBytes != null) {
        if (!ImageHelper.isImageSizeValid(imageBytes, maxSizeInMB: maxSizeInMB)) {
          _singleImageError = 'Image size must be less than ${maxSizeInMB}MB';
        } else {
          _selectedSingleImage = imageBytes;
        }
      }
    } catch (e) {
      _singleImageError = 'Failed to pick image from camera. Please try again.';
      debugPrint('Single image camera error: $e');
    } finally {
      _isSingleImageLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickSingleImageFromGallery({int maxSizeInMB = 5}) async {
    _isSingleImageLoading = true;
    _singleImageError = null;
    notifyListeners();

    try {
      final imageBytes = await ImageHelper.pickImageFromGallery();
      
      if (imageBytes != null) {
        if (!ImageHelper.isImageSizeValid(imageBytes, maxSizeInMB: maxSizeInMB)) {
          _singleImageError = 'Image size must be less than ${maxSizeInMB}MB';
        } else {
          _selectedSingleImage = imageBytes;
        }
      }
    } catch (e) {
      _singleImageError = 'Failed to pick image from gallery. Please try again.';
      debugPrint('Single image gallery error: $e');
    } finally {
      _isSingleImageLoading = false;
      notifyListeners();
    }
  }

  void removeSingleImage() {
    _selectedSingleImage = null;
    _singleImageError = null;
    notifyListeners();
  }

  void clearSingleImageError() {
    _singleImageError = null;
    notifyListeners();
  }
  
  // Original image methods (kept for backward compatibility)
  void setImages(List<Uint8List> images) {
    _selectedImages = images;
    notifyListeners();
  }
  
  void clearImages() {
    _selectedImages = [];
    _imageError = null;
    notifyListeners();
  }
  
  void clearSingleImage() {
    _selectedSingleImage = null;
    _singleImageError = null;
    notifyListeners();
  }
  
  // Location methods
  void setPickupLocation(String address, Position? position) {
    _pickupAddress = address;
    _pickupPosition = position;
    _pickupError = null; // Clear error when value is set
    notifyListeners();
  }
  
  void setDestinationLocation(String address, Position? position) {
    _destinationAddress = address;
    _destinationPosition = position;
    _destinationError = null; // Clear error when value is set
    notifyListeners();
  }
  
  void clearPickupLocation() {
    _pickupAddress = null;
    _pickupPosition = null;
    notifyListeners();
  }
  
  void clearDestinationLocation() {
    _destinationAddress = null;
    _destinationPosition = null;
    notifyListeners();
  }
  
  void clearAllLocations() {
    _pickupAddress = null;
    _pickupPosition = null;
    _destinationAddress = null;
    _destinationPosition = null;
    notifyListeners();
  }
  
  // Clear all request data
  void clearAll() {
    clearImages();
    clearSingleImage();
    clearAllLocations();
    clearAllDateTime();
    notifyListeners();
  }
  
  // DateTime management methods
  void setDateTime(DateTime? dateTime) {
    _selectedDateTime = dateTime;
    _dateTimeError = null;
    notifyListeners();
  }
  
  void setStartDateTime(DateTime? startDate) {
    _startDate = startDate;
    _dateTimeError = null;
    notifyListeners();
  }
  
  void setEndDate(DateTime? endDate) {
    _endDate = endDate;
    _dateTimeError = null;
    notifyListeners();
  }
  
  void setSelectedTime(TimeOfDay? time) {
    _selectedTime = time;
    _dateTimeError = null;
    _timeError = null; // Clear validation error when time is set
    notifyListeners();
  }
  
  void setTimeRange(TimeOfDay? startTime, TimeOfDay? endTime) {
    _startTime = startTime;
    _endTime = endTime;
    _dateTimeError = null;
    notifyListeners();
  }
  
  void setDateTimeLoading(bool loading) {
    _isDateTimeLoading = loading;
    notifyListeners();
  }
  
  void setDateTimeError(String? error) {
    _dateTimeError = error;
    notifyListeners();
  }
  
  void clearDateTime() {
    _selectedDateTime = null;
    _dateTimeError = null;
    notifyListeners();
  }
  
  void clearStartDate() {
    _startDate = null;
    _dateTimeError = null;
    notifyListeners();
  }
  
  void clearEndDate() {
    _endDate = null;
    _dateTimeError = null;
    notifyListeners();
  }
  
  void clearSelectedTime() {
    _selectedTime = null;
    _dateTimeError = null;
    notifyListeners();
  }
  
  void clearTimeRange() {
    _startTime = null;
    _endTime = null;
    _dateTimeError = null;
    notifyListeners();
  }
  
  void clearAllDateTime() {
    _selectedDateTime = null;
    _startDate = null;
    _endDate = null;
    _selectedTime = null;
    _startTime = null;
    _endTime = null;
    _isDateTimeLoading = false;
    _dateTimeError = null;
    notifyListeners();
  }
  
  void clearDateTimeError() {
    _dateTimeError = null;
    notifyListeners();
  }
  
  // Validation helpers
  bool get hasValidPickup => _pickupAddress != null && _pickupAddress!.isNotEmpty;
  bool get hasValidDestination => _destinationAddress != null && _destinationAddress!.isNotEmpty;
  bool get hasValidLocations => hasValidPickup && hasValidDestination;
  
  // DateTime validation helpers
  bool get hasValidDateTime => _selectedDateTime != null;
  bool get hasValidStartDate => _startDate != null;
  bool get hasValidEndDate => _endDate != null;
  bool get hasValidTime => _selectedTime != null;
  bool get hasValidTimeRange => _startTime != null && _endTime != null;
  bool get hasValidDateRange => _startDate != null && _endDate != null;
  
  // Check if selected date is in the future
  bool get isDateTimeInFuture {
    if (_selectedDateTime == null) return false;
    return _selectedDateTime!.isAfter(DateTime.now());
  }
  
  // Check if date range is valid (end date after start date)
  bool get isDateRangeValid {
    if (_startDate == null || _endDate == null) return false;
    return _endDate!.isAfter(_startDate!) || _endDate!.isAtSameMomentAs(_startDate!);
  }
  
  // Check if time range is valid (end time after start time)
  bool get isTimeRangeValid {
    if (_startTime == null || _endTime == null) return false;
    final start = Duration(hours: _startTime!.hour, minutes: _startTime!.minute);
    final end = Duration(hours: _endTime!.hour, minutes: _endTime!.minute);
    return end > start;
  }

  // Date Picker Helper Methods
  Future<void> openDatePicker(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? helpText,
    Function(DateTime?)? onDateSelected,
  }) async {
    try {
      _isDateTimeLoading = true;
      _dateTimeError = null;
      notifyListeners();

      final selectedDate = await DateTimeHelper.pickDate(
        context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        helpText: helpText,
      );

      if (selectedDate != null) {
        _selectedDateTime = selectedDate;
        onDateSelected?.call(selectedDate);
      }
    } catch (e) {
      _dateTimeError = 'Failed to select date. Please try again.';
      debugPrint('Date picker error: $e');
    } finally {
      _isDateTimeLoading = false;
      notifyListeners();
    }
  }

  // Time Picker Helper Methods
  Future<void> openTimePicker(
    BuildContext context, {
    TimeOfDay? initialTime,
    String? helpText,
    Function(TimeOfDay?)? onTimeSelected,
  }) async {
    try {
      _isDateTimeLoading = true;
      _dateTimeError = null;
      notifyListeners();

      final selectedTime = await DateTimeHelper.pickTime(
        context,
        initialTime: initialTime,
        helpText: helpText,
      );

      if (selectedTime != null) {
        _selectedTime = selectedTime;
        onTimeSelected?.call(selectedTime);
      }
    } catch (e) {
      _dateTimeError = 'Failed to select time. Please try again.';
      debugPrint('Time picker error: $e');
    } finally {
      _isDateTimeLoading = false;
      notifyListeners();
    }
  }

  // Combined Date and Time Picker Helper Method
  Future<void> openDateTimePicker(
    BuildContext context, {
    DateTime? initialDateTime,
    DateTime? firstDate,
    DateTime? lastDate,
    Function(DateTime?)? onDateTimeSelected,
  }) async {
    try {
      _isDateTimeLoading = true;
      _dateTimeError = null;
      notifyListeners();

      final selectedDateTime = await DateTimeHelper.pickDateTime(
        context,
        initialDateTime: initialDateTime,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      if (selectedDateTime != null) {
        _selectedDateTime = selectedDateTime;
        onDateTimeSelected?.call(selectedDateTime);
      }
    } catch (e) {
      _dateTimeError = 'Failed to select date and time. Please try again.';
      debugPrint('DateTime picker error: $e');
    } finally {
      _isDateTimeLoading = false;
      notifyListeners();
    }
  }

  // Time Range Picker Helper Method
  Future<void> openTimeRangePicker(
    BuildContext context, {
    TimeOfDay? initialStartTime,
    TimeOfDay? initialEndTime,
    Function(TimeOfDay?, TimeOfDay?)? onTimeRangeSelected,
  }) async {
    try {
      _isDateTimeLoading = true;
      _dateTimeError = null;
      notifyListeners();

      final timeRange = await DateTimeHelper.pickTimeRange(
        context,
        initialStartTime: initialStartTime,
        initialEndTime: initialEndTime,
      );

      if (timeRange != null) {
        _startTime = timeRange['startTime'];
        _endTime = timeRange['endTime'];
        onTimeRangeSelected?.call(_startTime, _endTime);
      }
    } catch (e) {
      _dateTimeError = 'Failed to select time range. Please try again.';
      debugPrint('Time range picker error: $e');
    } finally {
      _isDateTimeLoading = false;
      notifyListeners();
    }
  }


  // Switch control methods
  void setRecurringRequest(bool value) {
    _recurringRequest = value;
    notifyListeners();
  }

  void setStartDateEnabled(bool value) {
    _setStartDate = value;
    notifyListeners();
  }

  void setOfferPayment(bool value) {
    _offerPayment = value;
    notifyListeners();
  }

  void setSelectedFrequency(String frequency) {
    _selectedFrequency = frequency;
    notifyListeners();
  }

  void setSelectedRequestType(String requestType) {
    _selectedRequestType = requestType;
    // Clear request type error when user selects a type
    if (_requestTypeError != null) {
      _requestTypeError = null;
    }
    notifyListeners();
  }

  // Validate required fields
  bool _validateRequiredFields() {
    bool isValid = true;

    // Clear previous validation errors
    _destinationError = null;
    _pickupError = null;
    _timeError = null;
    _requestTypeError = null;

    // Validate Title and Description - use form validation
    if (formKey.currentState != null) {
      if (!formKey.currentState!.validate()) {
        isValid = false;
      }
    }
    
    // Manual validation for Request Type when navigated via "send directly"
    if (_initialRequestType?.toLowerCase() == 'send directly') {
      if (_selectedRequestType.toLowerCase() == 'send directly') {
        _requestTypeError = 'Please select a specific request type';
        debugPrint('Request type is required when using send directly');
        isValid = false;
      }
    }

    // Manual validation for Destination
    if (_destinationAddress == null || _destinationAddress!.isEmpty) {
      _destinationError = 'Destination is required';
      debugPrint('Destination is required');
      isValid = false;
    }

    // Manual validation for Pickup
    if (_pickupAddress == null || _pickupAddress!.isEmpty) {
      _pickupError = 'Pickup location is required';
      debugPrint('Pickup location is required');
      isValid = false;
    }

    // Manual validation for Time
    if (_selectedTime == null) {
      _timeError = 'Time is required';
      debugPrint('Time is required');
      isValid = false;
    }

    // Notify listeners to update UI with error states
    if (!isValid) {
      notifyListeners();
    }

    return isValid;
  }

  // Request submission method
  Future<bool> submitRequest(BuildContext context) async {
    // Validate required fields
    if (!_validateRequiredFields()) {
      return false;
    }

    _isSubmitting = true;
    _submissionError = null;
    notifyListeners();

    try {
      // Get a random mock user
      final randomUser = mockUsers[Random().nextInt(mockUsers.length)];
      
      // Calculate distance (mock calculation)
      String calculatedDistance = '${(Random().nextDouble() * 2 + 0.1).toStringAsFixed(1)} miles away';
      
      // Create Request object from form data
      final request = Request(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: randomUser.id,
        userName: randomUser.fullName,
        requestTitle: titleController.text.trim(),
        requestDescription: descriptionController.text.trim(),
        requestType: selectedRequestType,
        pickupLocation: pickupAddress,
        destinationLocation: destinationAddress,
        imageUrls: [], // Would convert selectedImages to URLs
        isRecurring: recurringRequest,
        frequency: selectedFrequency,
        selectedDays: [], // Would include selected days
        timeRange: selectedTime != null ? '${selectedTime!.hour}:${selectedTime!.minute}' : null,
        startDate: selectedDateTime,
        offerPayment: offerPayment,
        suggestedFee: offerPayment && suggestedFeeController.text.trim().isNotEmpty 
            ? '\$${suggestedFeeController.text.trim()}' 
            : 'Free',
        groupId: null, // Would be set based on group selection
        createdAt: DateTime.now(),
        status: 'active',
        distance: calculatedDistance,
      );
      
      // Save to mock database
      final success = await MockDatabaseServices().addRequest(request);
      
      if (!success) {
        throw Exception('Failed to save request');
      }
      
      debugPrint('Successfully created request: ${request.requestTitle}');
      
      // Refresh the FilterProvider so new request shows in feed
      if (context.mounted) {
        final filterProvider = Provider.of<FilterProvider>(context, listen: false);
        await filterProvider.refresh();
      }
      
      // Success - show snackbar and navigate using mounted check
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request posted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate to home screen with feed tab
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home',
          (route) => false,
          arguments: {'selectedIndex': 0}, // Feed tab
        );
      }

      // Clear form data
      clearFormData();

      return true;
    } catch (e) {
      _submissionError = 'Failed to submit request. Please try again.';
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  // Clear form data
  void clearFormData() {
    // pickupAddressController.dispose();
    // destinationAddressController.dispose();
    titleController.clear();
    priceController.clear();
    descriptionController.clear();
    suggestedFeeController.clear();
    clearAll();
    _submissionError = null;
    notifyListeners();
  }

  // User requests methods
  Future<void> fetchUserRequests(String userId, {bool showLoading = true}) async {
    if (showLoading) {
      _isLoadingUserRequests = true;
      notifyListeners();
    }
    _userRequestsError = null;

    try {
      final requests = await MockDatabaseServices().getUserRequests(userId);
      _userRequests = requests;
    } catch (e) {
      _userRequestsError = 'Failed to load your requests. Please try again.';
      debugPrint('Error fetching user requests: $e');
    } finally {
      if (showLoading) {
        _isLoadingUserRequests = false;
      }
      notifyListeners();
    }
  }

  Future<void> refreshUserRequests(String userId) async {
    await fetchUserRequests(userId, showLoading: false);
  }

  void clearUserRequests() {
    _userRequests = [];
    _userRequestsError = null;
    notifyListeners();
  }

  @override
  void dispose() {

    titleController.dispose();
    // pickupAddressController.dispose();
    // destinationAddressController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    suggestedFeeController.dispose();
    super.dispose();
  }
}