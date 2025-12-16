import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../dashboard/entry_point.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final String emailPattern =
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create Account', style: AppTextStyles.heading1),
                SizedBox(height: 8),
                Text(
                  'Join us today! Enter your details to create your account.',
                  style: AppTextStyles.bodyLarge,
                ),
                SizedBox(height: 32),
                CustomTextField(
                  hintText: 'Full Name',
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Email Address',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(emailPattern).hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Password',
                  controller: passwordController,
                  isPassword: true,
                  suffixIcon: Icon(Icons.visibility_off_outlined, color: AppColors.textLight),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                 SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Confirm Password',
                  controller: confirmPasswordController,
                  isPassword: true,
                  suffixIcon: Icon(Icons.visibility_off_outlined, color: AppColors.textLight),
                  validator: (value) {
                     if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),
                CustomButton(
                  text: 'Create Account',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => EntryPoint()), (route) => false);
                    }
                  },
                ),
                SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('or', style: AppTextStyles.bodyMedium)),
                    Expanded(child: Divider()),
                  ],
                ),
                 SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () {}, 
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: AppColors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(Icons.g_mobiledata, size: 32, color: Colors.blue), 
                       SizedBox(width: 8),
                       Text('Sign up with Google', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    ],
                  ),
                ),
                SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ", style: AppTextStyles.bodyMedium),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text('Login', style: AppTextStyles.button.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
