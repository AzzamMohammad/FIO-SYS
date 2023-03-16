import 'package:file_sys/modules/register/register_server.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/person.dart';
import '../../storage/shared_data.dart';

class RegisterController extends GetxController{
  late TextEditingController emailController ;
  late TextEditingController PassWordController ;
  late TextEditingController NameController ;
  late Person person;
  late String UserEmail;
  late String UserName;
  late String UserPassword;
  late bool state;
  late String message;
  late SharedData sharedData;
  late var Role;
  late RegisterServer registerServer ;

  @override
  void onInit() {
    emailController = TextEditingController();
    PassWordController = TextEditingController();
    NameController = TextEditingController();
    UserEmail = '';
    UserName = '';
    UserPassword = '';
    state = false;
    message ='';
    Role = 1.obs;
    registerServer = RegisterServer();
    sharedData = SharedData();
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    PassWordController.dispose();
    super.dispose();
  }
  Future <void> RegisterClicked()async{
    person = Person(Email: UserEmail, Password: UserPassword,Name: UserName);
    state = await registerServer.SendRegisterRequest(person, Role.value);
    message = registerServer.message;
  }

}