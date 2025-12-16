import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
// import 'map_replacement_screen.dart'; // Next flow

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

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
          child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text('Enter verification code', style: AppTextStyles.heading1),
               SizedBox(height: 8),
               Text(
                  "We've sent a 6-digit code to your email.",
                  style: AppTextStyles.bodyLarge,
               ),
               SizedBox(height: 32),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: List.generate(6, (index) => _buildOtpDigit(context)),
               ),
               SizedBox(height: 32),
               CustomButton(
                 text: 'Verify OTP',
                 onPressed: () {
                   // Verify and Navigate
                   Navigator.popUntil(context, (route) => route.isFirst); // Go back to login for now
                 },
               ),
               SizedBox(height: 24),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text("Didn't get the code? ", style: AppTextStyles.bodyMedium), 
                   GestureDetector(
                     onTap: () {
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("OTP Resent!")));
                     },
                     child: Text("Resend", style: AppTextStyles.button.copyWith(color: AppColors.primary, decoration: TextDecoration.underline)),
                   ),
                 ],
               )
             ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpDigit(BuildContext context) {
    return Container(
      width: 45,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: TextField(
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: AppTextStyles.heading2,
          decoration: InputDecoration(
            counterText: "",
            border: InputBorder.none,
          ),
          onChanged: (value) {
             if (value.length == 1) {
               FocusScope.of(context).nextFocus();
             }
          },
        ),
      ),
    );
  }
}
