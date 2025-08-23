import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.validator,
    this.obscureText,
    this.keyboardType,
    this.onChanged,
    this.onSaved,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.inputFormatters,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String? errorMessage;
  bool hasError = false;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    // Listen to controller changes to validate in real-time
    widget.controller?.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onControllerChanged);
    super.dispose();
  }

  // Real-time validation when user types
  void _onControllerChanged() {
    if (hasError && widget.validator != null) {
      // Re-validate to clear error if input is now valid
      final currentError = widget.validator!(widget.controller?.text);
      if (currentError != errorMessage) {
        setState(() {
          errorMessage = currentError;
          hasError = currentError != null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine colors based on error state
    final Color textColor = hasError ? errorclr : grayDark; // Text color changes to errorclr on error
    final Color cursorColor = hasError ? errorclr : grayDark; // Cursor color changes to errorclr on error

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Text
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTextStyles.futuraBook400.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 4.h),
        ],
        
        // Text Field Container with Fixed Height
        SizedBox(
          height: 36.h,
          child: TextFormField(
            key: _fieldKey,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 12.sp,
              color: textColor, // Dynamic text color based on error state
            ),
            cursorColor: cursorColor, // Dynamic cursor color based on error state
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: widget.obscureText ?? false,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            onFieldSubmitted: widget.onFieldSubmitted,
            onChanged: (value) {
              // Clear error immediately when user starts typing
              if (hasError) {
                setState(() {
                  errorMessage = null;
                  hasError = false;
                });
              }
              widget.onChanged?.call(value);
            },
            onSaved: widget.onSaved,
            
            // Proper validator that handles error states correctly
            validator: (value) {
              if (widget.validator != null) {
                final error = widget.validator!(value);
                // Update error state immediately (synchronously)
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() {
                      errorMessage = error;
                      hasError = error != null;
                    });
                  }
                });
                // Return the error so FormState knows about it
                return error;
              }
              return null;
            },
            
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.futuraBook400.copyWith(
                color: hintxtclr,
                fontSize: 12.sp,
              ),
              filled: true,
              fillColor: txtfieldbgclr,
              
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ),
              
              // Hide default error text (we'll show our own)
              errorStyle: const TextStyle(height: 0, fontSize: 0),
              
              // Error borders - using errorclr with width 1 (your manual change)
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: errorclr, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: errorclr, width: 1),
              ),
              
              // Normal borders
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.transparent, width: 0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Colors.transparent, width: 0),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: grayLight, width: 1),
              ),
            ),
          ),
        ),
        
        // Custom Error Message Display
        if (hasError && errorMessage != null) ...[
          SizedBox(height: 4.h),
          Text(
            errorMessage!,
            style: AppTextStyles.futuraBook400.copyWith(
              color: errorclr,
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ],
    );
  }
  
  // Method to programmatically validate (call this from your form)
  bool validate() {
    return _fieldKey.currentState?.validate() ?? false;
  }
}