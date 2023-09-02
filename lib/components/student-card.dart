import 'package:flutter/material.dart';

import '../models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  const StudentCard({required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Student Name: ${student.name}',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Student ID: ${student.studentId}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
