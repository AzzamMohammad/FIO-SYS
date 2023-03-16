import 'package:file_sys/modules/all_group_for_user/all_group_for_user_controller.dart';
import 'package:get/get.dart';

class AllGroupForUserBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<AllGroupForUserController>(AllGroupForUserController());
  }

}