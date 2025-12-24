import 'package:flutter/material.dart';
import '../../core/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import '../../models/task.dart';
import '../../providers/task_provider.dart';
import 'home_screen.dart';
import 'tasks_screen.dart';
import 'calendar_screen.dart';
import 'courses_screen.dart';
import '../../models/course.dart';
import '../../providers/course_provider.dart';

class EntryPoint extends StatefulWidget {
  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  int _currentIndex = 0;
  bool _isFabMenuOpen = false; // Track FAB state

  final List<Widget> _screens = [
    HomeScreen(),
    CoursesScreen(),
    TasksScreen(),
    CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],

          // Dark Overlay when FAB is open
          if (_isFabMenuOpen)
            GestureDetector(
              onTap: () => setState(() => _isFabMenuOpen = false),
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
                width: double.infinity,
                height: double.infinity,
              ),
            ),

          // Floating Menu Buttons (Responsive Wrap)
          if (_isFabMenuOpen)
            Positioned(
              bottom: 120, // Position above the FAB
              left: 16,    // Ensure padding from edges
              right: 16,
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,    // Horizontal gap between buttons
                  runSpacing: 16, // Vertical gap if they wrap
                  children: [
                    _buildOverlayButton("Add Task", Icons.assignment_outlined, () {
                      setState(() => _isFabMenuOpen = false);
                      _showAddTaskModal(context);
                    }),
                    _buildOverlayButton("Add Course", Icons.class_outlined, () {
                      setState(() => _isFabMenuOpen = false);
                      _showAddCourseModal(context);
                    }),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            setState(() => _isFabMenuOpen = !_isFabMenuOpen);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Transform.rotate(
            angle: _isFabMenuOpen ? 0.785398 : 0, // Rotate 45 degrees when open
            child: Icon(Icons.add, size: 32, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10.0,
        height: 80,
        color: Colors.white,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(Icons.home_outlined, "Home", 0),
            _buildNavItem(Icons.sticky_note_2_outlined, "Courses", 1),
            SizedBox(width: 48), // Space for FAB
            _buildNavItem(Icons.assignment_outlined, "Tasks", 2),
            _buildNavItem(Icons.calendar_today_outlined, "Calendar", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 12, offset: Offset(0, 6))
            ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Shrink to fit content
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(width: 12),
            Flexible( // Ensure text handles small spaces gracefully
              child: Text(
                label,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textLight,
              size: 24,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppColors.primary : AppColors.textLight,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskModal(BuildContext context) {
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
          child: AddTaskModal()
      ),
    );
  }

  void _showAddCourseModal(BuildContext context) {
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
          child: AddCourseModal()
      ),
    );
  }
}

class AddTaskModal extends StatefulWidget {
  final Task? taskToEdit;

  AddTaskModal({this.taskToEdit});

  @override
  _AddTaskModalState createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: (TimeOfDay.now().hour + 1) % 24);
  String? _selectedCourse;
  String? _selectedRemind = "10 mint early";

  final List<String> _remindOptions = ["10 mint early", "30 mint early", "1 hour early", "1 day early"];

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      final t = widget.taskToEdit!;
      _titleController.text = t.title;
      _descriptionController.text = t.description;
      _selectedDate = DateTime.parse(t.date);
      _selectedCourse = t.course;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(icon: Icon(Icons.arrow_back_ios, size: 18), onPressed: () => Navigator.pop(context)),
            ],
          ),
          Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
                        ),
                        SizedBox(height: 20),
                        Center(child: Text(widget.taskToEdit == null ? "Add New Task" : "Edit Task", style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold))),
                        SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text("Fill in the details below to add a new task to your planner.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: AppColors.textLight)
                          ),
                        ),
                        SizedBox(height: 24),

                        Text("Task Title", style: AppTextStyles.bodyMedium),
                        SizedBox(height: 8),
                        CustomTextField(
                          hintText: "e.g., Complete SRS Document",
                          controller: _titleController,
                          validator: (v) => v!.isEmpty ? "Title is required" : null,
                        ),
                        SizedBox(height: 16),

                        Text("Course", style: AppTextStyles.bodyMedium),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(color: AppColors.neutral, borderRadius: BorderRadius.circular(12)),
                          child: Consumer<CourseProvider>(
                              builder: (context, provider, child) {
                                final courseNames = provider.courses.map((c) => c.name).toList();
                                if (_selectedCourse != null && !courseNames.contains(_selectedCourse)) {
                                  _selectedCourse = null;
                                }
                                return DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedCourse,
                                    hint: Text("Select a course", style: TextStyle(color: AppColors.textLight, fontSize: 14)),
                                    decoration: InputDecoration(border: InputBorder.none),
                                    icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
                                    items: courseNames.map((name) => DropdownMenuItem(value: name, child: Text(name, style: AppTextStyles.bodyMedium))).toList(),
                                    onChanged: (v) => setState(() => _selectedCourse = v),
                                  ),
                                );
                              }
                          ),
                        ),
                        SizedBox(height: 16),

                        Text("Date ( Day )", style: AppTextStyles.bodyMedium),
                        SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) setState(() => _selectedDate = picked);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(color: AppColors.neutral, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_selectedDate == null ? "Select Date" : "${_selectedDate.toLocal()}".split(' ')[0], style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textDark)),
                                Icon(Icons.calendar_today_outlined, color: AppColors.textLight, size: 20),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Start time", style: AppTextStyles.bodyMedium),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        final picked = await showTimePicker(context: context, initialTime: _startTime);
                                        if (picked != null) setState(() => _startTime = picked);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        decoration: BoxDecoration(color: AppColors.neutral, borderRadius: BorderRadius.circular(12)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(_startTime.format(context), style: TextStyle(color: AppColors.textDark, fontSize: 14)),
                                            Icon(Icons.access_time, color: AppColors.textLight, size: 18),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                            SizedBox(width: 16),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("End time", style: AppTextStyles.bodyMedium),
                                    SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        final picked = await showTimePicker(context: context, initialTime: _endTime);
                                        if (picked != null) setState(() => _endTime = picked);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        decoration: BoxDecoration(color: AppColors.neutral, borderRadius: BorderRadius.circular(12)),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(_endTime.format(context), style: TextStyle(color: AppColors.textDark, fontSize: 14)),
                                            Icon(Icons.access_time, color: AppColors.textLight, size: 18),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        Text("Remind", style: AppTextStyles.bodyMedium),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(color: AppColors.neutral, borderRadius: BorderRadius.circular(12)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              value: _selectedRemind,
                              decoration: InputDecoration(border: InputBorder.none),
                              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
                              items: _remindOptions.map((c) => DropdownMenuItem(value: c, child: Text(c, style: AppTextStyles.bodyMedium))).toList(),
                              onChanged: (v) => setState(() => _selectedRemind = v),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        Text("Description (Optional)", style: AppTextStyles.bodyMedium),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.neutral, borderRadius: BorderRadius.circular(12)),
                          child: TextFormField(
                            controller: _descriptionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add details about this task...",
                              hintStyle: TextStyle(color: AppColors.textLight, fontSize: 14),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text("100 Character", style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                          ),
                        ),

                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final task = Task(
                                    id: widget.taskToEdit?.id,
                                    title: _titleController.text,
                                    description: _descriptionController.text,
                                    date: "${_selectedDate.toLocal()}".split(' ')[0],
                                    startTime: _startTime.format(context),
                                    endTime: _endTime.format(context),
                                    priority: widget.taskToEdit?.priority ?? 1,
                                    isCompleted: widget.taskToEdit?.isCompleted ?? 0,
                                    course: _selectedCourse
                                );

                                // Handle Notifications based on Remind selection
                                int minutesEarly = 10;
                                if (_selectedRemind == "30 mint early") minutesEarly = 30;
                                if (_selectedRemind == "1 hour early") minutesEarly = 60;
                                if (_selectedRemind == "1 day early") minutesEarly = 1440;

                                if (widget.taskToEdit == null) {
                                  Provider.of<TaskProvider>(context, listen: false).addTask(task, minutesEarly: minutesEarly);
                                } else {
                                  Provider.of<TaskProvider>(context, listen: false).updateTask(task);
                                }
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: Text(widget.taskToEdit == null ? "Add Task" : "Update Task", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        )
                      ]
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}

class AddCourseModal extends StatefulWidget {
  final Course? courseToEdit;

  AddCourseModal({this.courseToEdit});

  @override
  _AddCourseModalState createState() => _AddCourseModalState();
}

class _AddCourseModalState extends State<AddCourseModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _instructorController = TextEditingController();

  final List<String> _colors = ['0xFF4361EE', '0xFF3F37C9', '0xFF4895EF', '0xFF4CC9F0', '0xFF7209B7', '0xFFF72585'];
  String _selectedColor = '0xFF4361EE';

  @override
  void initState() {
    super.initState();
    if (widget.courseToEdit != null) {
      _nameController.text = widget.courseToEdit!.name;
      _codeController.text = widget.courseToEdit!.code;
      _instructorController.text = widget.courseToEdit!.instructor;
      if (_colors.contains(widget.courseToEdit!.colorHex)) {
        _selectedColor = widget.courseToEdit!.colorHex;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(24).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(icon: Icon(Icons.arrow_back_ios, size: 18), onPressed: () => Navigator.pop(context)),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                      SizedBox(height: 20),
                      Center(child: Text(widget.courseToEdit == null ? "Add New Course" : "Edit Course", style: AppTextStyles.heading2.copyWith(fontWeight: FontWeight.bold))),
                      SizedBox(height: 24),

                      Text("Course Name", style: AppTextStyles.bodyMedium),
                      SizedBox(height: 8),
                      CustomTextField(
                        hintText: "e.g., Software Engineering",
                        controller: _nameController,
                        validator: (v) => v!.isEmpty ? "Name is required" : null,
                      ),
                      SizedBox(height: 16),

                      Text("Course Code", style: AppTextStyles.bodyMedium),
                      SizedBox(height: 8),
                      CustomTextField(
                        hintText: "e.g., SE-301",
                        controller: _codeController,
                        validator: (v) => v!.isEmpty ? "Code is required" : null,
                      ),
                      SizedBox(height: 16),

                      Text("Instructor Name", style: AppTextStyles.bodyMedium),
                      SizedBox(height: 8),
                      CustomTextField(
                        hintText: "e.g., Dr. Smith",
                        controller: _instructorController,
                        validator: (v) => v!.isEmpty ? "Instructor is required" : null,
                      ),
                      SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final course = Course(
                                id: widget.courseToEdit?.id,
                                name: _nameController.text,
                                code: _codeController.text,
                                instructor: _instructorController.text,
                                colorHex: _selectedColor,
                              );
                              if (widget.courseToEdit == null) {
                                Provider.of<CourseProvider>(context, listen: false).addCourse(course);
                              } else {
                                Provider.of<CourseProvider>(context, listen: false).updateCourse(course);
                              }
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: Text(widget.courseToEdit == null ? "Add Course" : "Update Course", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
    );
  }
}