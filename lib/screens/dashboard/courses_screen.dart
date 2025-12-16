import 'package:flutter/material.dart';
import '../../core/constants.dart';
import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../providers/course_provider.dart';
import '../notifications/notifications_screen.dart';
import 'entry_point.dart';

class CoursesScreen extends StatelessWidget {
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
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Icon(Icons.person, color: AppColors.primary),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: AppColors.textDark),
            onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Courses', style: AppTextStyles.heading1.copyWith(fontSize: 28)),
                SizedBox(height: 4),
                Text('Manage your academic courses', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight)),
              ],
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: Consumer<CourseProvider>(
              builder: (context, provider, child) {
                if (provider.courses.isEmpty) {
                   return Center(child: Text("No courses added yet."));
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: provider.courses.length,
                  itemBuilder: (context, index) {
                    final course = provider.courses[index];
                    return Padding( // Add padding between items
                        padding: EdgeInsets.only(bottom: 16),
                        child: _buildCourseCard(context, course)
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
             color: Colors.black.withOpacity(0.03),
             blurRadius: 15,
             offset: Offset(0, 5),
          )
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Course code : ${course.code}', style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => Container(
                             height: MediaQuery.of(context).size.height * 0.9,
                             decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                             ),
                             child: AddCourseModal(courseToEdit: course)
                          ),
                        );
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(0xFFE8F0FE), // Light blue bg
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                        // Confirm Dialog? For speed just delete.
                        Provider.of<CourseProvider>(context, listen: false).deleteCourse(course.id!);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(0xFFFFEBEE), // Light red bg
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.delete_outline, size: 18, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(course.name, style: AppTextStyles.heading3.copyWith(fontSize: 16)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: AppColors.textLight),
              SizedBox(width: 4),
              Text(course.instructor, style: TextStyle(fontSize: 12, color: AppColors.textLight)),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Added : Today', style: TextStyle(fontSize: 11, color: AppColors.textLight)), // Logic for date?
              Text('Task include : 0', style: TextStyle(fontSize: 12, color: AppColors.textLight)), // Logic for count?
            ],
          ),
        ],
      ),
    );
  }
}
