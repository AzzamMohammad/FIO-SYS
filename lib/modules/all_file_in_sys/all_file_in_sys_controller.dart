import 'package:file_sys/modules/all_file_for_group/all_file_for_group_server.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../models/sys_admin_file.dart';
import '../../storage/shared_data.dart';
import 'all_file_in_sys_server.dart';

class AllFileInSysController extends GetxController{
  late String Message;
  late bool State;
  late AllFileInSysServer allFileInSysServer;
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
    Message = '';
    State = false;
    FilesGroupList = [];
    allFileInSysServer = AllFileInSysServer();
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
    NewFiles = await allFileInSysServer.GetNewFilesGroupList(token,NextPageUrl);
    State = allFileInSysServer.IsLoaded;
    if(State){
      IsLoadedFile(true);
      FilesGroupList.addAll(NewFiles);
      NumberOfFileInList(FilesGroupList.length);
      NextPageUrl = allFileInSysServer.NextPage;
      if(allFileInSysServer.LastPage == allFileInSysServer.CurrentPage)
        ArrivedToEndOfFilesList = true;
    }
  }

  Future<void> GetFilePath(int FileId)async{
    PathReadFile = await allFileInSysServer.GetFilePath(token,FileId);
    Message = allFileInSysServer.Message;
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