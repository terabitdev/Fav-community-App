import 'package:fava/core/constants/colors.dart';
import 'package:fava/providers/request_provider.dart';
import 'package:fava/widgets/auth/custom_text_field.dart';
import 'package:fava/widgets/common/location_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

class LocationSelectionWidget extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Function(String address, Position? position)? onLocationSelected;
  final String? initialValue;
  final bool allowCurrentLocation;
  final String? validationError;

  const LocationSelectionWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    this.onLocationSelected,
    this.initialValue,
    this.allowCurrentLocation = true,
    this.validationError,
    required RequestProvider provider,
  });

  @override
  State<LocationSelectionWidget> createState() =>
      _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  Future<void> _showLocationSearch() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSearchPage(
          title: 'Select ${widget.labelText}',
          hintText: widget.hintText,
          initialValue: widget.initialValue,
        ),
      ),
    );

    if (result != null && mounted) {
      widget.onLocationSelected?.call(result['address'], result['position']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError = widget.validationError != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _showLocationSearch,
          child: AbsorbPointer(
            child: CustomTextFormField(
              validator: (value) => widget.validationError,
              labelText: widget.labelText,
              hintText: widget.initialValue ?? widget.hintText,
              controller: TextEditingController(text: widget.initialValue ?? ''),
              prefixIcon: Icon(
                Icons.location_on_outlined,
                color: hasError
                    ? AppColors.errorclr
                    : (widget.initialValue != null
                        ? AppColors.buttonclr
                        : AppColors.hintxtclr),
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
