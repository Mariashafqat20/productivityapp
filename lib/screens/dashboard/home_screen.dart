import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/task_provider.dart';
import '../../models/task.dart';

import '../../widgets/task_card.dart'; // We need this widget
import '../../widgets/dashboard_course_card.dart';
import 'tasks_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showPlanned = true; // true = Planned, false = Completed

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TaskProvider>(context, listen: false).loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final displayTasks = _showPlanned 
        ? taskProvider.tasks.where((t) => t.isCompleted == 0).toList()
        : taskProvider.tasks.where((t) => t.isCompleted == 1).toList();
        
    final totalStats = taskProvider.tasks.length;
    final completedStats = taskProvider.tasks.where((t) => t.isCompleted == 1).length;
    
    // Logic for upcoming tasks (Start date > today)
    // Simplified: Just take tasks not in today's view or explicitly future. 
    // Assuming 'date' is YYYY-MM-DD.
    final today = DateTime.now().toString().split(' ')[0];
    final upcomingTasks = taskProvider.tasks.where((t) => t.date.compareTo(today) > 0).take(3).toList();

    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  radius: 20, 
                  backgroundColor: Colors.grey[200], 
                  backgroundImage: AssetImage("assets/images/profile.jpg"), // Placeholder or handle error
                  onBackgroundImageError: (_, __) {},
                  child: Icon(Icons.person, color: Colors.grey),
                ), 
              ),
            ),
            SizedBox(width: 12),
            Expanded( // Fix for potential overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Consumer<UserProvider>(
                     builder: (context, user, child) {
                       return Text('Hi ${user.name}!', style: AppTextStyles.heading2.copyWith(fontSize: 18), overflow: TextOverflow.ellipsis);
                     }
                   ),
                   Text("Let's make today productive!", style: AppTextStyles.bodyMedium.copyWith(fontSize: 12), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
        actions: [
           Container(
             margin: EdgeInsets.only(right: 16),
             decoration: BoxDecoration(
               color: Colors.white,
               shape: BoxShape.circle, 
             ),
             child: IconButton(icon: Icon(Icons.notifications_none, color: AppColors.textDark), onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
             }),
           ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Overview Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 16, offset: Offset(0, 8))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today's Overview", style: AppTextStyles.heading3.copyWith(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal)),
                      Icon(Icons.star, color: Colors.white, size: 24),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text("Today tasks", style: AppTextStyles.heading2.copyWith(color: Colors.white, fontSize: 20)),
                       Text("$completedStats / $totalStats", style: AppTextStyles.heading2.copyWith(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                  SizedBox(height: 12),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: totalStats == 0 ? 0 : completedStats / totalStats,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 8,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text("Keep going! You're doing great", style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.9), fontSize: 12)),
                ],
              ),
            ),
            
            SizedBox(height: 32),
            
            // Today's Schedule Header & Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text("Today's Schedule", style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                 SizedBox(width: 8), // Gap
                 Flexible( // Allow shrinking
                   child: Container(
                     decoration: BoxDecoration(
                       border: Border.all(color: AppColors.primary),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: LayoutBuilder( // Responsive check if needed, or just shrink wrap
                       builder: (context, constraints) {
                         return Row(
                           mainAxisSize: MainAxisSize.min, 
                           children: [
                             Flexible( // Button 1
                               child: GestureDetector(
                                 onTap: () => setState(() => _showPlanned = true),
                                 child: Container(
                                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Reduced padding
                                   decoration: BoxDecoration(
                                     color: _showPlanned ? AppColors.primary : Colors.transparent,
                                     borderRadius: BorderRadius.circular(7),
                                   ),
                                   child: Text(
                                     "Planned", 
                                     style: TextStyle(fontSize: 11, color: _showPlanned ? Colors.white : AppColors.textDark), // smaller font
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                 ),
                               ),
                             ),
                             Flexible( // Button 2
                               child: GestureDetector(
                                 onTap: () => setState(() => _showPlanned = false),
                                 child: Container(
                                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Reduced padding
                                   decoration: BoxDecoration(
                                     color: !_showPlanned ? AppColors.primary : Colors.transparent,
                                     borderRadius: BorderRadius.circular(7),
                                   ),
                                   child: Text(
                                     "Completed", 
                                     style: TextStyle(fontSize: 11, color: !_showPlanned ? Colors.white : AppColors.textDark), // smaller font
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         );
                       }
                     ),
                   ),
                 )
              ],
            ),
            SizedBox(height: 20),

            // Schedule Items - Show based on filter
            if (displayTasks.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    _showPlanned ? "No planned tasks" : "No completed tasks",
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
                  ),
                ),
              )
            else
              ...displayTasks.map((task) => Column(
                children: [
                  _buildExactMatchScheduleItem(
                    task,
                    "${task.startTime} - ${task.endTime}",
                    task.title,
                    "Course : ${task.course ?? 'General'}",
                    task.priority >= 7 ? Color(0xFFFFD6D6) : task.priority >= 4 ? Color(0xFFFFF4D6) : Color(0xFFD6FFE3),
                    task.priority >= 7 ? Color(0xFFFF5252) : task.priority >= 4 ? Color(0xFFFFB800) : Color(0xFF00C853),
                    task.priority >= 7 ? "High" : task.priority >= 4 ? "Medium" : "Low",
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1, color: Colors.grey[200])),
                ],
              )).toList(),
             
             SizedBox(height: 24),
             
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text("Upcoming tasks", style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                 GestureDetector(
                   onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (_) => TasksScreen()));
                   },
                   child: Text("View all", style: AppTextStyles.bodyMedium.copyWith(fontSize: 12, color: AppColors.primary)),
                 ),
               ],
             ),
             SizedBox(height: 16),
             if (upcomingTasks.isEmpty)
                Center(child: Padding(padding: EdgeInsets.all(16), child: Text("No upcoming tasks", style: TextStyle(color: AppColors.textLight))))
             else
                ...upcomingTasks.map((task) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildExactMatchScheduleItem(
                    task,
                    "${task.date} | ${task.startTime} - ${task.endTime}",
                    task.title,
                    "Course : ${task.course ?? 'General'}",
                    task.priority >= 7 ? Color(0xFFFFD6D6) : task.priority >= 4 ? Color(0xFFFFF4D6) : Color(0xFFD6FFE3),
                    task.priority >= 7 ? Color(0xFFFF5252) : task.priority >= 4 ? Color(0xFFFFB800) : Color(0xFF00C853),
                    task.priority >= 7 ? "High" : task.priority >= 4 ? "Medium" : "Low",
                    isUpcoming: true
                  ),
                )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildExactMatchScheduleItem(Task? task, String time, String title, String subTitle, Color tagBg, Color tagColor, String tagText, {bool isUpcoming = false}) {
    return GestureDetector(
      onTap: () {
         if (task != null) {
           Provider.of<TaskProvider>(context, listen: false).toggleTaskStatus(task);
         }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        color: Colors.transparent, // For hit testing
        child: Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Padding(
               padding: const EdgeInsets.only(top: 4.0),
               child: task != null && task.isCompleted == 1 
                   ? Icon(Icons.check_circle, color: AppColors.primary, size: 20)
                   : Icon(Icons.radio_button_unchecked, color: AppColors.primary, size: 20),
             ),
             SizedBox(width: 16),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(time, style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                   SizedBox(height: 4),
                   Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 16, color: Colors.black87)),
                   SizedBox(height: 4),
                   Text(subTitle, style: TextStyle(fontSize: 12, color: AppColors.textLight)),
                 ],
               ),
             ),
             Container(
               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
               decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(12)),
               child: Row(
                 children: [
                   if (tagText == "High") Icon(Icons.local_fire_department, size: 12, color: tagColor),
                   if (tagText == "High") SizedBox(width: 4),
                   Text(tagText, style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold)),
                 ],
               ),
             )
           ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(String avatarUrl) {
    // avatarUrl is ignored now to prevent CORS, using random-ish or static icons
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF6383FA), // Light blue variant
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(0),
        ),
        boxShadow: [BoxShadow(color: Color(0xFF6383FA).withOpacity(0.3), blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16, 
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Container(width: 60, height: 6, decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(3))),
               SizedBox(height: 6),
               Container(width: 40, height: 6, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(3))),
             ],
          )
        ],
      ),
    );
  }
}
