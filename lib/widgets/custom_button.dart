import 'package:flutter/material.dart';
import '../core/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  final dynamic isOutlined;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : AppColors.primary,
          elevation: isOutlined ? 0 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isOutlined ? BorderSide(color: AppColors.primary) : BorderSide.none,
          ),
        ),
        child: isLoading 
          ? SizedBox(
              height: 24, 
              width: 24, 
              child: CircularProgressIndicator(
                color: isOutlined ? AppColors.primary : Colors.white,
                strokeWidth: 2,
              )
            )
          : Text(
              text,
              style: AppTextStyles.button.copyWith(
                color: isOutlined ? AppColors.primary : Colors.white,
              ),
            ),
      ),
    );
  }
}
