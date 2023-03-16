import 'dart:isolate';

import 'package:file_sys/modules/splash/splash_server.dart';
import 'package:file_sys/storage/shared_data.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{
  late String UserEmail;
  late String UserPassword;
  late SharedData sharedData;
  late var IsLoaded;
  late bool State;
  late SplashServer splashServer;
  late String Message;

  @override
  void onInit() async{
    IsLoaded = false.obs;
    State = false;
    splashServer = SplashServer();
    sharedData = SharedData();
    UserEmail = await sharedData.GetEmail();
    UserPassword = await sharedData.GetPassword();
    super.onInit();
  }

  @override
  void onReady() {
    GoTo();
    super.onReady();
  }

  void GoTo()async{
    if(UserEmail != '' && UserPassword != ''){
      State = await splashServer.SendLoginRequest(UserEmail, UserPassword, sharedData);
    }
    if(State)
      print('dd');
    // Get.offAllNamed('/home');
   // else
     // Get.offAllNamed('/register');

  }
}
