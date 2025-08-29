import 'dart:async';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/services/location_services.dart';
import 'package:fava/widgets/auth/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationSearchPage extends StatefulWidget {
  final String title;
  final String hintText;
  final String? initialValue;

  const LocationSearchPage({
    super.key,
    required this.title,
    required this.hintText,
    this.initialValue,
  });

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final LocationServices _locationService = LocationServices();
  List<String> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
    _controller.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.removeListener(_onSearchTextChanged);
    _controller.dispose();
    _locationService.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    _debounceTimer?.cancel();
    final query = _controller.text;
    
    if (query.length >= 3) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        _getSuggestions(query);
      });
    } else {
      setState(() {
        _suggestions = [];
      });
    }
  }

  Future<void> _getSuggestions(String query) async {
    setState(() => _isLoading = true);
    final suggestions = await _locationService.getLocationSuggestions(query);
    if (mounted) {
      setState(() {
        _suggestions = suggestions;
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    final success = await _locationService.getCurrentLocation();
    
    if (success && _locationService.currentAddress != null && mounted) {
      Navigator.pop(context, {
        'address': _locationService.currentAddress!,
        'position': _locationService.currentPosition,
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
      _showErrorSnackBar(_locationService.error ?? 'Failed to get location');
    }
  }

  Future<void> _selectLocation(String address) async {
    setState(() => _isLoading = true);
    final result = await _locationService.searchLocation(address);
    
    if (result != null && mounted) {
      Navigator.pop(context, {
        'address': result,
        'position': _locationService.currentPosition,
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
      _showErrorSnackBar(_locationService.error ?? 'Location not found');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorclr,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(20.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgclr,
      appBar: AppBar(
        backgroundColor: AppColors.bgclr,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.title,
          style: AppTextStyles.futuraDemi.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: EdgeInsets.all(20.w),
            child: CustomTextFormField(
              controller: _controller,
              hintText: widget.hintText,
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.hintxtclr,
                size: 20.sp,
              ),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  _selectLocation(value);
                }
              },
            ),
          ),

          // Current Location Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ListenableBuilder(
              listenable: _locationService,
              builder: (context, child) {
                return _buildLocationOption(
                  icon: Icons.my_location,
                  title: 'Use Current Location',
                  subtitle: 'Get your current position',
                  onTap: _getCurrentLocation,
                  isLoading: _isLoading,
                );
              },
            ),
          ),

          SizedBox(height: 16.h),
          
          // Results Section
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.buttonclr,
                    ),
                  )
                : _suggestions.isNotEmpty
                    ? ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        itemCount: _suggestions.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1.h,
                          color: AppColors.grayLight.withValues(alpha: 0.3),
                        ),
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: AppColors.buttonclr.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.location_on_outlined,
                                color: AppColors.buttonclr,
                                size: 20.sp,
                              ),
                            ),
                            title: Text(
                              suggestion,
                              style: AppTextStyles.futuraBook400.copyWith(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Icon(
                              Icons.north_west,
                              color: AppColors.grayMedium,
                              size: 16.sp,
                            ),
                            onTap: () => _selectLocation(suggestion),
                          );
                        },
                      )
                    : _buildDefaultSuggestions(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.buttonclr.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 45.w,
              height: 45.h,
              decoration: BoxDecoration(
                color: AppColors.buttonclr.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: isLoading
                  ? Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.buttonclr,
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      color: AppColors.buttonclr,
                      size: 24.sp,
                    ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.futuraDemi.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.grayMedium,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.grayMedium,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultSuggestions() {
    final defaultSuggestions = [
      {'title': 'Home', 'subtitle': 'Set your home address'},
      {'title': 'Work', 'subtitle': 'Set your work address'},
      {'title': 'School', 'subtitle': 'Set your school address'},
    ];

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      itemCount: defaultSuggestions.length,
      separatorBuilder: (context, index) => Divider(
        height: 1.h,
        color: AppColors.grayLight.withValues(alpha: 0.3),
      ),
      itemBuilder: (context, index) {
        final suggestion = defaultSuggestions[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.txtfieldbgclr,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.location_on_outlined,
              color: AppColors.grayMedium,
              size: 20.sp,
            ),
          ),
          title: Text(
            suggestion['title']!,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 14.sp,
            ),
          ),
          subtitle: Text(
            suggestion['subtitle']!,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 12.sp,
              color: AppColors.grayMedium,
            ),
          ),
          onTap: () => _selectLocation(suggestion['title']!),
        );
      },
    );
  }
}