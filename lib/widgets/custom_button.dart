import 'package:flutter/material.dart';
import '../core/constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.transparent : AppColors.primary,
          elevation: isOutlined ? 0 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isOutlined ? BorderSide(color: AppColors.primary) : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button.copyWith(
            color: isOutlined ? AppColors.primary : Colors.white,
          ),
        ),
      ),
    );
  }
}
