import 'dart:io';

import 'package:file_sys/modules/user_check_in_file_in_group/user_check_in_file_in_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../compoents/app_bar.dart';
import '../../compoents/load_file.dart';
import '../../compoents/loading.dart';
import '../../compoents/loading/loading_file_card.dart';
import '../../compoents/open_and_download_file.dart';

class UserCheckInFileInGroupScreen extends StatelessWidget {
  final UserCheckInFileInGroupController userCheckInFileInGroupController = Get.find();
  final LoadingMessage loadingMessage = LoadingMessage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(context,true,'Check in files'),
      body: RefreshIndicator(
        onRefresh: ()async{
          RefreshTheScreen();
        },
        color: Color(0xffDD5353),
        child: SafeArea(
          child: BuildAllCheckFilesList(context),
        ),
      ),
    );
  }

  Widget BuildAllCheckFilesList(BuildContext context){
    return Obx((){
      if(!userCheckInFileInGroupController.IsLoaded.value){
        return LoadingFileCard(context);;
      }else{
      if(!userCheckInFileInGroupController.State){
          loadingMessage.DisplayError(
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              userCheckInFileInGroupController.Message,
              true);
          }
        if(userCheckInFileInGroupController.CheckFilesList.length == 0){
          return Column(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .4),
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Text('No files .. '),
                ),
              )
            ],
          );
        }else{
          return ListView.builder(
            padding: EdgeInsets.all(8),
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: userCheckInFileInGroupController.CheckFilesList.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (context,index){
              return BuildFileBar(context,index);
            },
          );
        }
      }
    });
  }

  Widget BuildFileBar(BuildContext context,int index){
    return GestureDetector(
      onTap: (){
        OpenFile(context , userCheckInFileInGroupController.CheckFilesList[index].path, userCheckInFileInGroupController.CheckFilesList[index].id);
      },
      child:ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/icons/file_icon.png'),
                    fit: BoxFit.cover
                )
            ),
          ),
          title: Text(
            userCheckInFileInGroupController.CheckFilesList[index].path,
            style: TextStyle(
              fontSize: 14,

            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing:PopupMenuButton<Widget>(
            iconSize: 20,
            position: PopupMenuPosition.over,
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * .4,
              minWidth: MediaQuery.of(context).size.width * .4,
            ),
            color: Color(0xffeadcd0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Save file'),
                    Icon(Icons.upload ,color: Colors.black),
                  ],
                ),
                onTap: () {
                  Future.delayed(
                      Duration(seconds: 0),
                          () async => SaveTheFile(context , userCheckInFileInGroupController.CheckFilesList[index].path,userCheckInFileInGroupController.CheckFilesList[index].id)
                  );
                },
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('End check'),
                    Icon(Icons.clear ,color: Colors.black,),
                  ],
                ),
                onTap: () {
                  Future.delayed(
                      Duration(seconds: 0),
                          () async => ChickOutTheFile(context ,userCheckInFileInGroupController.CheckFilesList[index].id)
                  );
                },
              ),
            ],
          )
      ),
    );
  }

  void OpenFile(BuildContext context,String FileName,int FileId)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await userCheckInFileInGroupController.GetFilePath(FileId);
    if(userCheckInFileInGroupController.State){
      OpenTheFile(userCheckInFileInGroupController.PathReadFile!, FileName);
      loadingMessage.Dismiss();
    }else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          userCheckInFileInGroupController.Message,
          true);
    }
  }

  void SaveTheFile(BuildContext context , String FileName , int FileId)async{
    // final AppStorage = await getApplicationDocumentsDirectory();
    // File file = File('${AppStorage.path}/$FileName');
    // if(!file.existsSync()){
    //   loadingMessage.DisplayError(
    //       Theme.of(context).scaffoldBackgroundColor,
    //       Theme.of(context).primaryColor,
    //       Theme.of(context).primaryColor,
    //       'Edit file before saving it',
    //       true);
    //   return ;
    // }
    // loadingMessage.DisplayLoading(
    //   Theme.of(context).scaffoldBackgroundColor,
    //   Theme.of(context).primaryColor,
    // );
    File? NewFile = await LoadFile();
    if(NewFile == null){
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          'Can not load file',
          true);
      await Future.delayed(Duration(seconds: 3));
      loadingMessage.Dismiss();
      return ;
    }
    if(NewFile.path.contains(FileName)){
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          'Check file name..',
          true);
      await Future.delayed(Duration(seconds: 3));
      loadingMessage.Dismiss();
      return ;
    }
    await userCheckInFileInGroupController.SaveTheFile(NewFile,FileId);
    if(userCheckInFileInGroupController.State){
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          userCheckInFileInGroupController.Message,
          true);
    }else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          userCheckInFileInGroupController.Message,
          true);
    }
  }

  void ChickOutTheFile(BuildContext context , int FileId)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await userCheckInFileInGroupController.ChickOutTheFile(FileId);
    if(userCheckInFileInGroupController.State){
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          userCheckInFileInGroupController.Message,
          true);
    }else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          userCheckInFileInGroupController.Message,
          true);
    }
  }
  RefreshTheScreen(){
    userCheckInFileInGroupController.Refresh();
  }
}

