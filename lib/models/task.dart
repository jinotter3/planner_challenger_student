class Task {
  final String id;
  final String title;
  final String subject;
  final int numberOfQuestions;
  final bool done;
  final String imageUrl;

  Task({
    required this.id,
    required this.title,
    required this.subject,
    required this.numberOfQuestions,
    required this.done,
    required this.imageUrl,
  });

  factory Task.fromJson(Map<String, dynamic> json, String key) {
    Task task = Task(
      id: key,
      title: json['content'],
      subject: json['subject'],
      numberOfQuestions: int.parse(json['numOfQuestions']),
      done: json['done'],
      imageUrl: json['imageUrl'],
    );
    return task;
  }

  Map<String, dynamic> toJson() {
    return {
      'content': title,
      'subject': subject,
      'numOfQuestions': numberOfQuestions,
      'done': done,
      'imageUrl': imageUrl,
    };
  }
}
