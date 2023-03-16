import 'package:file_sys/modules/users_group/users_group_controller.dart';
import 'package:get/get.dart';

class UsersGroupBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<UsersGroupController>(UsersGroupController());
  }
}