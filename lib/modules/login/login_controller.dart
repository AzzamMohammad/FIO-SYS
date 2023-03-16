import 'package:file_sys/modules/login/login_server.dart';
import 'package:file_sys/storage/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/person.dart';

class LoginController extends GetxController{
  late TextEditingController emailController ;
  late TextEditingController PassWordController ;
  late Person person;
  late String UserEmail;
  late String UserPassword;
  late bool state;
  late String message;
  late SharedData sharedData;
  late LoginServer loginServer;

  @override
  void onInit() {
    emailController = TextEditingController();
    PassWordController = TextEditingController();
    UserEmail = '';
    UserPassword = '';
    state = false;
    message ='';
    loginServer = LoginServer();
    sharedData = SharedData();
    super.onInit();
  }

  @override
  void dispose() {
    emailController.dispose();
    PassWordController.dispose();
    super.dispose();
  }

  Future<void> LoginClicked()async{
    person = Person(Email: UserEmail, Password: UserPassword);
    state = await loginServer.SendLoginRequest(person,sharedData);
    message = loginServer.message;
  }
}