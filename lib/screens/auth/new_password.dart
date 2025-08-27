import 'package:fava/app/routes.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/validators.dart';
import 'package:fava/providers/auth_provider.dart';
import 'package:fava/widgets/auth/custom_auth_header.dart';
import 'package:fava/widgets/auth/social_login_section.dart';
import 'package:fava/widgets/common/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SetNewPassword extends StatefulWidget {
  const SetNewPassword({super.key});

  @override
  State<SetNewPassword> createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String? _currentError;
  bool _hasPasswordError = false;
  bool _hasConfirmPasswordError = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_onPasswordChanged);
    _confirmPasswordController.removeListener(_onConfirmPasswordChanged);
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    if (_hasPasswordError) {
      final error = AppValidators.validatePassword(_passwordController.text);
      if (error == null) {
        setState(() {
          _hasPasswordError = false;
          _currentError = null;
        });
      }
    }
    context.read<AuthProvider>().clearError();
  }

  void _onConfirmPasswordChanged() {
    if (_hasConfirmPasswordError) {
      final error = AppValidators.validateConfirmPassword(
        _confirmPasswordController.text,
        _passwordController.text,
      );
      if (error == null) {
        setState(() {
          _hasConfirmPasswordError = false;
          _currentError = null;
        });
      }
    }
    context.read<AuthProvider>().clearError();
  }

  Future<void> _handleSetPassword() async {
    final authProvider = context.read<AuthProvider>();
    authProvider.clearState();

    _validateAndFocus();

    if (!_hasPasswordError && !_hasConfirmPasswordError) {
      // Call the set new password function
      final success = await authProvider.setNewPassword(
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        resetToken:
            "valid_token", // In real app, this would come from the reset link
      );

      if (success && mounted) {
        // Navigate to login screen on successful password reset
        context.pushReplacementNamed(AppRoute.login.name);
      }
      // If failed, error will be shown automatically via Consumer<AuthProvider>
    }
  }

  void _validateAndFocus() {
    final passwordError = AppValidators.validatePassword(
      _passwordController.text,
    );
    final confirmPasswordError = AppValidators.validateConfirmPassword(
      _confirmPasswordController.text,
      _passwordController.text,
    );

    // Focus on first invalid field only
    if (passwordError != null) {
      _passwordFocusNode.requestFocus();
      setState(() {
        _hasPasswordError = true;
        _hasConfirmPasswordError = false;
        _currentError = passwordError;
      });
    } else if (confirmPasswordError != null) {
      _confirmPasswordFocusNode.requestFocus();
      setState(() {
        _hasPasswordError = false;
        _hasConfirmPasswordError = true;
        _currentError = confirmPasswordError;
      });
    } else {
      setState(() {
        _hasPasswordError = false;
        _hasConfirmPasswordError = false;
        _currentError = null;
      });
    }
  }

  void _handlePasswordSubmitted(String value) {
    final passwordError = AppValidators.validatePassword(value);
    if (passwordError != null) {
      setState(() {
        _hasPasswordError = true;
        _hasConfirmPasswordError = false;
        _currentError = passwordError;
      });
      return;
    }

    setState(() {
      _hasPasswordError = false;
      _currentError = null;
    });
    _confirmPasswordFocusNode.requestFocus();
  }

  void _handleConfirmPasswordSubmitted(String value) {
    final confirmPasswordError = AppValidators.validateConfirmPassword(
      value,
      _passwordController.text,
    );
    if (confirmPasswordError != null) {
      setState(() {
        _hasPasswordError = false;
        _hasConfirmPasswordError = true;
        _currentError = confirmPasswordError;
      });
      return;
    }

    setState(() {
      _hasConfirmPasswordError = false;
      _currentError = null;
    });
    FocusScope.of(context).unfocus();
    _handleSetPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bgclr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 21.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 22.h),
                  CustomAppBar(
                    backButton: true,
                    subtitle: 'New Password',
                    title: "New Password",
                    appLogo: true,
                  ),
                  SizedBox(height: 15.h),

                  _CustomTextFormField(
                    labelText: "Password",
                    hintText: "Set New Password",
                    obscureText: true,
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.next,
                    hasError: _hasPasswordError,
                    onFieldSubmitted: _handlePasswordSubmitted,
                  ),
                  SizedBox(height: 10.h),

                  _CustomTextFormField(
                    labelText: "Confirm Password",
                    hintText: "Confirm Your Password",
                    obscureText: true,
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    textInputAction: TextInputAction.done,
                    hasError: _hasConfirmPasswordError,
                    onFieldSubmitted: _handleConfirmPasswordSubmitted,
                  ),

                  SizedBox(height: 25.h),

                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return CustomElevatedButton(
                        text: "Set Password",
                        onPressed: authProvider.isLoading
                            ? null
                            : _handleSetPassword,
                        isLoading: authProvider.isLoading,
                      );
                    },
                  ),

                  SizedBox(height: 10.h),

                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      final authError =
                          authProvider.errorMessage != null &&
                              authProvider.status == AuthStatus.failure
                          ? authProvider.errorMessage!
                          : null;

                      final errorMessage = authError ?? _currentError ?? "";

                      return _ErrorMessageWidget(message: errorMessage);
                    },
                  ),

                  SizedBox(height: 43.h),
                  SocialLoginSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Text Field for Set New Password Screen (No Error Display Below)
class _CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool? obscureText;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final bool hasError;

  const _CustomTextFormField({
    this.hintText,
    this.labelText,
    this.controller,
    this.obscureText,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    final Color labelColor = hasError ? errorclr : Colors.black;
    final Color textColor = hasError ? errorclr : grayDark;
    final Color cursorColor = hasError ? errorclr : grayDark;
    final Color borderColor = hasError ? errorclr : Colors.transparent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 12.sp,
              color: labelColor,
            ),
          ),
          SizedBox(height: 4.h),
        ],

        SizedBox(
          height: 36.h,
          child: TextFormField(
            style: AppTextStyles.futuraBook400.copyWith(
              fontSize: 12.sp,
              color: textColor,
            ),
            cursorColor: cursorColor,
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText ?? false,
            textInputAction: textInputAction,
            onFieldSubmitted: onFieldSubmitted,

            decoration: InputDecoration(
              hintText: hintText,
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
                borderSide: BorderSide(color: grayLight, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Error Message Widget
class _ErrorMessageWidget extends StatelessWidget {
  final String message;

  const _ErrorMessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: txtfieldbgclr,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: errorclr, width: 1),
      ),
      child: Text(
        message,
        style: AppTextStyles.futuraBook400.copyWith(
          fontSize: 12.sp,
          color: errorclr,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
