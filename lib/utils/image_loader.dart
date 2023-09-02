import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class ImageLoader {
  final String refPath;
  late File localFile;
  ImageLoader({required this.refPath});

  Future<File> loadImage() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final filePath = "${appDocDir.absolute}/refPath.png";
    localFile = File(filePath);
    final storageRef = FirebaseStorage.instance.ref(refPath);
    final downloadTask = storageRef.writeToFile(localFile);
    downloadTask.asStream().listen((event) {
      print(event.bytesTransferred);
    });
    await downloadTask;
    return localFile;
  }
}
