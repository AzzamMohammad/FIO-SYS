import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/sys_groups.dart';
import '../../storage/shared_data.dart';
import 'all_groups_in_sys_server.dart';

class AllGroupsInSysController extends GetxController{
  late ScrollController GroupListController;
  late AllGroupsInSysServer allGroupsInSysServer;
  late bool State;
  late String Message;
  late List<Group> ListOfSysGroup;
  late var NumberOfMemberInList;
  late var IsLoaded;
  late String NextPageURL;
  late bool ArrivedToEndOfList;
  late SharedData sharedData;
  late String Token;

  @override
  void onInit() async{
    GroupListController = ScrollController();
    allGroupsInSysServer = AllGroupsInSysServer();
    State = false;
    Message = '';
    ListOfSysGroup = [];
    NumberOfMemberInList = 0.obs;
    IsLoaded = false.obs;
    NextPageURL = '';
    ArrivedToEndOfList = false;
    GroupListController.addListener(() {
      if(GroupListController.position.maxScrollExtent == GroupListController.offset){
        if(!ArrivedToEndOfList)
          GetNewSysGroupList();
      }
    });
    sharedData = SharedData();
    Token = await sharedData.GetToken();
    super.onInit();
  }

  @override
  void onReady() {
    GetNewSysGroupList();
    super.onReady();
  }

  @override
  void dispose() {
    GroupListController.dispose();
    super.dispose();
  }

  Future<void> GetNewSysGroupList() async{
    List<Group> NewGroupList ;
    NewGroupList = await allGroupsInSysServer.GetNewUserGroupList(Token, NextPageURL);
    State = allGroupsInSysServer.IsLoaded;
    if(State){
      IsLoaded(true);
      ListOfSysGroup.addAll(NewGroupList);
      NumberOfMemberInList(ListOfSysGroup.length);
      NextPageURL = allGroupsInSysServer.NextPage;
      Message = allGroupsInSysServer.Message;
      if(allGroupsInSysServer.CurrentPage == allGroupsInSysServer.LastPage)
        ArrivedToEndOfList = true;
    }
  }

  void Refresh(){
    ListOfSysGroup.clear();
    NumberOfMemberInList(0);
    IsLoaded(false);
    NextPageURL = '';
    ArrivedToEndOfList = false;
    GetNewSysGroupList();
  }

}