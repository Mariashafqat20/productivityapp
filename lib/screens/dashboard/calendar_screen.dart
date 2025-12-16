import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/constants.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _viewIndex = 0; // 0: monthly, 1: weekly, 2: daily
  int _scheduleFilterIndex = 0; // 0: Planned, 1: Completed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80, // Add more height/spacing
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen())),
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, color: Colors.white), // Profile Icon
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ // Clean Header, maybe remove subtitle if too cluttered? User requested "do not write the heading in too top add some apcing"
            Text('Calendar & Scheduler', style: AppTextStyles.heading2.copyWith(fontSize: 20)),
             Text('Manage your study sessions', style: TextStyle(fontSize: 12, color: AppColors.textLight, fontWeight: FontWeight.normal)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: AppColors.textDark),
             onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()));
             },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // View Toggles (Monthly, Weekly, Daily)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildViewToggle("monthly", 0),
                    Container(width: 1, height: 40, color: Colors.grey.shade300),
                    _buildViewToggle("weekly", 1),
                    Container(width: 1, height: 40, color: Colors.grey.shade300),
                    _buildViewToggle("daily", 2),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Calendar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                   // No shadow in image, just clean text
                ),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: AppTextStyles.heading3,
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    defaultTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark),
                    weekendTextStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textLight),
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),
              SizedBox(height: 24),
              
              // Today's Schedule Header & Filter
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text("Today's Schedule", style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                   Container(
                     decoration: BoxDecoration(
                       border: Border.all(color: AppColors.primary),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: Row(
                       children: [
                         _buildScheduleFilter("Planned", 0),
                         _buildScheduleFilter("Completed", 1),
                       ],
                     ),
                   ),
                 ],
               ),
              SizedBox(height: 20),
              
              // Schedule Items
              _buildScheduleItem("08:00 - 10:00 Pm", "Revise OOP Concepts", "Course : Programming", "High", Color(0xFFFFE0E0), Color(0xFFFF5252)),
              Divider(height: 24, color: Colors.grey[200]),
              _buildScheduleItem("08:00 - 10:00 Pm", "Revise OOP Concepts", "Course : Programming", "Medium", Color(0xFFFFF9C4), Color(0xFFFBC02D)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggle(String title, int index) {
    bool isSelected = _viewIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _viewIndex = index),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: index == 0 
                ? BorderRadius.horizontal(left: Radius.circular(11)) 
                : index == 2 ? BorderRadius.horizontal(right: Radius.circular(11)) : null,
          ),
          child: Text(title, style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textLight,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
          )),
        ),
      ),
    );
  }

  Widget _buildScheduleFilter(String title, int index) {
     bool isSelected = _scheduleFilterIndex == index;
     return GestureDetector(
       onTap: () => setState(() => _scheduleFilterIndex = index),
       child: Container(
         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
         decoration: BoxDecoration(
           color: isSelected ? AppColors.primary : Colors.transparent,
           borderRadius: BorderRadius.circular(7), // Slightly less than outer border
         ),
         child: Text(title, style: TextStyle(
           color: isSelected ? Colors.white : AppColors.textDark,
           fontSize: 12
         )),
       ),
     );
  }

  Widget _buildScheduleItem(String time, String title, String course, String priorityText, Color tagBg, Color tagText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Icon(Icons.check_circle, color: AppColors.primary, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(time, style: TextStyle(fontSize: 12, color: AppColors.textLight)),
              SizedBox(height: 4),
              Text(title, style: AppTextStyles.heading3.copyWith(fontSize: 16)),
              SizedBox(height: 4),
              Text(course, style: TextStyle(fontSize: 12, color: AppColors.textLight)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: tagBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (priorityText == "High") Icon(Icons.local_fire_department, size: 12, color: tagText),
              if (priorityText == "High") SizedBox(width: 4),
              Text(priorityText, style: TextStyle(fontSize: 10, color: tagText, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}
