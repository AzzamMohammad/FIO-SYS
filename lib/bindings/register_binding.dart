import 'package:file_sys/modules/register/register_controller.dart';
import 'package:get/get.dart';

class RegisterBinding implements Bindings{
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
  }

}