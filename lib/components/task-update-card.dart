import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskUpdateCard extends StatelessWidget {
  TaskUpdateCard({super.key, required this.task, required this.updateTask});
  final Task task;
  final Function updateTask;
  late final TextEditingController _subjectController =
      TextEditingController(text: task.subject);
  late final TextEditingController _contentController =
      TextEditingController(text: task.title);
  late final TextEditingController _numOfQuestionsController =
      TextEditingController(text: task.numberOfQuestions.toString());
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Task 수정"),
      content: Column(
        children: [
          TextField(
            controller: _subjectController,
            decoration: const InputDecoration(
              labelText: "과목",
            ),
          ),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(
              labelText: "내용",
            ),
          ),
          TextField(
            controller: _numOfQuestionsController,
            decoration: const InputDecoration(
              labelText: "문항 수",
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("취소"),
        ),
        TextButton(
          onPressed: () async {
            // upload to firebase
            // students/uid/days/date/tasks
            // subject, content, numOfQuestions
            if (_subjectController.text.isEmpty ||
                _contentController.text.isEmpty ||
                _numOfQuestionsController.text.isEmpty) {
              return;
            }
            updateTask(
              Task(
                subject: _subjectController.text,
                title: _contentController.text,
                numberOfQuestions:
                    int.parse(_numOfQuestionsController.text.toString()),
                done: task.done,
                id: task.id,
                imageUrl: task.imageUrl,
              ).toJson(),
            );
            Navigator.pop(context);
          },
          child: const Text("바꾸기"),
        ),
      ],
    );
  }
}
