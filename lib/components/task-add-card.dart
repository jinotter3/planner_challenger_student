import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskAddCard extends StatelessWidget {
  TaskAddCard({super.key, required this.date});

  final DateTime date;

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _numOfQuestionsController =
      TextEditingController();
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
      title: const Text("새 Task 추가"),
      content: SizedBox(
        height: 200,
        child: Form(
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
                  } else if (isNum(value) == false) {
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
            final DatabaseReference _dbRef = FirebaseDatabase.instance
                .ref("students/${FirebaseAuth.instance.currentUser!.uid}/days");
            final DatabaseReference _taskRef =
                _dbRef.child(date.toString().split(" ")[0]);
            // Append task to the list
            final task = {
              "subject": _subjectController.text,
              "content": _contentController.text,
              "numOfQuestions": _numOfQuestionsController.text,
              "done": false,
              "imageUrl": "",
            };
            _taskRef.push().set(task);
            Navigator.pop(context);
            GoRouter.of(context).refresh();
          },
          child: const Text("추가"),
        ),
      ],
    );
  }
}
