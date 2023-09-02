import 'subject.dart';

enum TaskStatus {
  REMAINING,
  SUBMITTED,
  CONFIRMED,
}

class Task {
  final String id;
  final String title;
  final Subject subject;
  final int numberOfQuestions;
  final TaskStatus status;

  Task({
    required this.id,
    required this.title,
    required this.subject,
    required this.numberOfQuestions,
    required this.status,
  });

  static fromJson(Map e) {
    return Task(
      id: e['id'],
      title: e['title'],
      subject: Subject.fromJson(e['subject']),
      numberOfQuestions: e['numberOfQuestions'],
      status: TaskStatus.values[e['status']],
    );
  }
}
