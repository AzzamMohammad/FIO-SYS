import 'package:get/get.dart';

import '../modules/file_history/file_history_controller.dart';

class FileHistoryBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<FileHistoryController>(FileHistoryController());
  }

}