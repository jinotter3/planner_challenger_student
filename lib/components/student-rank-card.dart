import 'package:flutter/material.dart';

class StudentRankCard extends StatelessWidget {
  StudentRankCard({super.key, required this.student});
  final Map student;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.white.withOpacity(0.9), width: 3)),
      elevation: 0,
      color: Colors.white.withOpacity(0.2),
      child: SizedBox(
        height: 50,
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
                Spacer(),
                Text(
                  '${student['info']['days']}일',
                  style: TextStyle(fontSize: 20),
                )
              ],
            )),
      ),
    );
  }
}
