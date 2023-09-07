import 'package:flutter/material.dart';

class StudentDoneDateCard extends StatelessWidget {
  StudentDoneDateCard({super.key, required this.student, required this.id});
  final Map student;
  final String id;

  @override
  Widget build(BuildContext context) {
    if (student['days'] == null) {
      return Card(
        child: SizedBox(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${student['info']['studentId']} ${student['info']['name']}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )),
        ),
      );
    } else {
      return Card(
        child: SizedBox(
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${student['info']['studentId']} ${student['info']['name']}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )),
        ),
      );
    }
  }
}
