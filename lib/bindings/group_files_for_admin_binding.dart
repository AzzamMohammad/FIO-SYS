import 'package:get/get.dart';

import '../modules/group_files_for_admin/group_files_for_admin_controller.dart';

class GroupFilesForAdminBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<GroupFilesForAdminController>(GroupFilesForAdminController());
  }

}