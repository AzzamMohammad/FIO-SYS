
import 'package:file_sys/modules/all_group_for_user/all_group_for_user_server.dart';
import 'package:file_sys/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/groups.dart';

class AllGroupForUserController extends GetxController{
  late ScrollController GroupListController;
  late AllGroupForUserServer allGroupForUserServer;
  late bool State;
  late String Message;
  late List<Grope> ListOfUserGroup;
  late var NumberOfMemberInList;
  late var IsLoaded;
  late String NextPageURL;
  late bool ArrivedToEndOfList;
  late SharedData sharedData;
  late String Token;

  @override
  void onInit() async{
    GroupListController = ScrollController();
    allGroupForUserServer = AllGroupForUserServer();
    State = false;
    Message = '';
    ListOfUserGroup = [];
    NumberOfMemberInList = 0.obs;
    IsLoaded = false.obs;
    NextPageURL = '';
    ArrivedToEndOfList = false;
    sharedData = SharedData();
    Token = await sharedData.GetToken();
    super.onInit();
  }

  @override
  void onReady() {
    GetNewUserGroupList();
    GroupListController.addListener(() {
      if(GroupListController.position.maxScrollExtent == GroupListController.offset){
        if(!ArrivedToEndOfList)
          GetNewUserGroupList();
      }
    });
    super.onReady();
  }
  @override
  void dispose() {
    GroupListController.dispose();
    super.dispose();
  }

  Future<void> GetNewUserGroupList() async{
    List<Grope> NewGroupList ;
    NewGroupList = await allGroupForUserServer.GetNewUserGroupList(Token, NextPageURL);
    State = allGroupForUserServer.IsLoaded;
    if(State){
      IsLoaded(true);
      ListOfUserGroup.addAll(NewGroupList);
      NumberOfMemberInList(ListOfUserGroup.length);
      NextPageURL = allGroupForUserServer.NextPage;
      Message = allGroupForUserServer.Message;
      if(allGroupForUserServer.CurrentPage == allGroupForUserServer.LastPage)
        ArrivedToEndOfList = true;
    }
  }

  void Refresh(){
    ListOfUserGroup.clear();
    NumberOfMemberInList(0);
    IsLoaded(false);
    NextPageURL = '';
    ArrivedToEndOfList = false;
    GetNewUserGroupList();
  }

}