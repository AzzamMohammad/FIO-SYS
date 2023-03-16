import 'package:file_sys/modules/all_group_for_user/all_group_for_user_screen.dart';
import 'package:file_sys/modules/file_history/file_history_screen.dart';
import 'package:file_sys/modules/home/home_screen.dart';
import 'package:file_sys/modules/login/login_screen.dart';
import 'package:file_sys/modules/register/register_screen.dart';
import 'package:file_sys/modules/splash/splash_screen.dart';
import 'package:file_sys/provider/provider_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'bindings/all_file_for_group_binding.dart';
import 'bindings/all_file_in_sys_binding.dart';
import 'bindings/all_group_for_user_binding.dart';
import 'bindings/all_groups_in_sys_binding.dart';
import 'bindings/file_history_binding.dart';
import 'bindings/group_files_for_admin_binding.dart';
import 'bindings/home_binding.dart';
import 'bindings/login_binding.dart';
import 'bindings/register_binding.dart';
import 'bindings/splash_binding.dart';
import 'bindings/user_check_in_file_in_group_binding.dart';
import 'bindings/users_group_binding.dart';
import 'modules/all_file_for_group/all_file_for_group_screen.dart';
import 'modules/all_file_in_sys/all_file_in_sys_screen.dart';
import 'modules/all_groups_in_sys/all_groups_in_sys_screen.dart';
import 'modules/group_files_for_admin/group_files_for_admin_screen.dart';
import 'modules/user_check_in_file_in_group/user_check_in_file_in_group_screen.dart';
import 'modules/users_group/users_group_screen.dart';

void main() {
  runApp(
    GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: MyThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages:[
        //auth
        GetPage(name: '/splash', page: () => SplashScreen(), binding: SplashBinding()),
        GetPage(name: '/register', page: () => RegisterScreen(), binding: RegisterBinding()),
        GetPage(name: '/login', page: () => LoginScreen(), binding: LoginBinding()),
        //home
        GetPage(name: '/home', page: () => HomeScreen(), binding: HomeBinding()),
        GetPage(name: '/file_history', page: () => FileHistoryScreen(), binding: FileHistoryBinding()),
        //all_group_for_user
        GetPage(name: '/all_group_for_user', page: () => AllGroupForUserScreen(), binding: AllGroupForUserBinding()),
        GetPage(name: '/user_check_in_file_in_group', page: () => UserCheckInFileInGroupScreen(), binding: UserCheckInFileInGroupBinding()),
        //group
        GetPage(name: '/all_file_for_group', page: () => AllFileForGroupScreen(), binding: AllFileForGroupBinding()),
        GetPage(name: '/all_user_of_group', page: () => UsersGroupScreen(), binding: UsersGroupBinding()),
        // admin
        GetPage(name: '/all_groups_in_sys', page: () => AllGroupsInSysScreen(), binding: AllGroupsInSysBinding()),
        GetPage(name: '/group_files_for_admin', page: () => GroupFilesForAdminScreen(), binding: GroupFilesForAdminBinding()),
        GetPage(name: '/all_files_in_sys', page: () => AllFileInSysScreen(), binding: AllFileInSysBinding()),

      ],
      builder: EasyLoading.init(),
    )
  );
  ConfigEasyLoading();

}


void ConfigEasyLoading(){
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 20)
    ..indicatorType = EasyLoadingIndicatorType.foldingCube
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50
    ..radius = 10.0
    ..progressColor = Colors.green
    ..maskColor = Colors.blue
    ..userInteractions = false
    ..dismissOnTap = false;

}
