import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/task.dart';
import 'package:url_launcher/url_launcher.dart';
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
    if (MediaQuery.of(context).size.width > 600) {
      return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.white.withOpacity(0.9), width: 3)),
        elevation: 0,
        color: Colors.white.withOpacity(0.2),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    widget.task.done
                        ? IconButton(
                            icon: Icon(Icons.check_circle_outline),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(
                                      "눌러서 이미지 다운로드 - 다운로드 후 .png 확장자로 저장"),
                                  content: InkWell(
                                    child: Text(
                                      "${widget.task.imageUrl}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap: () async {
                                      Uri _url =
                                          Uri.parse(widget.task.imageUrl);
                                      if (await launchUrl(_url)) {
                                        // await launchUrl(_url);
                                      } else {
                                        throw 'Could not launch $_url';
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        : Icon(
                            Icons.cancel_outlined,
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        if ((widget.currentDate
                                        .difference(DateTime.now())
                                        .inHours /
                                    24)
                                .round() <
                            -1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("에러"),
                              content: Text("기한이 지난 과제는 수정할 수 없습니다."),
                            ),
                          );
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
                      icon: Icon(Icons.delete_outline_outlined),
                      onPressed: () {
                        if ((widget.currentDate
                                        .difference(DateTime.now())
                                        .inHours /
                                    24)
                                .round() <
                            -1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("에러"),
                              content: Text("기한이 지난 과제는 삭제할 수 없습니다."),
                            ),
                          );
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("경고"),
                            content: Text("정말로 삭제하시겠습니까?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("취소"),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.deleteTask();
                                  Navigator.of(context).pop();
                                },
                                child: Text("삭제"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.upload_file),
                      onPressed: () async {
                        if ((widget.currentDate
                                        .difference(DateTime.now())
                                        .inHours /
                                    24)
                                .round() <
                            -1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("에러"),
                              content: Text("기한이 지난 과제는 완료할 수 없습니다."),
                            ),
                          );
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
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.white.withOpacity(0.9), width: 3)),
        elevation: 0,
        color: Colors.white.withOpacity(0.2),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    widget.task.done
                        ? IconButton(
                            icon: Icon(Icons.check_circle_outline),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: Text(
                                      "눌러서 이미지 다운로드 - 다운로드 후 .png 확장자로 저장"),
                                  content: InkWell(
                                    child: Text(
                                      "${widget.task.imageUrl}",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onTap: () async {
                                      Uri _url =
                                          Uri.parse(widget.task.imageUrl);
                                      if (await launchUrl(_url)) {
                                        // await launchUrl(_url);
                                      } else {
                                        throw 'Could not launch $_url';
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                          )
                        : Icon(
                            Icons.cancel_outlined,
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.task.title,
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          widget.task.numberOfQuestions.toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        if ((widget.currentDate
                                        .difference(DateTime.now())
                                        .inHours /
                                    24)
                                .round() <
                            -1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("에러"),
                              content: Text("기한이 지난 과제는 수정할 수 없습니다."),
                            ),
                          );
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
                      icon: Icon(Icons.delete_outline_outlined),
                      onPressed: () {
                        if ((widget.currentDate
                                        .difference(DateTime.now())
                                        .inHours /
                                    24)
                                .round() <
                            -1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("에러"),
                              content: Text("기한이 지난 과제는 삭제할 수 없습니다."),
                            ),
                          );
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("경고"),
                            content: Text("정말로 삭제하시겠습니까?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("취소"),
                              ),
                              TextButton(
                                onPressed: () {
                                  widget.deleteTask();
                                  Navigator.of(context).pop();
                                },
                                child: Text("삭제"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.upload_file),
                      onPressed: () async {
                        if ((widget.currentDate
                                        .difference(DateTime.now())
                                        .inHours /
                                    24)
                                .round() <
                            -1) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text("에러"),
                              content: Text("기한이 지난 과제는 완료할 수 없습니다."),
                            ),
                          );
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
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

//       title: Text(widget.task.title),
//       subtitle: Text(widget.task.numberOfQuestions.toString()),
//       trailing: Row(
//         children: [
//           IconButton(
//             icon(: Icon(Icons.edit),
//             onPressed: () {
//               if (widget.cuHinHours / 24).round()tDate.difference(DateTime.now()).inDays < 0) {
//                 ret-1rn;
//               }
//               widget.updateTask(widget.task);
//             },
//           ),
//           IconButton(
//             icon(: Icon(Icons.delete),
//             onPressed: () {
//               if (widget.cuHinHours / 24).round()tDate.difference(DateTime.now()).inDays < 0) {
//                 ret-1rn;
//               }
//               widget.deleteTask(widget.task);
//             },
//           ),
//           IconButton(
//             icon(: Icon(Icons.upload_file),
//             onPressed: () {
//               if (widget.cuHinHours / 24).round()tDate.difference(DateTime.now()).inDays < 0) {
//                 ret-1rn;
//               }
//               widget.uploadImage(widget.task);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
