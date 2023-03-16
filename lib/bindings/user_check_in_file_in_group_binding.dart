import 'package:file_sys/modules/user_check_in_file_in_group/user_check_in_file_in_group_controller.dart';
import 'package:get/get.dart';

class UserCheckInFileInGroupBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<UserCheckInFileInGroupController>(UserCheckInFileInGroupController());
  }

}