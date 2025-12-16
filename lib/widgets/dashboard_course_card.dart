import 'package:flutter/material.dart';
import '../core/constants.dart';

class DashboardCourseCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const DashboardCourseCard({
    Key? key,
    required this.title,
    required this.icon,
    this.iconColor = Colors.blue,
    this.bgColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140, // Fixed width for horizontal list
      margin: EdgeInsets.only(right: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),
          SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 12),
          // Decorative lines
          Container(height: 4, width: 60, color: Colors.blue[50], margin: EdgeInsets.only(bottom: 4)),
          Container(height: 4, width: 40, color: Colors.blue[100]),
        ],
      ),
    );
  }
}
