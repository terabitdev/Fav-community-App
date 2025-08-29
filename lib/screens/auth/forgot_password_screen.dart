import 'package:fava/app/routes.dart';
import 'package:fava/core/constants/colors.dart';
import 'package:fava/core/utils/app_text_styles.dart';
import 'package:fava/core/utils/validators.dart';
import 'package:fava/providers/auth_provider.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:fava/widgets/auth/custom_text_field.dart';
import 'package:fava/widgets/auth/error_message_widget.dart';
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
  
  void _onEmailChanged() {
    context.read<AuthProvider>().handleEmailChanged();
  }


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

  void _handleSend() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.handleForgotPasswordSubmit(
      formKey: _formKey,
      email: _emailController.text,
      onSuccess: () {
        if (mounted) {
          context.pushNamed(AppRoute.setNewPassword.name);
        }
      },
    );
  }

  void _handleEmailSubmitted(String value) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.handleEmailSubmitted(
      formKey: _formKey,
      email: _emailController.text,
      dismissKeyboard: () => FocusScope.of(context).unfocus(),
      onSuccess: () {
        if (mounted) {
          context.pushNamed(AppRoute.setNewPassword.name);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.bgclr,
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

                  CustomTextFormField(
                    labelText: "Email Address",
                    hintText: "you@email.example",
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    validator: AppValidators.validateEmail,
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

                      final errorMessage = authError ?? "";

                      return ErrorMessageWidget(message: errorMessage);
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
                              color: AppColors.grayMedium,
                            ),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  context.pushNamed(AppRoute.login.name),
                            text: "Sign In",
                            style: AppTextStyles.manroperegular400.copyWith(
                              fontSize: 12.sp,
                              color: AppColors.blue,
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

