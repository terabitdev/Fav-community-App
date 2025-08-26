import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class LocationSelectionWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Function(String address, Position? position)? onLocationSelected;
  final String? initialValue;
  final bool allowCurrentLocation;
  
  const LocationSelectionWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    this.onLocationSelected,
    this.initialValue,
    this.allowCurrentLocation = true,
  });

  @override
  State<LocationSelectionWidget> createState() => _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  final TextEditingController _controller = TextEditingController();
  final LocationServices _locationService = LocationServices();
  String? _selectedAddress;
  Position? _selectedPosition;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue ?? '';
    _selectedAddress = widget.initialValue;
  }

  @override
  void dispose() {
    _controller.dispose();
    _locationService.dispose();
    super.dispose();
  }

  void _showLocationOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: bgclr,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: Column(
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: grayMedium,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'Select Location',
                    style: AppTextStyles.futuraDemi.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  
                  // Search field
                  Container(
                    decoration: BoxDecoration(
                      color: txtfieldbgclr,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Search for a location...',
                        hintStyle: AppTextStyles.futuraBook400.copyWith(
                          fontSize: 14.sp,
                          color: hintxtclr,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: hintxtclr,
                          size: 20.sp,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                      ),
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          final result = await _locationService.searchLocation(value);
                          
                          if (result != null && mounted) {
                            setState(() {
                              _selectedAddress = result;
                              _selectedPosition = _locationService.currentPosition;
                            });
                            widget.onLocationSelected?.call(result, _locationService.currentPosition);
                            Navigator.pop(context);
                          } else {
                            _showErrorSnackBar(_locationService.error ?? 'Location not found');
                          }
                        }
                      },
                    ),
                  ),
                  
                  if (widget.allowCurrentLocation) ...[
                    SizedBox(height: 16.h),
                    ListenableBuilder(
                      listenable: _locationService,
                      builder: (context, child) {
                        return _buildLocationOption(
                          icon: Icons.my_location,
                          title: 'Use Current Location',
                          subtitle: 'Get your current position',
                          onTap: () async {
                            final success = await _locationService.getCurrentLocation();
                            
                            if (success && _locationService.currentAddress != null && mounted) {
                              setState(() {
                                _controller.text = _locationService.currentAddress!;
                                _selectedAddress = _locationService.currentAddress;
                                _selectedPosition = _locationService.currentPosition;
                              });
                              widget.onLocationSelected?.call(
                                _locationService.currentAddress!,
                                _locationService.currentPosition,
                              );
                              Navigator.pop(context);
                            } else if (!success && mounted) {
                              _showErrorSnackBar(_locationService.error ?? 'Failed to get location');
                            }
                          },
                          isLoading: _locationService.isLoading,
                        );
                      },
                    ),
                  ],
                  
                  SizedBox(height: 16.h),
                  
                  // Recent locations or suggestions
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Suggestions',
                          style: AppTextStyles.futuraDemi.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Expanded(
                          child: ListView(
                            children: [
                              _buildSuggestionTile('Home', 'Set your home address'),
                              _buildSuggestionTile('Work', 'Set your work address'),
                              _buildSuggestionTile('School', 'Set your school address'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
            color: buttonclr.withOpacity(0.3),
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
                color: buttonclr.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: isLoading
                  ? Center(
                      child: SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: buttonclr,
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      color: buttonclr,
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
                      color: grayMedium,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: grayMedium,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionTile(String title, String subtitle) {
    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: txtfieldbgclr,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(
          Icons.location_on_outlined,
          color: grayMedium,
          size: 20.sp,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.futuraBook400.copyWith(
          fontSize: 14.sp,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.futuraBook400.copyWith(
          fontSize: 12.sp,
          color: grayMedium,
        ),
      ),
      onTap: () {
        // Handle suggestion tap
        setState(() {
          _controller.text = title;
          _selectedAddress = title;
        });
        widget.onLocationSelected?.call(title, null);
        Navigator.pop(context);
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: errorclr,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText.isNotEmpty) ...[
          Text(
            widget.labelText,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
        ],
        GestureDetector(
          onTap: _showLocationOptions,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: txtfieldbgclr,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: _selectedAddress != null ? successclr : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: _selectedAddress != null ? successclr : hintxtclr,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    _selectedAddress ?? widget.hintText,
                    style: AppTextStyles.futuraBook400.copyWith(
                      fontSize: 14.sp,
                      color: _selectedAddress != null ? Colors.black87 : hintxtclr,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_selectedAddress != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _controller.clear();
                        _selectedAddress = null;
                        _selectedPosition = null;
                      });
                      widget.onLocationSelected?.call('', null);
                    },
                    child: Icon(
                      Icons.clear,
                      color: grayMedium,
                      size: 18.sp,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}