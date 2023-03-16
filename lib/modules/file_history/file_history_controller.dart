import 'package:file_sys/modules/file_history/file_history_server.dart';
import 'package:file_sys/storage/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/history_of_file.dart';

class FileHistoryController extends GetxController{
  late FileHistoryServer fileHistoryServer;
  late ScrollController HistoryListController;
  late String Message;
  late bool State;
  late String FileName;
  late int FileId;
  late List<HistoryData> HistoryOfFileList;
  late var NumberOfItemInList;
  late bool ArrivedToEndOfList;
  late String NextPageUrl;
  late SharedData sharedData;
  late String Token;

  @override
  void onInit() async {
    HistoryListController = ScrollController();
    NumberOfItemInList = 0.obs;
    ArrivedToEndOfList = false;
    Message = '';
    State = false;
    FileName= Get.arguments['file_name'];
    FileId = Get.arguments['file_id'];
    HistoryOfFileList = [];

    NextPageUrl = '';
    fileHistoryServer = FileHistoryServer();
    sharedData = SharedData();
    Token = await sharedData.GetToken();
    HistoryListController.addListener(() {
      if(HistoryListController.position.maxScrollExtent == HistoryListController.offset){
        if(!ArrivedToEndOfList)
          GetNewHistory();
      }
    });
    super.onInit();
  }
  @override
  void onReady() {
    GetNewHistory();
    super.onReady();
  }

  @override
  void dispose() {
    HistoryListController.dispose();
    super.dispose();
  }

  void GetNewHistory()async{
    List<HistoryData> NewData;
    NewData = await fileHistoryServer.GetNewHistoryFile(Token,FileId,NextPageUrl);
    State = fileHistoryServer.IsLoaded;
    if(State){
      HistoryOfFileList.addAll(NewData);
      NumberOfItemInList(HistoryOfFileList.length);
      NextPageUrl = fileHistoryServer.NextPageUrl;
      if(fileHistoryServer.CurrentPage == fileHistoryServer.LastPage)
        ArrivedToEndOfList = true;
    }
  }

  void Refresh(){
    HistoryOfFileList.clear();
    NumberOfItemInList(0);
    NextPageUrl = '';
    ArrivedToEndOfList = false;
    GetNewHistory();
  }
}