// lib/providers/filter_provider.dart
import 'dart:async';
import 'package:fava/core/services/mock_database_services.dart';
import 'package:fava/models/request.dart';
import 'package:flutter/foundation.dart';

// class FilterProvider extends ChangeNotifier {
//   final MockDatabaseService _databaseService = MockDatabaseService();
//   Timer? _searchDebounceTimer;
  
//   // Private state
//   String _selectedRequestType = 'All';
//   String _searchQuery = '';
//   List<RequestData> _requests = [];
//   bool _isLoading = false;

//   // Getters - Minimal reactive state exposure
//   String get selectedRequestType => _selectedRequestType;
//   String get searchQuery => _searchQuery;
//   List<RequestData> get requests => List.unmodifiable(_requests);
//   bool get isLoading => _isLoading;
//   bool get hasData => _requests.isNotEmpty;

//   // Available filter types
//   static const List<String> filterTypes = [
//     'All', 'Ride', 'Errand', 'Favor', 'Others'
//   ];

//   // Constructor - Initialize with data fetch
//   FilterProvider() {
//     _loadInitialData();
//   }

//   // Load initial data
//   Future<void> _loadInitialData() async {
//     await _refreshData();
//   }

//   // Set filter type
//   Future<void> setFilter(String requestType) async {
//     if (_selectedRequestType == requestType) return;
    
//     _selectedRequestType = requestType;
//     notifyListeners();
//     await _refreshData();
//   }

//   // Set search query with debouncing
//   void setSearch(String query) {
//     _searchQuery = query;
    
//     // Cancel previous timer
//     _searchDebounceTimer?.cancel();
    
//     // Start new timer
//     _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
//       _refreshData();
//     });
//   }

//   // Clear all filters
//   Future<void> clearFilters() async {
//     bool changed = false;
    
//     if (_selectedRequestType != 'All') {
//       _selectedRequestType = 'All';
//       changed = true;
//     }
    
//     if (_searchQuery.isNotEmpty) {
//       _searchQuery = '';
//       changed = true;
//     }
    
//     // Cancel any pending search
//     _searchDebounceTimer?.cancel();
    
//     if (changed) {
//       notifyListeners();
//       await _refreshData();
//     }
//   }

//   // Refresh data based on current filters
//   Future<void> _refreshData() async {
//     _setLoading(true);
    
//     try {
//       _requests = await _databaseService.filterAndSearchRequests(
//         requestType: _selectedRequestType,
//         searchQuery: _searchQuery,
//       );
//     } catch (e) {
//       debugPrint('Error refreshing data: $e');
//       _requests = [];
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Refresh data manually (for pull-to-refresh)
//   Future<void> refresh() async {
//     await _refreshData();
//   }

//   // Private method to set loading state
//   void _setLoading(bool loading) {
//     if (_isLoading != loading) {
//       _isLoading = loading;
//       notifyListeners();
//     }
//   }

//   // Get chip index for UI (helper method)
//   int get selectedChipIndex {
//     return filterTypes.indexOf(_selectedRequestType);
//   }

//   // Check if specific filter is active
//   bool isFilterActive(String filterType) {
//     return _selectedRequestType == filterType;
//   }

//   // Check if any filters are applied
//   bool get hasActiveFilters {
//     return _selectedRequestType != 'All' || _searchQuery.isNotEmpty;
//   }

//   @override
//   void dispose() {
//     _searchDebounceTimer?.cancel();
//     super.dispose();
//   }
// }


// version 14

// class FilterProvider extends ChangeNotifier {
//   final MockDatabaseService _databaseService = MockDatabaseService();
//   Timer? _searchDebounceTimer;
  
//   // Private state
//   String _selectedRequestType = 'All';
//   String _searchQuery = '';
//   List<RequestData> _requests = [];
//   bool _isLoading = false;
//   bool _isInitialLoad = true;

//   // Getters - Minimal reactive state exposure
//   String get selectedRequestType => _selectedRequestType;
//   String get searchQuery => _searchQuery;
//   List<RequestData> get requests => List.unmodifiable(_requests);
//   bool get isLoading => _isLoading;
//   bool get hasData => _requests.isNotEmpty;

//   // Available filter types
//   static const List<String> filterTypes = [
//     'All', 'Ride', 'Errand', 'Favor', 'Others'
//   ];

//   // Constructor - Initialize with data fetch
//   FilterProvider() {
//     _loadInitialData();
//   }

//   // Load initial data
//   Future<void> _loadInitialData() async {
//     await _refreshData(showLoading: true);
//   }

//   // Set filter type
//   Future<void> setFilter(String requestType) async {
//     if (_selectedRequestType == requestType) return;
    
//     _selectedRequestType = requestType;
//     notifyListeners();
//     await _refreshData(showLoading: false);
//   }

//   // Set search query with debouncing
//   void setSearch(String query) {
//     _searchQuery = query;
    
//     // Cancel previous timer
//     _searchDebounceTimer?.cancel();
    
//     // Start new timer
//     _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
//       _refreshData(showLoading: false);
//     });
//   }

//   // Clear all filters
//   Future<void> clearFilters() async {
//     bool changed = false;
    
//     // If search has text, just reset filter to "All" but keep search
//     if (_searchQuery.isNotEmpty) {
//       if (_selectedRequestType != 'All') {
//         _selectedRequestType = 'All';
//         changed = true;
//       }
//     } else {
//       // If search is empty, reset everything
//       if (_selectedRequestType != 'All') {
//         _selectedRequestType = 'All';
//         changed = true;
//       }
//     }
    
//     // Cancel any pending search
//     _searchDebounceTimer?.cancel();
    
//     if (changed) {
//       notifyListeners();
//       await _refreshData(showLoading: false);
//     }
//   }

//   // Refresh data based on current filters
//   Future<void> _refreshData({bool showLoading = true}) async {
//     // Only show loading during initial load
//     if (_isInitialLoad && showLoading) {
//       _setLoading(true);
//     }
    
//     try {
//       _requests = await _databaseService.filterAndSearchRequests(
//         requestType: _selectedRequestType,
//         searchQuery: _searchQuery,
//       );
      
//       if (_isInitialLoad) {
//         _isInitialLoad = false;
//       }
//     } catch (e) {
//       debugPrint('Error refreshing data: $e');
//       _requests = [];
//     } finally {
//       if (_isLoading) {
//         _setLoading(false);
//       }
//     }
//   }

//   // Refresh data manually (for pull-to-refresh)
//   Future<void> refresh() async {
//     await _refreshData(showLoading: false);
//   }

//   // Private method to set loading state
//   void _setLoading(bool loading) {
//     if (_isLoading != loading) {
//       _isLoading = loading;
//       notifyListeners();
//     }
//   }

//   // Get chip index for UI (helper method)
//   int get selectedChipIndex {
//     return filterTypes.indexOf(_selectedRequestType);
//   }

//   // Check if specific filter is active
//   bool isFilterActive(String filterType) {
//     return _selectedRequestType == filterType;
//   }

//   // Check if any filters are applied
//   bool get hasActiveFilters {
//     return _selectedRequestType != 'All' || _searchQuery.isNotEmpty;
//   }

//   @override
//   void dispose() {
//     _searchDebounceTimer?.cancel();
//     super.dispose();
//   }
// }


// Final Version
// lib/providers/filter_provider.dart
class FilterProvider extends ChangeNotifier {
  final MockDatabaseServices _databaseService = MockDatabaseServices();
  Timer? _searchDebounceTimer;
  
  // Private state
  String _selectedRequestType = 'All';
  String _searchQuery = '';
  List<RequestData> _requests = [];
  bool _isLoading = false;
  bool _isInitialLoad = true;

  // Getters - Minimal reactive state exposure
  String get selectedRequestType => _selectedRequestType;
  String get searchQuery => _searchQuery;
  List<RequestData> get requests => List.unmodifiable(_requests);
  bool get isLoading => _isLoading;
  bool get hasData => _requests.isNotEmpty;

  // Available filter types
  static const List<String> filterTypes = [
    'All', 'Ride', 'Errand', 'Favor', 'Others'
  ];

  // Constructor - Initialize with data fetch
  FilterProvider() {
    _loadInitialData();
  }

  // Load initial data
  Future<void> _loadInitialData() async {
    await _refreshData(showLoading: true);
  }

  // Set filter type
  Future<void> setFilter(String requestType) async {
    if (_selectedRequestType == requestType) return;
    
    _selectedRequestType = requestType;
    notifyListeners();
    await _refreshData(showLoading: false);
  }

  // Set search query with debouncing
  void setSearch(String query) {
    _searchQuery = query;
    
    // Immediately notify listeners for UI consistency
    notifyListeners();
    
    // Cancel previous timer
    _searchDebounceTimer?.cancel();
    
    // Start new timer for data refresh
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _refreshData(showLoading: false);
    });
  }

  // Clear all filters
  Future<void> clearFilters() async {
    bool changed = false;
    
    // Always reset chip to "All" when clearing filters
    if (_selectedRequestType != 'All') {
      _selectedRequestType = 'All';
      changed = true;
    }
    
    // Cancel any pending search
    _searchDebounceTimer?.cancel();
    
    if (changed) {
      notifyListeners();
      await _refreshData(showLoading: false);
    }
  }

  // Refresh data based on current filters
  Future<void> _refreshData({bool showLoading = true}) async {
    // Only show loading during initial load
    if (_isInitialLoad && showLoading) {
      _setLoading(true);
    }
    
    try {
      _requests = await _databaseService.filterAndSearchRequests(
        requestType: _selectedRequestType,
        searchQuery: _searchQuery,
      );
      
      if (_isInitialLoad) {
        _isInitialLoad = false;
      }
    } catch (e) {
      debugPrint('Error refreshing data: $e');
      _requests = [];
    } finally {
      if (_isLoading) {
        _setLoading(false);
      }
      // Always notify listeners after data update
      notifyListeners();
    }
  }

  // Refresh data manually (for pull-to-refresh)
  Future<void> refresh() async {
    await _refreshData(showLoading: false);
  }

  // Private method to set loading state
  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  // Get chip index for UI (helper method)
  int get selectedChipIndex {
    return filterTypes.indexOf(_selectedRequestType);
  }

  // Check if specific filter is active
  bool isFilterActive(String filterType) {
    return _selectedRequestType == filterType;
  }

  // Check if any filters are applied
  bool get hasActiveFilters {
    return _selectedRequestType != 'All' || _searchQuery.isNotEmpty;
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}