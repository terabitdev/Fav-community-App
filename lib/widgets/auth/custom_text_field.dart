import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatefulWidget {
  final bool? enabled;
  final TextStyle? labelTextStyle;
  final Widget? prefixIcon;
  final int? maxLines;
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
  final bool? hasError;

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
    this.maxLines = 1,
    this.prefixIcon,
    this.labelTextStyle,
    this.enabled = true,
    this.hasError,
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
    // Use external hasError if provided, otherwise use internal error state
    final bool currentErrorState = widget.hasError ?? hasError;
    
    // Determine colors based on error state
    final Color labelColor = currentErrorState ? AppColors.errorclr : Colors.black;
    final Color textColor = currentErrorState
        ? AppColors.errorclr
        : AppColors
              .grayDark; // Text color changes to AppColors.errorClr on error
    final Color cursorColor = currentErrorState
        ? AppColors.errorclr
        : AppColors
              .grayDark; // Cursor color changes to AppColors.errorClr on error
    final Color borderColor = currentErrorState ? AppColors.errorclr : Colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label Text
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style:
                widget.labelTextStyle ??
                AppTextStyles.futuraBook400.copyWith(
                  fontSize: 12.sp,
                  color: labelColor,
                ),
          ),
          SizedBox(height: 4.h),
        ],

        // Text Field Container with Fixed Height
        SizedBox(
          height: widget.maxLines == 1 ? 36.h : 133.h,
          child: TextFormField(
            key: _fieldKey,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 12.sp,
              color: textColor, // Dynamic text color based on error state
            ),
            cursorColor:
                cursorColor, // Dynamic cursor color based on error state
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: widget.obscureText ?? false,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            inputFormatters: widget.inputFormatters,
            enabled: widget.enabled,
            onFieldSubmitted: widget.onFieldSubmitted,
            onChanged: (value) {
              // Clear error immediately when user starts typing (only if using internal error state)
              if (widget.hasError == null && hasError) {
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
              // Skip validation if external hasError is being used
              if (widget.hasError != null) {
                return null;
              }
              
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
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              hintText: widget.hintText,
              hintStyle: AppTextStyles.futuraBook400.copyWith(
                color: AppColors.hintxtclr,
                fontSize: 12.sp,
              ),
              filled: true,
              fillColor: AppColors.txtfieldbgclr,

              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 10.h,
              ),

              // Hide default error text (we'll show our own)
              errorStyle: const TextStyle(height: 0, fontSize: 0),

              // Error borders - using AppColors.errorClr with width 1 (your manual change)
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.errorclr, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.errorclr, width: 1),
              ),

              // Normal borders - dynamic based on error state when hasError is provided
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: borderColor,
                  width: borderColor == Colors.transparent ? 0 : 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: borderColor,
                  width: borderColor == Colors.transparent ? 0 : 1,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.grayLight, width: 1),
              ),
            ),
          ),
        ),

        // Custom Error Message Display (only if not using external hasError)
        if (widget.hasError == null && hasError && errorMessage != null) ...[
          SizedBox(height: 4.h),
          Text(
            errorMessage!,
            style: AppTextStyles.futuraBook400.copyWith(
              color: AppColors.errorclr,
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
