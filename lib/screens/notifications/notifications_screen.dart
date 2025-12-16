import 'package:flutter/material.dart';
import '../../core/constants.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Icon(Icons.person, color: Colors.white, size: 20), // Placeholder for profile
            ),
        ),
        actions: [
            Container(
                margin: EdgeInsets.only(right: 20, top: 12, bottom: 12),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: Icon(Icons.notifications, color: Colors.white, size: 20),
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Notifications", style: AppTextStyles.heading2),
            SizedBox(height: 24),
            
            _buildNotificationItem(
                title: "Reminder",
                message: "Study for Midterm Exam is high priority",
                time: "Today, 02:30 pm",
                icon: Icons.notifications_outlined,
                hasBlueDot: false
            ),
            SizedBox(height: 16),
             _buildNotificationItem(
                title: "Alert",
                message: "Study for Midterm Exam is high priority",
                time: "Today, 02:30 pm",
                icon: Icons.notifications_none,
                hasBlueDot: true
            ),
            SizedBox(height: 16),
            _buildNotificationItem(
                title: "Great job!",
                message: "You completed \"Complete SRS Document\"",
                time: "Today, 02:30 pm",
                icon: Icons.notifications_active_outlined, // closest match
                hasBlueDot: true
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildFakeNavBar(), // Static for visual match
    );
  }

  Widget _buildNotificationItem({required String title, required String message, required String time, required IconData icon, required bool hasBlueDot}) {
      return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade100),
              boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: Offset(0, 4))
              ]
          ),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   Stack(
                       children: [
                           Icon(icon, size: 28, color: AppColors.textDark),
                           if (hasBlueDot)
                            Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                    width: 8, height: 8, 
                                    decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)
                                ),
                            )
                       ],
                   ),
                   SizedBox(width: 16),
                   Expanded(
                       child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                               Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                       Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                                       Text(time, style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                                   ]
                               ),
                               SizedBox(height: 4),
                               Text(message, style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                           ],
                       ),
                   )
              ],
          ),
      );
  }
  
  // Just a visual representation since this isn't the EntryPoint
  Widget _buildFakeNavBar() {
      // In a real app we'd navigate back or use EntryPoint, but user wants screen specific match. 
      // We will likely navigate to this screen pushing it on top, so no nav bar is technically needed, 
      // but the screenshot shows one.
      // For now, let's leave it empty or return SizedBox if we are pushing on top of EntryPoint.
      // Screenshot shows Nav Bar, implying this might be a tab or overlay.
      // We'll trust the user flow: bell click -> Notification Screen. 
      // Often this hides bottom bar. I will omit it for now to avoid confusion unless explicitly asked to fake it.
      return SizedBox();
  }
}
