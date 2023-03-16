import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<File?> LoadFile()async{
  FilePickerResult? result = await FilePicker.platform.pickFiles(allowCompression: true);
  if (result != null) {
    File file = File(result.files.single.path!);
    return file;
  } else{
    return null;
  }
}