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
final _formKey = GlobalKey<FormState>();
isNum(String num){
  try{
    int.parse(num);
    return true;
  }catch(e){
    return false;
  }
}
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Task 수정"),
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _subjectController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '과목을 입력해주세요';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: "과목",
              ),
            ),
            TextFormField(
              controller: _contentController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '내용을 입력해주세요';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: "내용",
              ),
            ),
            TextFormField(
              controller: _numOfQuestionsController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '문항 수를 입력해주세요';
                }
                //is value is int
              else if(isNum(value) == false){
                return '문항 수는 숫자로 입력해주세요';
              }
                return null;
              },
              decoration: const InputDecoration(
                labelText: "문항 수",
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
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
            if (!_formKey.currentState!.validate()) return;
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
