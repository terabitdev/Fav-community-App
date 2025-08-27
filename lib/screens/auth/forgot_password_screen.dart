import 'package:fava/app/routes.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/validators.dart';
import 'package:fava/providers/auth_provider.dart';
import 'package:fava/widgets/auth/custom_auth_header.dart';
import 'package:fava/widgets/auth/social_login_section.dart';
import 'package:fava/widgets/common/custom_elevated_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();

  String? _currentError;
  bool _hasEmailError = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    _emailFocusNode.dispose();
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

  Future<void> _handleSend() async {
    final authProvider = context.read<AuthProvider>();
    authProvider.clearState();

    final emailError = AppValidators.validateEmail(_emailController.text);

    if (emailError != null) {
      _emailFocusNode.requestFocus();
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

    // Call the forgot password function
    final success = await authProvider.sendPasswordReset(
      email: _emailController.text.trim(),
    );

    if (success && mounted) {
      // Navigate to next screen on successful password reset request
      context.pushNamed(AppRoute.setNewPassword.name);
    }
    // If failed, error will be shown automatically via Consumer<AuthProvider>
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
    FocusScope.of(context).unfocus();
    _handleSend();
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
                    title: 'Forgot Password',
                    subtitle: 'Forgot Password',
                    appLogo: true,
                  ),
                  SizedBox(height: 15.h),

                  _CustomTextFormField(
                    labelText: "Email Address",
                    hintText: "you@email.example",
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    hasError: _hasEmailError,
                    onFieldSubmitted: _handleEmailSubmitted,
                  ),

                  SizedBox(height: 25.h),

                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return CustomElevatedButton(
                        text: "Send",
                        onPressed: authProvider.isLoading ? null : _handleSend,
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

                  SizedBox(height: 7.h),

                  Align(
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Back to ",
                            style: AppTextStyles.manroperegular400.copyWith(
                              fontSize: 12.sp,
                              color: grayMedium,
                            ),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  context.pushNamed(AppRoute.login.name),
                            text: "Sign In",
                            style: AppTextStyles.manroperegular400.copyWith(
                              fontSize: 12.sp,
                              color: blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 96.h),
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

// Custom Text Field for Forgot Password Screen (No Error Display Below)
class _CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final bool hasError;

  const _CustomTextFormField({
    this.hintText,
    this.labelText,
    this.controller,
    this.keyboardType,
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
            keyboardType: keyboardType,
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

// class ContactMethodRadio extends StatefulWidget {
//   final Function(String) onChanged;
//   final String initialValue;

//   const ContactMethodRadio({
//     super.key,
//     required this.onChanged,
//     this.initialValue = 'email', // Default value is 'email'
//   });

//   @override
//   State<ContactMethodRadio> createState() => _ContactMethodRadioState();
// }

// class _ContactMethodRadioState extends State<ContactMethodRadio> {
//   late String selectedMethod;

//   @override
//   void initState() {
//     super.initState();
//     selectedMethod = widget.initialValue;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         _buildCustomRadioOption('email', 'Email'),
//         SizedBox(height: 27.h),
//         _buildCustomRadioOption('phone', 'Phone'),
//       ],
//     );
//   }

//   Widget _buildCustomRadioOption(String value, String label) {
//     final bool isSelected = selectedMethod == value;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedMethod = value;
//         });
//         widget.onChanged(value);
//       },
//       child: Row(
//         children: [
//           // SVG Radio Button - just replace the icon
//           SvgPicture.asset(
//             isSelected
//                 ? 'assets/icons/radio_selected.svg' // Your selected SVG icon
//                 : 'assets/icons/radio_unselected.svg', // Your unselected SVG icon
//             width: 14.w,
//             height: 14.h,
//           ),
//           SizedBox(width: 14.w),
//           Text(
//             label,
//             style: AppTextStyles.futuraBook400.copyWith(fontSize: 18.sp),
//           ),
//         ],
//       ),
//     );
//   }
// }
