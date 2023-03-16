import 'package:file_sys/modules/users_group/users_group_server.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/group_users.dart';
import '../../storage/shared_data.dart';

class UsersGroupController extends GetxController{
  late UsersGroupServer usersGroupServer;
  late String Message;
  late bool State;
  late int GroupId;
  late String GroupName;
  late List<GroupUser> UsersOfGroupList;
  late var IsLoaded;
  late SharedData sharedData;
  late String Token;

  @override
  void onInit() async {
    usersGroupServer = UsersGroupServer();
    IsLoaded = false.obs;
    Message = '';
    State = false;
    GroupId = Get.arguments['group_id'];
    GroupName= Get.arguments['group_name'];
    UsersOfGroupList = [];
    sharedData = SharedData();
    Token = await sharedData.GetToken();
    super.onInit();
  }

  @override
  void onReady() {
    GetUsersOfGroup();
    super.onReady();
  }

  void GetUsersOfGroup()async{
    UsersOfGroupList = await usersGroupServer.GetUsersOfGroup(Token,GroupId);
    IsLoaded(usersGroupServer.IsLoaded);
    State = usersGroupServer.State;
    Message = usersGroupServer.Message;
  }

  Future<void> DeleteTheUser(int UserId)async{
    State = await usersGroupServer.DeleteTheUser(Token , GroupId , UserId);
    Message = usersGroupServer.Message;
  }

  void Refresh(){
    IsLoaded(false);
    UsersOfGroupList.clear();
    GetUsersOfGroup();
  }
}