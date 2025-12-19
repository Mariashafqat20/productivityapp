import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../dashboard/entry_point.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                Text('Welcome Back!', style: AppTextStyles.heading1),
                SizedBox(height: 8),
                Text(
                  'Happy to see you again! Please enter your email and password to login to your account.',
                  style: AppTextStyles.bodyLarge,
                ),
                SizedBox(height: 48),
                CustomTextField(
                  hintText: 'Email Address',
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
                ),
                SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Password',
                  controller: passwordController,
                  isPassword: true,
                  suffixIcon: Icon(Icons.visibility_off_outlined, color: AppColors.textLight),
                  validator: (value) {
                     if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                     }
                     if (value.length < 6) return 'Password must be at least 6 characters';
                     return null;
                  },
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordScreen()));
                    },
                    child: Text('Recovery Password', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight)),
                  ),
                ),
                SizedBox(height: 32),
                CustomButton(
                  text: 'Login',
                  isLoading: Provider.of<UserProvider>(context).isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await Provider.of<UserProvider>(context, listen: false).login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                        // Navigation handled by stream in main or check success here
                        // Since we are not using a StreamBuilder for the whole app structure yet,
                        // we can manually navigate on success if no error thrown
                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EntryPoint()));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login Failed: ${e.toString()}")),
                        );
                      }
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
                       Icon(Icons.g_mobiledata, size: 32, color: Colors.blue), // Placeholder for Google Icon
                       SizedBox(width: 8),
                       Text('Login with Google', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark)),
                    ],
                  ),
                ),
                SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: AppTextStyles.bodyMedium),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreen()));
                      },
                      child: Text('Sign up', style: AppTextStyles.button.copyWith(color: AppColors.primary)),
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

