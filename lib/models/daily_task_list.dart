import 'task.dart';

class DailyTaskList {
  final DateTime date;
  final List<Task> tasks;

  DailyTaskList({
    required this.date,
    required this.tasks,
  });

  factory DailyTaskList.fromJson(Map<String, dynamic> json, DateTime date) {
    List<Task> tasks = [];
    for (var key in json.keys) {
      tasks.add(Task.fromJson(json[key], key));
    }
    return DailyTaskList(
      date: date,
      tasks: tasks,
    );
  }

  Map<String, List<Task>> getTasksBySubject() {
    Map<String, List<Task>> tasksBySubject = {};
    for (var task in tasks) {
      if (tasksBySubject.containsKey(task.subject)) {
        tasksBySubject[task.subject]!.add(task);
      } else {
        tasksBySubject[task.subject] = [task];
      }
    }
    return tasksBySubject;
  }
}
