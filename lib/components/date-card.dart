import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCard extends StatelessWidget {
  final DateTime date;
  final DateTime today = DateTime.now();
  DateCard({required this.date});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              DateFormat('EEEE, MMMM d, y').format(date),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              date.difference(today).inDays == 0
                  ? 'Today'
                  : date.difference(today).inDays == 1
                      ? 'Tomorrow'
                      : date.difference(today).inDays == -1
                          ? 'Yesterday'
                          : '',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
