import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ImagePickerHelper {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return null;

      final String fileName = 'journal_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      if (kIsWeb) {
        // Web: use putData with bytes
        final Uint8List fileData = await pickedFile.readAsBytes();
        await storageRef.putData(fileData);
      } else {
        // Mobile/Desktop: use putFile
        final File file = File(pickedFile.path);
        await storageRef.putFile(file);
      }

      return await storageRef.getDownloadURL();
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }
}