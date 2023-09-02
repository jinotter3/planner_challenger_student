import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/task.dart';
import 'task-update-card.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    required this.task,
    required this.currentDate,
    required this.updateTask,
    required this.deleteTask,
    required this.uploadImage,
  });

  final Task task;
  final DateTime currentDate;
  final Function updateTask;
  final Function deleteTask;
  final Function uploadImage;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    widget.task.title,
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    widget.task.numberOfQuestions.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      if (widget.currentDate.difference(DateTime.now()).inDays <
                          0) {
                        return;
                      }
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TaskUpdateCard(
                              task: widget.task,
                              updateTask: (newTask) {
                                widget.updateTask(newTask);
                              },
                            );
                          });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      if (widget.currentDate.difference(DateTime.now()).inDays <
                          0) {
                        return;
                      }
                      widget.deleteTask();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.upload_file),
                    onPressed: () async {
                      if (widget.currentDate.difference(DateTime.now()).inDays <
                          0) {
                        return;
                      }
                      final ImagePicker picker = ImagePicker();
// Pick an image.
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxHeight: 2000,
                          maxWidth: 2000,
                          imageQuality: 50);
                      String path = image!.path;
                      Uint8List imageData = await XFile(path).readAsBytes();

                      widget.uploadImage(imageData);
                    },
                  ),
                  widget.task.done
                      ? Icon(
                          Icons.check_circle,
                        )
                      : Icon(
                          Icons.check_circle_outline,
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//       title: Text(widget.task.title),
//       subtitle: Text(widget.task.numberOfQuestions.toString()),
//       trailing: Row(
//         children: [
//           IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () {
//               if (widget.currentDate.difference(DateTime.now()).inDays < 0) {
//                 return;
//               }
//               widget.updateTask(widget.task);
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () {
//               if (widget.currentDate.difference(DateTime.now()).inDays < 0) {
//                 return;
//               }
//               widget.deleteTask(widget.task);
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.upload_file),
//             onPressed: () {
//               if (widget.currentDate.difference(DateTime.now()).inDays < 0) {
//                 return;
//               }
//               widget.uploadImage(widget.task);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
