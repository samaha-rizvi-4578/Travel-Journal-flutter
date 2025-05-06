// lib/shared/utils/image_picker_helper.dart
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ImagePickerHelper {
  final picker = ImagePicker();

  Future<String?> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final storageRef = FirebaseStorage.instance.ref().child('journal_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(File(pickedFile.path));
      return await storageRef.getDownloadURL();
    }
    return null;
  }
}