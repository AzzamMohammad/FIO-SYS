import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../compoents/BuildDrawer.dart';
import '../../compoents/app_bar.dart';
import '../../compoents/loading.dart';
import '../../compoents/loading/loading_file_card.dart';
import '../../compoents/open_and_download_file.dart';
import 'all_file_in_sys_controller.dart';

class AllFileInSysScreen extends StatelessWidget {
  final LoadingMessage loadingMessage = LoadingMessage();
  final AllFileInSysController allFileInSysController = Get.find();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      endDrawer: BuildDrawer(context),
      appBar: BuildAppBar(context, true, 'All Sys files'),
      body: SafeArea(
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                RefreshGroupScreen();
              },
              child: BuildFilesList(context),
            ),
          )),
    );
  }

  Widget BuildFilesList(BuildContext context) {
    return Obx(() {
      if (allFileInSysController.IsLoadedFile.value) {
        if (allFileInSysController.NumberOfFileInList.value == 0)
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
        else {
          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(8),
            itemCount: allFileInSysController.NumberOfFileInList.value + 1,
            controller: allFileInSysController.FileListController,
            itemBuilder: (context, index) {
              if (index < allFileInSysController.NumberOfFileInList.value)
                return BuildFileCard(context, index);
              else {
                if (!allFileInSysController.ArrivedToEndOfFilesList)
                  return LoadingFileCard(context);
                return Container();
              }
            },
          );
        }
      } else {
        return LoadingFileCard(context);
      }
    });
  }

  Widget BuildFileCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        OpenFile(context , allFileInSysController.FilesGroupList[index].path, allFileInSysController.FilesGroupList[index].id);
      },
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/icons/file_icon.png'),
                  fit: BoxFit.cover)),
        ),
        title: Text(
          allFileInSysController.FilesGroupList[index].path,
          style: TextStyle(
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  void OpenFile(BuildContext context,String FileName,int FileId)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await allFileInSysController.GetFilePath(FileId);
    if(allFileInSysController.State){
      OpenTheFile(allFileInSysController.PathReadFile!, FileName);
      loadingMessage.Dismiss();
    }else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allFileInSysController.Message,
          true);
    }
  }

  void RefreshGroupScreen() {
    allFileInSysController.Refresh();
  }
}
