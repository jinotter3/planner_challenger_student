import 'subject.dart';

class Task {
  final String id;
  final String title;
  final Subject subject;
  final int numberOfQuestions;
  final bool done;

  Task({
    required this.id,
    required this.title,
    required this.subject,
    required this.numberOfQuestions,
    required this.done,
  });

  static fromJson(Map e) {
    return Task(
      id: e['id'],
      title: e['title'],
      subject: Subject.fromJson(e['subject']),
      numberOfQuestions: e['numberOfQuestions'],
      done: e['done'],
    );
  }
}
