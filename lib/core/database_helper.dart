import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/course.dart';
import '../models/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('planner.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 3, onCreate: _createDB, onUpgrade: _onUpgrade);
  }
  
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
      if (oldVersion < 2) {
          await db.execute("DROP TABLE IF EXISTS tasks");
          await _createTaskTableV2(db);
      }
      if (oldVersion < 3) {
        await _seedDatabase(db);
      }
  }
  
  Future _createTaskTableV2(Database db) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    
    await db.execute('''
CREATE TABLE tasks ( 
  id $idType, 
  title $textType,
  description TEXT,
  date $textType,
  startTime $textType,
  endTime $textType,
  priority $intType,
  isCompleted $intType,
  course TEXT
  )
''');
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const intTypeNullable = 'INTEGER';

    await db.execute('''
CREATE TABLE courses ( 
  id $idType, 
  name $textType,
  code $textType,
  instructor $textType,
  colorHex $textType
  )
''');

    await _createTaskTableV2(db);
    await _seedDatabase(db);
  }

  Future _seedDatabase(Database db) async {
    // Seed Courses
    await db.insert('courses', {'name': 'Intro to CS', 'code': 'CS-101', 'instructor': 'Dr. smith', 'colorHex': '0xFF4361EE'});
    await db.insert('courses', {'name': 'Software Eng', 'code': 'SE-301', 'instructor': 'Prof. Doe', 'colorHex': '0xFF3F37C9'});
    await db.insert('courses', {'name': 'Mathematics', 'code': 'MATH-202', 'instructor': 'Mrs. Jane', 'colorHex': '0xFF4895EF'});
    
    // Seed Tasks
    final today = DateTime.now().toIso8601String().split('T')[0];
    await db.insert('tasks', {
      'title': 'Project Setup',
      'description': 'Initialize repo and structure',
      'date': today,
      'startTime': '09:00 AM',
      'endTime': '10:00 AM',
      'priority': 7,
      'isCompleted': 0,
      'course': 'Software Eng'
    });
    
     await db.insert('tasks', {
      'title': 'Calculus Quiz',
      'description': 'Chapter 5',
      'date': today,
      'startTime': '11:00 AM',
      'endTime': '12:00 PM',
      'priority': 4,
      'isCompleted': 0,
       'course': 'Mathematics'
    });
  }

  Future<int> createCourse(Course course) async {
    final db = await instance.database;
    return await db.insert('courses', course.toMap());
  }

  Future<Course> readCourse(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'courses',
      columns: ['id', 'name', 'code', 'instructor', 'colorHex'],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Course.fromMap(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Course>> readAllCourses() async {
    final db = await instance.database;
    final result = await db.query('courses');
    return result.map((json) => Course.fromMap(json)).toList();
  }

  Future<int> updateCourse(Course course) async {
    final db = await instance.database;
    return db.update(
      'courses',
      course.toMap(),
      where: 'id = ?',
      whereArgs: [course.id],
    );
  }

  Future<int> deleteCourse(int id) async {
    final db = await instance.database;
    return await db.delete(
      'courses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> createTask(Task task) async {
    final db = await instance.database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    final result = await db.query('tasks', orderBy: 'date ASC, startTime ASC');
    return result.map((json) => Task.fromMap(json)).toList();
  }
  
  Future<List<Task>> readTasksByDate(String date) async {
    final db = await instance.database;
    final result = await db.query('tasks', where: 'date = ?', whereArgs: [date], orderBy: 'startTime ASC');
    return result.map((json) => Task.fromMap(json)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
