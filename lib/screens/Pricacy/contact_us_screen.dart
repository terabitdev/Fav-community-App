import 'package:fava/core/utils/validators.dart';
import 'package:fava/widgets/auth/custom_app_bar.dart';
import 'package:fava/widgets/auth/custom_text_field.dart';
import 'package:fava/widgets/common/custom_elevated_button.dart';
import 'package:fava/widgets/support/ratings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsScreen extends StatefulWidget {
  final String from;
  
  const ContactUsScreen({super.key, required this.from});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _subjectFocusNode = FocusNode();
  final _messageFocusNode = FocusNode();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _subjectFocusNode.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _handleSendMessage() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, handle send logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppBar(
                  topHeight: 22,
                  title: "Send Us a Message",
                  backButton: true,
                  appLogo: true,
                  subtitle: "Send Us a Message",
                ),
                SizedBox(height: 12.h),
                widget.from == "feedback"
                    ? Align(alignment: Alignment.center, child: RatingsWidget())
                    : const SizedBox(),
                SizedBox(height: 12.h),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        labelText: "Subject",
                        hintText: "Enter Title",
                        controller: _subjectController,
                        focusNode: _subjectFocusNode,
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.validateName,
                        onFieldSubmitted: (_) => _messageFocusNode.requestFocus(),
                      ),
                      CustomTextFormField(
                        maxLines: 8,
                        labelText: "Message",
                        controller: _messageController,
                        focusNode: _messageFocusNode,
                        textInputAction: TextInputAction.done,
                        validator: AppValidators.validateDescription,
                        onFieldSubmitted: (_) => _handleSendMessage(),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
                SizedBox(height: 34.h),
                CustomElevatedButton(
                  text: "Send",
                  onPressed: _handleSendMessage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
