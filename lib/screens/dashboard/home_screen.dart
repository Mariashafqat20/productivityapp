import 'dart:io'; // Required for FileImage
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../providers/task_provider.dart';
import '../../models/task.dart';
import '../../widgets/task_card.dart';
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
  bool _showPlanned = true;

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
                  border: Border.all(color: Colors.white, width: 2.w),
                ),
                // FIXED: Now properly listens to UserProvider for updates
                child: Consumer<UserProvider>(
                    builder: (context, user, child) {
                      ImageProvider? imageProvider;

                      if (user.profilePicPath != null && user.profilePicPath!.isNotEmpty) {
                        File imgFile = File(user.profilePicPath!);
                        if (imgFile.existsSync()) {
                          imageProvider = FileImage(imgFile);
                        }
                      }

                      // Note: If you don't have 'assets/images/profile.jpg', this fallback helps avoid crashes
                      if (imageProvider == null) {
                        try {
                          imageProvider = AssetImage("assets/images/profile.jpg");
                        } catch (e) {
                          imageProvider = null;
                        }
                      }

                      return CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: imageProvider,
                        onBackgroundImageError: (_, __) {
                          // If image fails to load, just show the child icon
                        },
                        // Show Person Icon if no image is available
                        child: imageProvider == null
                            ? Icon(Icons.person, color: Colors.grey, size: 24.sp)
                            : null,
                      );
                    }
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<UserProvider>(
                      builder: (context, user, child) {
                        return Text('Hi ${user.name}!', style: AppTextStyles.heading2.copyWith(fontSize: 18.sp), overflow: TextOverflow.ellipsis);
                      }
                  ),
                  Text("Let's make today productive!", style: AppTextStyles.bodyMedium.copyWith(fontSize: 12.sp), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(icon: Icon(Icons.notifications_none, color: AppColors.textDark, size: 24.sp), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
            }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Overview Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 16.r, offset: Offset(0, 8.h))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today's Overview", style: AppTextStyles.heading3.copyWith(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.normal)),
                      Icon(Icons.star, color: Colors.white, size: 24.sp),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today tasks", style: AppTextStyles.heading2.copyWith(color: Colors.white, fontSize: 20.sp)),
                      Text("$completedStats / $totalStats", style: AppTextStyles.heading2.copyWith(color: Colors.white, fontSize: 20.sp)),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: totalStats == 0 ? 0 : completedStats / totalStats,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 8.h,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text("Keep going! You're doing great", style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withOpacity(0.9), fontSize: 12.sp)),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Today's Schedule Header & Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Today's Schedule", style: AppTextStyles.heading3.copyWith(fontSize: 16.sp)),
                SizedBox(width: 8.w),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: () => setState(() => _showPlanned = true),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: _showPlanned ? AppColors.primary : Colors.transparent,
                                      borderRadius: BorderRadius.circular(7.r),
                                    ),
                                    child: Text(
                                      "Planned",
                                      style: TextStyle(fontSize: 11.sp, color: _showPlanned ? Colors.white : AppColors.textDark),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: GestureDetector(
                                  onTap: () => setState(() => _showPlanned = false),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                    decoration: BoxDecoration(
                                      color: !_showPlanned ? AppColors.primary : Colors.transparent,
                                      borderRadius: BorderRadius.circular(7.r),
                                    ),
                                    child: Text(
                                      "Completed",
                                      style: TextStyle(fontSize: 11.sp, color: !_showPlanned ? Colors.white : AppColors.textDark),
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
            SizedBox(height: 20.h),

            if (displayTasks.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0.r),
                  child: Text(
                    _showPlanned ? "No planned tasks" : "No completed tasks",
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight, fontSize: 14.sp),
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
                  Padding(padding: EdgeInsets.symmetric(vertical: 8.h), child: Divider(height: 1.h, color: Colors.grey[200])),
                ],
              )).toList(),

            SizedBox(height: 24.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Upcoming tasks", style: AppTextStyles.heading3.copyWith(fontSize: 16.sp)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => TasksScreen()));
                  },
                  child: Text("View all", style: AppTextStyles.bodyMedium.copyWith(fontSize: 12.sp, color: AppColors.primary)),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (upcomingTasks.isEmpty)
              Center(child: Padding(padding: EdgeInsets.all(16.r), child: Text("No upcoming tasks", style: TextStyle(color: AppColors.textLight, fontSize: 14.sp))))
            else
              ...upcomingTasks.map((task) => Padding(
                padding: EdgeInsets.only(bottom: 12.0.h),
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
        padding: EdgeInsets.symmetric(vertical: 12.h),
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4.0.h),
              child: task != null && task.isCompleted == 1
                  ? Icon(Icons.check_circle, color: AppColors.primary, size: 20.sp)
                  : Icon(Icons.radio_button_unchecked, color: AppColors.primary, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(time, style: TextStyle(fontSize: 12.sp, color: AppColors.textLight)),
                  SizedBox(height: 4.h),
                  Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 16.sp, color: Colors.black87)),
                  SizedBox(height: 4.h),
                  Text(subTitle, style: TextStyle(fontSize: 12.sp, color: AppColors.textLight)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(color: tagBg, borderRadius: BorderRadius.circular(12.r)),
              child: Row(
                children: [
                  if (tagText == "High") Icon(Icons.local_fire_department, size: 12.sp, color: tagColor),
                  if (tagText == "High") SizedBox(width: 4.w),
                  Text(tagText, style: TextStyle(color: tagColor, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}