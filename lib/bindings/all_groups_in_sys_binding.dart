import 'package:get/get.dart';

import '../modules/all_groups_in_sys/all_groups_in_sys_controller.dart';

class AllGroupsInSysBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<AllGroupsInSysController>(AllGroupsInSysController());
  }

}