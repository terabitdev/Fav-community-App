import 'package:fava/app/routes.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/validators.dart';
import 'package:fava/providers/auth_provider.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:fava/widgets/auth/custom_text_field.dart';
import 'package:fava/widgets/auth/location_sharing.dart';
import 'package:fava/widgets/auth/social_login_section.dart';
import 'package:fava/widgets/common/custom_elevated_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/* ORIGINAL LOGIN SCREEN - COMMENTED OUT
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLocationEnabled = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // FocusNodes for keyboard navigation
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add listeners to controllers for real-time error clearing
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _passwordController.removeListener(_onPasswordChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Clear auth errors when user types in email
  void _onEmailChanged() {
    context.read<AuthProvider>().clearError();
  }

  // Clear auth errors when user types in password
  void _onPasswordChanged() {
    context.read<AuthProvider>().clearError();
  }

  Future<void> _handleSignIn() async {
    final authProvider = context.read<AuthProvider>();

    // Always clear auth state first (including any previous auth errors)
    authProvider.clearState();

    // Validate form first - this will show field errors if validation fails
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (isFormValid) {
      // Form validation passed - now attempt login (this will trigger loading state)
      final success = await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        enableLocation: isLocationEnabled,
      );

      if (success && mounted) {
        // Navigate to next screen on successful login
        context.pushNamed(AppRoute.onboarding1.name);
      }
      // If login fails, auth error will be shown automatically via provider
    }
    // If form validation fails, field errors are shown automatically by validators
    // No loading state is triggered, no auth errors are shown
  }

  // Handle keyboard navigation
  void _handleEmailSubmitted(String value) {
    // Move focus from email to password field
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _handlePasswordSubmitted(String value) {
    // Dismiss keyboard and attempt sign in
    FocusScope.of(context).unfocus();
    _handleSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgclr,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomAppBar(backButton: false, title: "Sign In"),
                  SizedBox(height: 23.h),

                  // Email Field - Using your existing validator with FocusNode
                  CustomTextFormField(
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.validateEmail,
                    onFieldSubmitted: _handleEmailSubmitted,
                  ),
                  SizedBox(height: 10.h),

                  // Password Field - Using your existing validator with FocusNode
                  CustomTextFormField(
                    labelText: "Password",
                    hintText: "Enter your password",
                    obscureText: true,
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    validator: AppValidators.validatePassword,
                    onFieldSubmitted: _handlePasswordSubmitted,
                  ),
                  SizedBox(height: 7.h),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () =>
                          context.pushNamed(AppRoute.forgotPassword.name),
                      child: Text(
                        "Forgot Password?",
                        style: AppTextStyles.manroperegular400.copyWith(
                          color: blue,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 11.h),

                  // Location Sharing
                  LocationSharingWidget(
                    isEnabled: isLocationEnabled,
                    onChanged: (value) {
                      setState(() {
                        isLocationEnabled = value;
                      });
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Sign In Button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return CustomElevatedButton(
                        text: "Sign In",
                        onPressed: authProvider.isLoading
                            ? null
                            : _handleSignIn,
                        isLoading: authProvider.isLoading,
                      );
                    },
                  ),
                  SizedBox(height: 7.h),

                  // Sign Up Prompt
                  _SignUpPromptWidget(),
                  SizedBox(height: 7.h),

                  // Auth Error Message - Only shows for authentication failures, not form validation errors
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      // Only show auth errors when:
                      // 1. There's an error message from auth provider
                      // 2. The auth status is failure (meaning form validation passed but auth failed)
                      final shouldShowAuthError =
                          authProvider.errorMessage != null &&
                          authProvider.status == AuthStatus.failure;

                      return _ErrorMessageWidget(
                        message: shouldShowAuthError
                            ? authProvider.errorMessage!
                            : "",
                      );
                    },
                  ),
                  SizedBox(height: 7.h),

                  // Social Login Section
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
END OF ORIGINAL LOGIN SCREEN */

// NEW LOGIN SCREEN WITH REFINED VALIDATION
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLocationEnabled = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String? _currentError;
  bool _hasEmailError = false;
  bool _hasPasswordError = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _passwordController.removeListener(_onPasswordChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    if (_hasEmailError) {
      final error = AppValidators.validateEmail(_emailController.text);
      if (error == null) {
        setState(() {
          _hasEmailError = false;
          _currentError = null;
        });
      }
    }
    context.read<AuthProvider>().clearError();
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

  Future<void> _handleValidate() async {
    final authProvider = context.read<AuthProvider>();
    authProvider.clearState();

    _validateAndFocus();

    if (!_hasEmailError && !_hasPasswordError) {
      final success = await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        enableLocation: isLocationEnabled,
      );

      if (success && mounted) {
        context.pushNamed(AppRoute.onboarding1.name);
      }
    }
  }

  void _validateAndFocus() {
    final emailError = AppValidators.validateEmail(_emailController.text);
    final passwordError = AppValidators.validatePassword(
      _passwordController.text,
    );

    // Focus on first invalid field only
    if (emailError != null) {
      _emailFocusNode.requestFocus();
      setState(() {
        _hasEmailError = true;
        _hasPasswordError = false;
        _currentError = emailError;
      });
    } else if (passwordError != null) {
      _passwordFocusNode.requestFocus();
      setState(() {
        _hasEmailError = false;
        _hasPasswordError = true;
        _currentError = passwordError;
      });
    } else {
      setState(() {
        _hasEmailError = false;
        _hasPasswordError = false;
        _currentError = null;
      });
    }
  }

  void _handleEmailSubmitted(String value) {
    final emailError = AppValidators.validateEmail(value);
    if (emailError != null) {
      setState(() {
        _hasEmailError = true;
        _currentError = emailError;
      });
      return;
    }

    setState(() {
      _hasEmailError = false;
      _currentError = null;
    });
    _passwordFocusNode.requestFocus();
  }

  void _handlePasswordSubmitted(String value) {
    final passwordError = AppValidators.validatePassword(value);
    if (passwordError != null) {
      setState(() {
        _hasPasswordError = true;
        _currentError = passwordError;
      });
      return;
    }

    setState(() {
      _hasPasswordError = false;
      _currentError = null;
    });
    FocusScope.of(context).unfocus();
    _handleValidate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bgclr,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomAppBar(
                    backButton: false,
                    title: "Sign In",
                    subtitle: "Sign In",
                    appLogo: true,
                  ),
                  SizedBox(height: 23.h),

                  CustomTextFormField(
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    hasError: _hasEmailError,
                    onFieldSubmitted: _handleEmailSubmitted,
                  ),
                  SizedBox(height: 10.h),

                  CustomTextFormField(
                    labelText: "Password",
                    hintText: "Enter your password",
                    obscureText: true,
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    hasError: _hasPasswordError,
                    onFieldSubmitted: _handlePasswordSubmitted,
                  ),
                  SizedBox(height: 7.h),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Clear any authentication errors before navigating
                        context.read<AuthProvider>().clearState();
                        context.pushNamed(AppRoute.forgotPassword.name);
                      },
                      child: Text(
                        "Forgot Password?",
                        style: AppTextStyles.manroperegular400.copyWith(
                          color: AppColors.blue,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 11.h),

                  LocationSharingWidget(
                    isEnabled: isLocationEnabled,
                    onChanged: (value) {
                      setState(() {
                        isLocationEnabled = value;
                      });
                    },
                  ),
                  SizedBox(height: 15.h),

                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return CustomElevatedButton(
                        text: "Sign In",
                        onPressed: authProvider.isLoading
                            ? null
                            : _handleValidate,
                        isLoading: authProvider.isLoading,
                      );
                    },
                  ),
                  SizedBox(height: 7.h),

                  _SignUpPromptWidget(),
                  SizedBox(height: 7.h),

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
                  SizedBox(height: 7.h),

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


// Sign Up Prompt Widget
class _SignUpPromptWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Don't have an account? ",
              style: AppTextStyles.manroperegular400.copyWith(
                fontSize: 12.sp,
                color: AppColors.grayMedium,
              ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.pushNamed(AppRoute.signup.name),
              text: "Sign Up",
              style: AppTextStyles.manroperegular400.copyWith(
                fontSize: 12.sp,
                color: AppColors.blue,
              ),
            ),
          ],
        ),
      ),
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
        color: AppColors.txtfieldbgclr,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.errorclr, width: 1),
      ),
      child: Text(
        message,
        style: AppTextStyles.futuraBook400.copyWith(
          fontSize: 12.sp,
          color: AppColors.errorclr,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
