import 'package:get/get.dart';

import '../modules/all_file_in_sys/all_file_in_sys_controller.dart';

class AllFileInSysBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<AllFileInSysController>(AllFileInSysController());
  }

}