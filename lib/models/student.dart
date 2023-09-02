class Student {
  final String name;
  final String studentId;
  final String id;

  Student({
    required this.name,
    required this.studentId,
    required this.id,
  });

  bool isFirstTime() {
    return name == '' && studentId == '';
  }

  Student.fromJson(Map<dynamic, dynamic> json)
      : name = json['info']['name'] as String,
        studentId = json['info']['studentId'] as String,
        id = json['info']['id'] as String;
}
