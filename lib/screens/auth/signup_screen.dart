import 'package:fava/app/routes.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/validators.dart';
import 'package:fava/core/utils/formatters.dart';
import 'package:fava/providers/auth_provider.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:fava/widgets/auth/location_sharing.dart';
import 'package:fava/widgets/auth/social_login_section.dart';
import 'package:fava/widgets/common/custom_elevated_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/* ORIGINAL SIGNUP SCREEN - COMMENTED OUT
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLocationEnabled = false;

  // Controllers for all fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // FocusNodes for keyboard navigation
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Add listeners to controllers for real-time error clearing
    _nameController.addListener(_triggerFormRevalidation);
    _emailController.addListener(_triggerFormRevalidation);
    _phoneController.addListener(_triggerFormRevalidation);
    _passwordController.addListener(_triggerFormRevalidation);
    _confirmPasswordController.addListener(_triggerFormRevalidation);
  }

  @override
  void dispose() {
    _nameController.removeListener(_triggerFormRevalidation);
    _emailController.removeListener(_triggerFormRevalidation);
    _phoneController.removeListener(_triggerFormRevalidation);
    _passwordController.removeListener(_triggerFormRevalidation);
    _confirmPasswordController.removeListener(_triggerFormRevalidation);

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  // Trigger form revalidation when user types
  void _triggerFormRevalidation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _formKey.currentState?.validate();
      }
    });
  }

  // Handle form submission
  Future<void> _handleSignUp() async {
    final authProvider = context.read<AuthProvider>();

    // Clear any previous auth states
    authProvider.clearState();

    // Validate form first
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (isFormValid) {
      // Form is valid, show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully!',
            style: AppTextStyles.futuraBook400.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to login as per your current logic
      if (mounted) {
        context.pushReplacementNamed(AppRoute.login.name);
      }
    }
  }

  // Keyboard navigation handlers
  void _handleNameSubmitted(String value) {
    FocusScope.of(context).requestFocus(_emailFocusNode);
  }

  void _handleEmailSubmitted(String value) {
    FocusScope.of(context).requestFocus(_phoneFocusNode);
  }

  void _handlePhoneSubmitted(String value) {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _handlePasswordSubmitted(String value) {
    FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
  }

  void _handleConfirmPasswordSubmitted(String value) {
    // Last field - dismiss keyboard and attempt signup
    FocusScope.of(context).unfocus();
    _handleSignUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgclr,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                CustomAppBar(backButton: false, title: "Sign Up"),
                SizedBox(height: 23.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name Field with validation and FocusNode
                        CustomTextFormField(
                          labelText: "Full Name",
                          hintText: "Enter your Full Name",
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: AppValidators.validateName,
                          onFieldSubmitted: _handleNameSubmitted,
                        ),
                        Text(
                          "This can be your name, a nickname can be set later.",
                          style: AppTextStyles.futuraBook400.copyWith(
                            fontSize: 10.sp,
                            color: Color.fromRGBO(145, 145, 145, 1),
                          ),
                        ),
                        SizedBox(height: 10.h),
                    
                        // Email Field with validation and FocusNode
                        CustomTextFormField(
                          labelText: "Email Address",
                          hintText: "you@email.example",
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: AppValidators.validateEmail,
                          onFieldSubmitted: _handleEmailSubmitted,
                        ),
                        SizedBox(height: 10.h),
                    
                        // Phone Field with formatting, validation and FocusNode
                        CustomTextFormField(
                          labelText: "Phone Number",
                          hintText: "(555) 555-1234",
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            PhoneNumberFormatter(),
                          ], // Auto-format phone number
                          validator: AppValidators.validatePhone,
                          onFieldSubmitted: _handlePhoneSubmitted,
                        ),
                        SizedBox(height: 10.h),
                    
                        // Password Field with validation and FocusNode
                        CustomTextFormField(
                          labelText: "Password",
                          hintText: "Enter your password",
                          obscureText: true,
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          validator: AppValidators.validatePassword,
                          onFieldSubmitted: _handlePasswordSubmitted,
                        ),
                        Text(
                          "Password must be at least 8 characters and include a number.",
                          style: AppTextStyles.futuraBook400.copyWith(
                            fontSize: 10.sp,
                            color: Color.fromRGBO(145, 145, 145, 1),
                          ),
                        ),
                        SizedBox(height: 10.h),
                    
                        // Confirm Password Field with validation and FocusNode
                        CustomTextFormField(
                          labelText: "Confirm Password",
                          hintText: "Confirm Your Password",
                          obscureText: true,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          textInputAction:
                              TextInputAction.done, // Last field - done action
                          validator: (value) =>
                              AppValidators.validateConfirmPassword(
                                value,
                                _passwordController.text,
                              ),
                          onFieldSubmitted: _handleConfirmPasswordSubmitted,
                        ),
                        SizedBox(height: 15.h),
                    
                        // Location Sharing (preserved exactly as is)
                        LocationSharingWidget(
                          isEnabled: isLocationEnabled,
                          onChanged: (value) {
                            setState(() {
                              isLocationEnabled = value;
                            });
                          },
                        ),
                        SizedBox(height: 15.h),
                    
                        // Privacy Policy (preserved exactly as is)
                        _PrivacyPolicy(),
                        SizedBox(height: 15.h),
                    
                        // Sign Up Button with form validation
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return CustomElevatedButton(
                              text: "Sign Up",
                              onPressed: authProvider.isLoading
                                  ? null
                                  : _handleSignUp,
                              isLoading: authProvider.isLoading,
                            );
                          },
                        ),
                        SizedBox(height: 7.h),
                    
                        // Sign In Prompt (preserved exactly as is)
                        _SignUpPromptWidget(),
                        SizedBox(height: 15.h),
                    
                        // Social Login Section (preserved exactly as is)
                        SocialLoginSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
END OF ORIGINAL SIGNUP SCREEN */

// NEW SIGNUP SCREEN WITH REFINED VALIDATION
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLocationEnabled = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  String? _nameError;
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
    _emailController.addListener(_onEmailChanged);
    _phoneController.addListener(_onPhoneChanged);
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _emailController.removeListener(_onEmailChanged);
    _phoneController.removeListener(_onPhoneChanged);
    _passwordController.removeListener(_onPasswordChanged);
    _confirmPasswordController.removeListener(_onConfirmPasswordChanged);

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    if (_nameError != null) {
      final error = AppValidators.validateName(_nameController.text);
      if (error == null) {
        setState(() {
          _nameError = null;
        });
      }
    }
  }

  void _onEmailChanged() {
    if (_emailError != null) {
      final error = AppValidators.validateEmail(_emailController.text);
      if (error == null) {
        setState(() {
          _emailError = null;
        });
      }
    }
  }

  void _onPhoneChanged() {
    if (_phoneError != null) {
      final error = AppValidators.validatePhone(_phoneController.text);
      if (error == null) {
        setState(() {
          _phoneError = null;
        });
      }
    }
  }

  void _onPasswordChanged() {
    if (_passwordError != null) {
      final error = AppValidators.validatePassword(_passwordController.text);
      if (error == null) {
        setState(() {
          _passwordError = null;
        });
      }
    }
  }

  void _onConfirmPasswordChanged() {
    if (_confirmPasswordError != null) {
      final error = AppValidators.validateConfirmPassword(
        _confirmPasswordController.text,
        _passwordController.text,
      );
      if (error == null) {
        setState(() {
          _confirmPasswordError = null;
        });
      }
    }
  }

  Future<void> _handleValidate() async {
    final authProvider = context.read<AuthProvider>();
    authProvider.clearState();

    _validateAndFocus();

    if (_nameError == null &&
        _emailError == null &&
        _phoneError == null &&
        _passwordError == null &&
        _confirmPasswordError == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Account created successfully!',
            style: AppTextStyles.futuraBook400.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      if (mounted) {
        context.pushReplacementNamed(AppRoute.login.name);
      }
    }
  }

  void _validateAndFocus() {
    final nameError = AppValidators.validateName(_nameController.text);
    final emailError = AppValidators.validateEmail(_emailController.text);
    final phoneError = AppValidators.validatePhone(_phoneController.text);
    final passwordError = AppValidators.validatePassword(
      _passwordController.text,
    );
    final confirmPasswordError = AppValidators.validateConfirmPassword(
      _confirmPasswordController.text,
      _passwordController.text,
    );

    // Focus on first invalid field only and show only that error
    if (nameError != null) {
      _nameFocusNode.requestFocus();
      setState(() {
        _nameError = nameError;
        _emailError = null;
        _phoneError = null;
        _passwordError = null;
        _confirmPasswordError = null;
      });
    } else if (emailError != null) {
      _emailFocusNode.requestFocus();
      setState(() {
        _nameError = null;
        _emailError = emailError;
        _phoneError = null;
        _passwordError = null;
        _confirmPasswordError = null;
      });
    } else if (phoneError != null) {
      _phoneFocusNode.requestFocus();
      setState(() {
        _nameError = null;
        _emailError = null;
        _phoneError = phoneError;
        _passwordError = null;
        _confirmPasswordError = null;
      });
    } else if (passwordError != null) {
      _passwordFocusNode.requestFocus();
      setState(() {
        _nameError = null;
        _emailError = null;
        _phoneError = null;
        _passwordError = passwordError;
        _confirmPasswordError = null;
      });
    } else if (confirmPasswordError != null) {
      _confirmPasswordFocusNode.requestFocus();
      setState(() {
        _nameError = null;
        _emailError = null;
        _phoneError = null;
        _passwordError = null;
        _confirmPasswordError = confirmPasswordError;
      });
    } else {
      setState(() {
        _nameError = null;
        _emailError = null;
        _phoneError = null;
        _passwordError = null;
        _confirmPasswordError = null;
      });
    }
  }

  void _handleNameSubmitted(String value) {
    final nameError = AppValidators.validateName(value);
    if (nameError != null) {
      setState(() {
        _nameError = nameError;
      });
      return;
    }

    setState(() {
      _nameError = null;
    });
    _emailFocusNode.requestFocus();
  }

  void _handleEmailSubmitted(String value) {
    final emailError = AppValidators.validateEmail(value);
    if (emailError != null) {
      setState(() {
        _emailError = emailError;
      });
      return;
    }

    setState(() {
      _emailError = null;
    });
    _phoneFocusNode.requestFocus();
  }

  void _handlePhoneSubmitted(String value) {
    final phoneError = AppValidators.validatePhone(value);
    if (phoneError != null) {
      setState(() {
        _phoneError = phoneError;
      });
      return;
    }

    setState(() {
      _phoneError = null;
    });
    _passwordFocusNode.requestFocus();
  }

  void _handlePasswordSubmitted(String value) {
    final passwordError = AppValidators.validatePassword(value);
    if (passwordError != null) {
      setState(() {
        _passwordError = passwordError;
      });
      return;
    }

    setState(() {
      _passwordError = null;
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
        _confirmPasswordError = confirmPasswordError;
      });
      return;
    }

    setState(() {
      _confirmPasswordError = null;
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomAppBar(
                  backButton: false,
                  title: "Sign Up",
                  subtitle: "Sign Up",
                  appLogo: true,
                ),
                SizedBox(height: 23.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CustomTextFormFieldWithInlineError(
                          labelText: "Full Name",
                          hintText: "Enter your Full Name",
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          error: _nameError,
                          helperText:
                              "This can be your name, a nickname can be set later.",
                          onFieldSubmitted: _handleNameSubmitted,
                        ),
                        SizedBox(height: 10.h),

                        _CustomTextFormFieldWithInlineError(
                          labelText: "Email Address",
                          hintText: "you@email.example",
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          error: _emailError,
                          onFieldSubmitted: _handleEmailSubmitted,
                        ),
                        SizedBox(height: 10.h),

                        _CustomTextFormFieldWithInlineError(
                          labelText: "Phone Number",
                          hintText: "(555) 555-1234",
                          controller: _phoneController,
                          focusNode: _phoneFocusNode,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [PhoneNumberFormatter()],
                          error: _phoneError,
                          onFieldSubmitted: _handlePhoneSubmitted,
                        ),
                        SizedBox(height: 10.h),

                        _CustomTextFormFieldWithInlineError(
                          labelText: "Password",
                          hintText: "Enter your password",
                          obscureText: true,
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          error: _passwordError,
                          helperText:
                              "Password must be at least 8 characters and include a number.",
                          onFieldSubmitted: _handlePasswordSubmitted,
                        ),
                        SizedBox(height: 10.h),

                        _CustomTextFormFieldWithInlineError(
                          labelText: "Confirm Password",
                          hintText: "Confirm Your Password",
                          obscureText: true,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          error: _confirmPasswordError,
                          onFieldSubmitted: _handleConfirmPasswordSubmitted,
                        ),
                        SizedBox(height: 15.h),

                        LocationSharingWidget(
                          isEnabled: isLocationEnabled,
                          onChanged: (value) {
                            setState(() {
                              isLocationEnabled = value;
                            });
                          },
                        ),
                        SizedBox(height: 15.h),

                        _PrivacyPolicy(),
                        SizedBox(height: 15.h),

                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return CustomElevatedButton(
                              text: "Sign Up",
                              onPressed: authProvider.isLoading
                                  ? null
                                  : _handleValidate,
                              isLoading: authProvider.isLoading,
                            );
                          },
                        ),
                        SizedBox(height: 7.h),

                        _SignUpPromptWidget(),
                        SizedBox(height: 15.h),

                        SocialLoginSection(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom Text Field with Inline Error for Signup Screen
class _CustomTextFormFieldWithInlineError extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final String? error;
  final String? helperText;
  final List<TextInputFormatter>? inputFormatters;

  const _CustomTextFormFieldWithInlineError({
    this.hintText,
    this.labelText,
    this.controller,
    this.obscureText,
    this.keyboardType,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
    this.error,
    this.helperText,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasError = error != null;
    final Color labelColor = hasError ? AppColors.errorclr : Colors.black;
    final Color textColor = hasError ? AppColors.errorclr : AppColors.grayDark;
    final Color cursorColor = hasError ? AppColors.errorclr : AppColors.grayDark;
    final Color borderColor = hasError ? AppColors.errorclr : Colors.transparent;

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
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            onFieldSubmitted: onFieldSubmitted,

            decoration: InputDecoration(
              hintText: hintText,
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

        // Fixed height container for helper/error text to prevent layout shift
        SizedBox(
          height: 18.h,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              hasError ? error! : (helperText ?? ""),
              style: AppTextStyles.futuraBook400.copyWith(
                fontSize: 10.sp,
                color: hasError ? AppColors.errorclr : Color.fromRGBO(145, 145, 145, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Privacy Policy Widget (preserved exactly as is)
class _PrivacyPolicy extends StatelessWidget {
  const _PrivacyPolicy();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "By continuing, you agree to FAVA's ",
            style: AppTextStyles.manroperegular400.copyWith(
              color: AppColors.grayMedium,
              fontSize: 12.sp,
            ),
          ),
          TextSpan(
            children: [
              TextSpan(
                text: "Terms ",
                style: AppTextStyles.manroperegular400.copyWith(
                  color: AppColors.blue,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          TextSpan(
            children: [
              TextSpan(
                text: "And ",
                style: AppTextStyles.manroperegular400.copyWith(
                  color: AppColors.grayMedium,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          TextSpan(
            children: [
              TextSpan(
                text: "Privacy Policy.",
                style: AppTextStyles.manroperegular400.copyWith(
                  color: AppColors.blue,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Sign In Prompt Widget (preserved exactly as is)
class _SignUpPromptWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already have an account? ",
              style: AppTextStyles.manroperegular400.copyWith(
                fontSize: 12.sp,
                color: Colors.black,
              ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => context.pushNamed(AppRoute.login.name),
              text: "Sign In",
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
