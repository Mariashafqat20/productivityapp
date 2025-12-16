import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskCard({Key? key, required this.task, this.onEdit, this.onDelete, VoidCallback? onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color tagColor;
    Color tagBg;
    String tagText;

    if (task.priority >= 7) {
      tagColor = Color(0xFFFF5252);
      tagBg = Color(0xFFFFD6D6);
      tagText = "High";
    } else if (task.priority >= 4) {
      tagColor = Color(0xFFFFB800);
      tagBg = Color(0xFFFFF4D6);
      tagText = "Medium";
    } else {
      tagColor = Color(0xFF00C853);
      tagBg = Color(0xFFD6FFE3);
      tagText = "Low";
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "${task.date} | ${task.startTime} - ${task.endTime}",
                  style: TextStyle(fontSize: 12, color: AppColors.textLight),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Container(
                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          SizedBox(height: 8),
          Text(task.title, style: AppTextStyles.heading3),
          SizedBox(height: 4),
          Text("Course : ${task.course ?? 'General'}", style: TextStyle(fontSize: 12, color: AppColors.textLight)),
          SizedBox(height: 16),
          Divider(color: Colors.grey[200], height: 1), // Added divider
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: Icon(Icons.edit_outlined, size: 16, color: Color(0xFF5E81FF)),
                label: Text("Edit", style: TextStyle(color: Color(0xFF5E81FF), fontSize: 12)),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFFC8D6FF)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: Icon(Icons.delete_outline, size: 16, color: Color(0xFFFF8585)),
                label: Text("Delete", style: TextStyle(color: Color(0xFFFF8585), fontSize: 12)),
                style: OutlinedButton.styleFrom(
                   side: BorderSide(color: Color(0xFFFFD6D6)),
                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
