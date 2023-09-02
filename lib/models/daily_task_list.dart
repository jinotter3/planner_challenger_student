import 'task.dart';

class DailyTaskList {
  final String id;
  final DateTime date;
  final List<Task> tasks;

  DailyTaskList({
    required this.id,
    required this.date,
    required this.tasks,
  });

  DailyTaskList.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] as String,
        date = DateTime.parse(json['date'] as String),
        tasks = (json['tasks'] as List<dynamic>)
            .map((e) => Task.fromJson(e))
            .toList() as List<Task>;
}
