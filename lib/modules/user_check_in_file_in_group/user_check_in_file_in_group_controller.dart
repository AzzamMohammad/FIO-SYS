import 'dart:io';

import 'package:file_sys/modules/user_check_in_file_in_group/user_check_in_file_in_group_server.dart';
import 'package:get/get.dart';

import '../../models/checked_files.dart';
import '../../storage/shared_data.dart';

class UserCheckInFileInGroupController extends GetxController{
  late String GroupName;
  late int GroupId;
  late String Message;
  late bool State;
  late List<CheckedFile> CheckFilesList;
  late var IsLoaded;
  late SharedData sharedData;
  late String Token;
  late UserCheckInFileInGroupServer userCheckInFileInGroupServer;
  late String? PathReadFile;


  @override
  void onInit() async{
    GroupName = Get.arguments['group_name'];
    GroupId = Get.arguments['group_id'];
    Message = '';
    State = false;
    CheckFilesList = [];
    IsLoaded = false.obs;
    PathReadFile = '';
    userCheckInFileInGroupServer = UserCheckInFileInGroupServer();
    sharedData = SharedData();
    Token = await sharedData.GetToken();
    super.onInit();
  }

  @override
  void onReady() {
    GetCheckedFile();
    super.onReady();
  }

  void GetCheckedFile()async{
    CheckFilesList = await userCheckInFileInGroupServer.GetCheckedFiles(Token,GroupId);
    State = userCheckInFileInGroupServer.State;
    IsLoaded(userCheckInFileInGroupServer.IsLoaded);
    Message = userCheckInFileInGroupServer.Message;
  }
  Future<void> GetFilePath(int FileId)async{
    PathReadFile = await userCheckInFileInGroupServer.GetFilePath(Token,FileId);
    Message = userCheckInFileInGroupServer.Message;
    if(PathReadFile == null)
      State = false;
    else
      State = true;
  }

  Future<void> SaveTheFile(File NewFile , int FileId)async{
    State = await userCheckInFileInGroupServer.SaveTheNewFileUser(Token , NewFile , FileId);
    Message = userCheckInFileInGroupServer.Message;
  }

  Future<void> ChickOutTheFile( int FileId)async{
    State = await userCheckInFileInGroupServer.ChickOutTheFile(Token , FileId);
    Message = userCheckInFileInGroupServer.Message;
  }

  void Refresh(){
    CheckFilesList.clear();
    IsLoaded(false);
    GetCheckedFile();
  }
}