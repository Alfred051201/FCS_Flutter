import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

Future<String> fileToBase64DataUri(File file) async {
  final bytes = await file.readAsBytes();
  final mimeType = 'image/png'; // Or detect if needed
  return 'data:$mimeType;base64,${base64Encode(bytes)}';
}

Future<XFile> dataUriToXFile(String dataUri) async {
  // Extract base64 string from the Data URI
  final splitData = dataUri.split(',');
  if (splitData.length != 2) {
    throw FormatException("Invalid data URI format");
  }

  final mimeMatch = RegExp(r'data:(.*?);base64').firstMatch(splitData[0]);
  final mimeType = mimeMatch?.group(1) ?? 'image/png';
  final extension = mimeType.split('/').last;

  // Decode base64
  final Uint8List bytes = base64Decode(splitData[1]);

  // Get temp directory and write file
  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/temp_image.$extension';
  final file = await File(filePath).writeAsBytes(bytes);

  // Return XFile
  return XFile(file.path, mimeType: mimeType);
}