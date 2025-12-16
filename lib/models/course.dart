class Course {
  final int? id;
  final String name;
  final String code;
  final String instructor;
  final String colorHex; // Store color as hex string

  Course({
    this.id,
    required this.name,
    required this.code,
    required this.instructor,
    this.colorHex = 'FF4361EE',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'instructor': instructor,
      'colorHex': colorHex,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      instructor: map['instructor'],
      colorHex: map['colorHex'] ?? 'FF4361EE',
    );
  }
}
