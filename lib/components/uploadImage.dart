import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;
Future<String> uploadImage(File image, String category) async {
  String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  Reference storageRef = _storage.ref().child('${category}').child(fileName);
  UploadTask uploadTask = storageRef.putFile(image);
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}

Future<File?> pickerImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    print('No image selected.');
    return null;
  }
}

Future<void> deleteFileFromUrl(String downloadUrl) async {
  try {
    // Extract the file path from the download URL
    String filePath = Uri.decodeFull(downloadUrl.split('o/')[1].split('?')[0]);

    // Create a reference to the file to be deleted
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(filePath);

    // Delete the file
    await ref.delete();

    print('File deleted successfully');
  } catch (e) {
    print('Error occurred while deleting file: $e');
  }
}
