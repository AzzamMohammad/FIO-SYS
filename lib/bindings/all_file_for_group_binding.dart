import 'package:get/get.dart';
import '../modules/all_file_for_group/all_file_for_group_controller.dart';

class AllFileForGroupBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<AllFileForGroupController>(AllFileForGroupController());
  }
}