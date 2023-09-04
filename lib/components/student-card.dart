import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  const StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).size.width > 600){
          return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              '이름: ${student.name}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '학번: ${student.studentId}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
    }
    else{
          return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              '이름: ${student.name}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '학번: ${student.studentId}',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
    }

  }
}
