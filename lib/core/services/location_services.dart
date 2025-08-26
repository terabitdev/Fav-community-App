import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

class LocationServices extends ChangeNotifier {
  Position? _currentPosition;
  String? _currentAddress;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isTracking = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  Position? get currentPosition => _currentPosition;
  String? get currentAddress => _currentAddress;
  bool get isTracking => _isTracking;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Permission handling
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _error = 'Location services are disabled. Please enable them.';
      notifyListeners();
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _error = 'Location permissions are denied';
        notifyListeners();
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _error = 'Location permissions are permanently denied. Please enable from settings.';
      notifyListeners();
      return false;
    }

    return true;
  }

  // Get current location
  Future<bool> getCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final hasPermission = await _handleLocationPermission();
      if (!hasPermission) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      debugPrint('Getting current position...');
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      debugPrint('Position obtained: ${_currentPosition?.latitude}, ${_currentPosition?.longitude}');

      if (_currentPosition != null) {
        debugPrint('Getting address from coordinates...');
        _currentAddress = await _getAddressFromLatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        debugPrint('Address obtained: $_currentAddress');
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to get current location: $e';
      _isLoading = false;
      debugPrint('Location error: $e');
      notifyListeners();
      return false;
    }
  }

  // Convert coordinates to address
  Future<String?> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
      
      if (placemarks.isNotEmpty) {
        geocoding.Placemark place = placemarks[0];
        
        List<String> addressParts = [];
        
        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        
        return addressParts.join(', ');
      }
      return null;
    } catch (e) {
      debugPrint('Error getting address: $e');
      return null;
    }
  }

  // Search location by address
  Future<String?> searchLocation(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('Searching for location: $query');
      List<geocoding.Location> locations = await geocoding.locationFromAddress(query);
      
      if (locations.isNotEmpty) {
        final location = locations.first;
        _currentAddress = query;
        _currentPosition = Position(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
        
        _isLoading = false;
        notifyListeners();
        return query;
      }
      
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _error = 'Failed to search location: $e';
      _isLoading = false;
      debugPrint('Search location error: $e');
      notifyListeners();
      return null;
    }
  }

  // Start real-time location tracking
  void startLocationTracking() async {
    if (_isTracking) return;

    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) async {
        _currentPosition = position;
        _currentAddress = await _getAddressFromLatLng(
          position.latitude,
          position.longitude,
        );
        notifyListeners();
      },
      onError: (error) {
        _error = 'Location tracking error: $error';
        _isTracking = false;
        notifyListeners();
      },
    );

    _isTracking = true;
    notifyListeners();
  }

  // Stop location tracking
  void stopLocationTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _isTracking = false;
    notifyListeners();
  }

  // Set location manually
  void setLocation(String address, {Position? position}) {
    _currentAddress = address;
    _currentPosition = position;
    notifyListeners();
  }

  // Clear location data
  void clearLocation() {
    _currentPosition = null;
    _currentAddress = null;
    _error = null;
    notifyListeners();
  }

  // Calculate distance between two points
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Format distance in readable format
  String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      final distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)} km';
    }
  }

  @override
  void dispose() {
    stopLocationTracking();
    super.dispose();
  }
}