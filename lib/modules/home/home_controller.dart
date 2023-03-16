import 'dart:io';

import 'package:file_sys/models/file_info.dart';
import 'package:file_sys/models/groups.dart';
import 'package:file_sys/modules/home/home_server.dart';
import 'package:file_sys/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/sys_files.dart';


class HomeController extends GetxController{
  late bool State;
  late var IsLoaded;
  late var IsLoadedListOfGroup;
  late String Message;
  late ScrollController UserFilesListScrollController;
  // late ScrollController UserGroupListScrollController;
  late List<MyFile> UserFilesList;
  late var NumberOfFileInList;
  late bool ArrivedToLastPage;
  late String NextPageUrl;
  late List<Grope> UserGroupsList;
  late var NumberOfGroupInList;
  late bool ArrivedToLastPageOfGroupList;
  late String NextPageUrlOfGroupList;
  late SharedData sharedData;
  late String Token;
  late File? NewFile;
  late HomeServer homeServer;
  late int FileId;
  late int GroupId;
  late FileInfo? FileInformation;
  late String? PathReadFile;

  @override
  void onInit() async {
    State = false;
    IsLoaded = false.obs;
    IsLoadedListOfGroup = false.obs;
    UserFilesList = [];
    NumberOfFileInList = 0.obs;
    ArrivedToLastPage = false;
    NextPageUrl = '';
    UserGroupsList = [];
    NumberOfGroupInList = 0.obs;
    ArrivedToLastPageOfGroupList = false;
    NextPageUrlOfGroupList = '';
    Message = '';
    NewFile = null;
    PathReadFile = '';
    FileInformation = null;
    homeServer = HomeServer();
    UserFilesListScrollController = ScrollController();
    // UserGroupListScrollController = ScrollController();
    sharedData = SharedData();
    Token = await sharedData.GetToken();
    UserFilesListScrollController.addListener(() {
      if(UserFilesListScrollController.position.maxScrollExtent == UserFilesListScrollController.offset){
        if(!ArrivedToLastPage)
          GetNewFilesListItem();
      }
    });
    // UserGroupListScrollController.addListener(() {
    //   if(UserGroupListScrollController.position.maxScrollExtent == UserGroupListScrollController.offset){
    //     if(!ArrivedToLastPageOfGroupList)
    //       GetNewUserGroup();
    //   }
    // });
    super.onInit();
  }

  @override
  void onReady() {
    GetNewFilesListItem();
    super.onReady();
  }

  @override
  void dispose() {
    UserFilesListScrollController.dispose();
    // UserGroupListScrollController.dispose();
    super.dispose();
  }


  void GetNewFilesListItem()async{
    List<MyFile> NewUserFilesList ;
    NewUserFilesList = await homeServer.GetNewUserFiles(Token, NextPageUrl);
    IsLoaded(homeServer.IsLoaded);
    UserFilesList.addAll(NewUserFilesList);
    NumberOfFileInList(UserFilesList.length);
    NextPageUrl = homeServer.NextPageUrl;
    Message = homeServer.Message;
    print(NumberOfFileInList.value);
    if(homeServer.CurrentPage == homeServer.LastPage)
      ArrivedToLastPage = true;
  }

  Future<void> SendNewFile()async{
    State = await homeServer.SendFile( Token ,  NewFile);
    Message = homeServer.Message;
  }

  Future<void> GetNewUserGroup()async{
   while(!ArrivedToLastPageOfGroupList){
     List<Grope> NewGroupList ;
     NewGroupList = await homeServer.GetNewUserGroupList(Token, NextPageUrlOfGroupList);
     State = homeServer.IsLoaded;
     if(State){
       IsLoadedListOfGroup(true);
       UserGroupsList.addAll(NewGroupList);
       NumberOfGroupInList(UserGroupsList.length);
       NextPageUrlOfGroupList = homeServer.NextPageUrl;
       Message = homeServer.Message;
       if(homeServer.CurrentPage == homeServer.LastPage)
         ArrivedToLastPageOfGroupList = true;
     }
   }
  }

  Future<void> SendFileToGroup()async{
    State = await homeServer.SendFileToGroup( Token , FileId,GroupId);
    Message = homeServer.Message;
  }

  Future<void> DeleteUserFile(int FileId)async{
    State = await homeServer.DeleteUserFile( Token , FileId);
    Message = homeServer.Message;
  }

  Future<void> GetInformationFile(int FileId)async{
    FileInformation = await homeServer.GetFileInfoList(Token, FileId);
    Message = homeServer.Message;
    State = homeServer.StateGetInfo;
    // if(FileInformation != null){
    //   State = true;
    // }
    // State = false;
  }

  Future<void> GetFilePath(int FileId)async{
    PathReadFile = await homeServer.GetFilePath(Token,FileId);
    Message = homeServer.Message;
    if(PathReadFile == null)
      State = false;
    else
      State = true;
  }

  Future<void> Refresh()async{
    IsLoaded(false);
    UserFilesList.clear();
    NumberOfFileInList(0);
    ArrivedToLastPage = false;
    IsLoadedListOfGroup(false);
    UserGroupsList.clear();
    NumberOfGroupInList(0);
    ArrivedToLastPageOfGroupList = false;
    NextPageUrl = '';
    NewFile = null;
    GetNewFilesListItem();
  }

}