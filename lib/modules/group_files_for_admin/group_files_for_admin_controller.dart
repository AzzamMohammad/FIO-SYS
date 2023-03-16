import 'package:file_sys/modules/group_files_for_admin/group_files_for_admin_screen.dart';
import 'package:file_sys/modules/group_files_for_admin/group_files_for_admin_server.dart';
import 'package:file_sys/storage/shared_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/sys_admin_file.dart';

class GroupFilesForAdminController extends GetxController{
  late String Message;
  late GroupFilesForAdminServer groupFilesForAdminServer;
  late int GroupId;
  late String GroupName;
  late bool State;
  late ScrollController FileListController;
  late List<FileSys> FilesGroupList;
  late var NumberOfFileInList;
  late var IsLoadedFile;
  late String NextPageUrl;
  late bool ArrivedToEndOfFilesList;
  late SharedData sharedData ;
  late String token;
  late String? PathReadFile;

  @override
  void onInit() async{
    GroupId = Get.arguments['group_id'];
    GroupName = Get.arguments['group_name'];
    Message = '';
    State = false;
    groupFilesForAdminServer = GroupFilesForAdminServer();
    FilesGroupList = [];
    NumberOfFileInList = 0.obs;
    IsLoadedFile = false.obs;
    NextPageUrl = '';
    ArrivedToEndOfFilesList = false;
    PathReadFile = '';
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
    List<FileSys> NewFiles;
    NewFiles = await groupFilesForAdminServer.GetNewFilesGroupList(token,NextPageUrl,GroupId);
    State = groupFilesForAdminServer.IsLoaded;
    if(State){
      IsLoadedFile(true);
      FilesGroupList.addAll(NewFiles);
      NumberOfFileInList(FilesGroupList.length);
      NextPageUrl = groupFilesForAdminServer.NextPage;
      if(groupFilesForAdminServer.LastPage == groupFilesForAdminServer.CurrentPage)
        ArrivedToEndOfFilesList = true;
    }
  }

  Future<void> GetFilePath(int FileId)async{
    PathReadFile = await groupFilesForAdminServer.GetFilePath(token,FileId);
    Message = groupFilesForAdminServer.Message;
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