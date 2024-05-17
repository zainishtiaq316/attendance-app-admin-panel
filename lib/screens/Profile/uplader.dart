import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class UploaderService {
  final Reference _storageRef = FirebaseStorage.instance.ref("Files");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// [dir] is the directory on firebase storage bucket
  Future<UploadedFile> uploadFile(File file, String dir, FileType fileType,
      {Function(double)? onProgress}) async {
    UploadTask uploadTask;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String extension = p.extension(file.path);

    Reference ref = _storageRef
        .child(dir)
        .child(_auth.currentUser!.uid)
        .child('/$fileName.$extension');

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes());
    } else {
      uploadTask = ref.putFile(File(file.path));
    }

    final subscription = uploadTask.snapshotEvents.listen((event) {
      final progress =
          event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      if (onProgress != null) onProgress(progress);
    });

    final TaskSnapshot downloadUrl = (await uploadTask);

    final String url = await downloadUrl.ref.getDownloadURL();
    // print("downloadLinkURL: $url");

    subscription.cancel();

    return UploadedFile(downloadLink: url, fileType: fileType);
  }
}

class UploadedFile {
  final String downloadLink;
  final FileType fileType;

  UploadedFile({required this.downloadLink, required this.fileType});
}

enum FileType { Thumbnail, Image, Video, Audio }

class VideoUploaderService {
  final Reference _storageRef = FirebaseStorage.instance.ref("Files");
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// [dir] is the directory on firebase storage bucket
  Future<UploadedFile> uploadVideoFile(
      XFile xfile, String dir, FileType fileType,
      {Function(double)? onProgress}) async {
    UploadTask uploadTask;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    String extension = p.extension(xfile.path);

    Reference ref = _storageRef
        .child(dir)
        .child(_auth.currentUser!.uid)
        .child('/$fileName.$extension');

    if (kIsWeb) {
      uploadTask = ref.putData(await xfile.readAsBytes());
    } else {
      uploadTask = ref.putFile(File(xfile.path));
    }

    final subscription = uploadTask.snapshotEvents.listen((event) {
      final progress =
          event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
      if (onProgress != null) onProgress(progress);
    });

    final TaskSnapshot downloadUrl = (await uploadTask);

    final String url = await downloadUrl.ref.getDownloadURL();
    // print("downloadLinkURL: $url");

    subscription.cancel();

    return UploadedFile(downloadLink: url, fileType: fileType);
  }
}
