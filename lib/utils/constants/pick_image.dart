import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static Future<List<File>> getImages() async {
    final pickedFiles =  await _picker.pickMultiImage(imageQuality: 100);
     if (pickedFiles.isNotEmpty) {
       return pickedFiles.map((xFile) => File(xFile.path)).toList();
     }
     return [];
  }
}