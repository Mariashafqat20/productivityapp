import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'entry_point.dart';
import '../../widgets/task_card.dart';
import '../notifications/notifications_screen.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final filteredTasks = taskProvider.tasks;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tasks', style: AppTextStyles.heading2),
            SizedBox(height: 4),
            Text('Manage your academic courses Task', style: TextStyle(fontSize: 14, color: AppColors.textLight, fontWeight: FontWeight.normal)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.tune, color: AppColors.textDark), onPressed: () {}), 
          IconButton(
            icon: Icon(Icons.notifications_none, color: AppColors.textDark), 
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsScreen()))
          ),
        ],
      ),
      body: Column(
        children: [
          // Removed Priority Filter
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                  return TaskCard(
                    task: filteredTasks[index],
                    onEdit: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => AddTaskModal(taskToEdit: filteredTasks[index]),
                        );
                    },
                    onDelete: () {
                        taskProvider.deleteTask(filteredTasks[index].id!);
                    },
                  );
              },
            ),
          ),
        ],
      ),
    );
  }
}
