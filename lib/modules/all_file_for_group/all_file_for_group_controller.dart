
import 'package:file_sys/modules/all_file_for_group/all_file_for_group_screen.dart';
import 'package:file_sys/modules/all_file_for_group/all_file_for_group_server.dart';
import 'package:file_sys/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/sys_files.dart';
import '../../models/users.dart';

class AllFileForGroupController extends GetxController{
  late String Message;
  late int GroupId;
  late String GroupName;
  late AllFileForGroupServer allFileForGroupServer ;
  late bool State;
  late ScrollController FileListController;
  late List<MyFile> FilesGroupList;
  late var NumberOfFileInList;
  late var IsLoadedFile;
  late String NextPageUrl;
  late bool ArrivedToEndOfFilesList;
  late List<User> SysUsersList;
  late var NumberOfUsersInList;
  late var IsLoadedUsers;
  late String NextPageUsersUrl;
  late bool ArrivedToEndOfUsersList;
  late SharedData sharedData ;
  late String token;
  late List<MyFile> ChickInFiles;
  late var ChickMode;
  late var NumberOfCheckFile;
  late String? PathReadFile;


  @override
  void onInit() async{
    GroupId = Get.arguments['group_id'];
    GroupName = Get.arguments['group_name'];
    Message = '';
    State = false;
    allFileForGroupServer = AllFileForGroupServer();
    FilesGroupList = [];
    ChickInFiles = [];
    ChickMode = false.obs;
    NumberOfCheckFile = 0.obs;
    NumberOfFileInList = 0.obs;
    IsLoadedFile = false.obs;
    NextPageUrl = '';
    ArrivedToEndOfFilesList = false;
    SysUsersList = [];
    NumberOfUsersInList = 0.obs;
    IsLoadedUsers = false.obs;
    NextPageUsersUrl = '';
    PathReadFile = '';
    ArrivedToEndOfUsersList = false;
    FileListController = ScrollController();
    FileListController.addListener(() {
      if(FileListController.position.maxScrollExtent == FileListController.offset){
        if(!ArrivedToEndOfFilesList)
          GetNewFileToGroupList();
      }
    });
    sharedData = SharedData();
    token = await sharedData.GetToken();
    super.onInit();
  }

  @override
  void onReady() {
    GetNewFileToGroupList();
    super.onReady();
  }

  @override
  void dispose() {
    FileListController.dispose();
    super.dispose();
  }

  void GetNewFileToGroupList()async{
    List<MyFile> NewFiles;
    NewFiles = await allFileForGroupServer.GetNewFilesGroupList(token,NextPageUrl,GroupId);
    State = allFileForGroupServer.IsLoaded;
    if(State){
      IsLoadedFile(true);
      FilesGroupList.addAll(NewFiles);
      NumberOfFileInList(FilesGroupList.length);
      NextPageUrl = allFileForGroupServer.NextPage;
      if(allFileForGroupServer.LastPage == allFileForGroupServer.CurrentPage)
        ArrivedToEndOfFilesList = true;
    }
  }

  void GetNewSysUsers()async{
   while(!ArrivedToEndOfUsersList){
     List<User> NewUserList ;
     NewUserList = await allFileForGroupServer.GetNewUsersList(token);
     State = allFileForGroupServer.UsersIsLoaded;
     if(State){
       IsLoadedUsers = true;
       SysUsersList.addAll(NewUserList);
       NumberOfUsersInList(SysUsersList.length);
       NextPageUsersUrl = allFileForGroupServer.NextPage;
       if(allFileForGroupServer.CurrentPage == allFileForGroupServer.LastPage)
         ArrivedToEndOfUsersList = true;
     }
   }
  }

  Future<void> AddSelectedUserToGroup(int UserId)async{
    State = await allFileForGroupServer.AddUser(token,GroupId,UserId);
    Message = allFileForGroupServer.Message;
  }

  Future<void> SendDeleteFile(int FileId)async{
    State = await allFileForGroupServer.DeleteFile(token,FileId,GroupId);
    Message = allFileForGroupServer.Message;
  }

  Future<void> SendDeleteGroup()async{
    State = await allFileForGroupServer.DeleteGroup(token,GroupId);
    Message = allFileForGroupServer.Message;
  }

  Future<void> SendCheckInFilesList()async{
    List<int> CheckInFilesIdList = [];
    for(MyFile myFile in ChickInFiles){
      CheckInFilesIdList.add(myFile.id);
    }
    State = await allFileForGroupServer.SendCheckInFilesList(token , GroupId , CheckInFilesIdList);
    Message = allFileForGroupServer.Message;
  }

  Future<void> GetFilePath(int FileId)async{
    PathReadFile = await allFileForGroupServer.GetFilePath(token,FileId);
    Message = allFileForGroupServer.Message;
    if(PathReadFile == null)
      State = false;
    else
      State = true;
  }

  void Refresh(){
    IsLoadedFile(false);
    FilesGroupList.clear();
    NumberOfFileInList(0);
    NextPageUrl = '';
    ArrivedToEndOfFilesList = false;
    GetNewFileToGroupList();
  }

}