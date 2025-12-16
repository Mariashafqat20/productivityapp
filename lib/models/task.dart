class Task {
  final int? id;
  final String title;
  final String description;
  final String date; // YYYY-MM-DD
  final String startTime; // HH:mm
  final String endTime; // HH:mm
  final int priority; // 1-10
  final int isCompleted; // 0 or 1
  final String? course;

  Task({
    this.id,
    required this.title,
    this.description = '',
    required this.date,
    required this.startTime,
    required this.endTime,
    this.priority = 1,
    this.isCompleted = 0,
    this.course,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'priority': priority,
      'isCompleted': isCompleted,
      'course': course,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      priority: map['priority'],
      isCompleted: map['isCompleted'],
      course: map['course'],
    );
  }
}
