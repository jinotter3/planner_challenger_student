import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateCard extends StatelessWidget {
  final DateTime date;
  final DateTime today = DateTime.now();
  DateCard({required this.date});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > 600) {
      return Card(
        elevation: 0,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                DateFormat('EEEE, MMMM d, y').format(date),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                (date.difference(today).inHours / 24).round() == 0
                    ? 'Today'
                    : (date.difference(today).inHours / 24).round() == 1
                        ? 'Tomorrow'
                        : (date.difference(today).inHours / 24).round() == -1
                            ? 'Yesterday'
                            : '',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        elevation: 0,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                DateFormat('EEEE, MMMM d, y').format(date),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                (date.difference(today).inHours / 24).round() == 0
                    ? 'Today'
                    : (date.difference(today).inHours / 24).round() == 1
                        ? 'Tomorrow'
                        : (date.difference(today).inHours / 24).round() == -1
                            ? 'Yesterday'
                            : '',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      );
    }
  }
}
