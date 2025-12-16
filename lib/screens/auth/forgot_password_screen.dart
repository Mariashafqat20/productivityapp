import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reset Password', style: AppTextStyles.heading1),
                SizedBox(height: 8),
                Text(
                  "Enter your email address and we'll send you a link to reset your password.",
                  style: AppTextStyles.bodyLarge,
                ),
                SizedBox(height: 32),
                 Container(
                  decoration: BoxDecoration(
                    color: AppColors.neutral,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      hintStyle: AppTextStyles.bodyMedium,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                ),
                SizedBox(height: 32),
                CustomButton(
                  text: 'Send OTP Link',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                       Navigator.push(context, MaterialPageRoute(builder: (_) => OtpVerificationScreen()));
                    }
                  },
                ),
                SizedBox(height: 24),
                 Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Back to login', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight)),
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
