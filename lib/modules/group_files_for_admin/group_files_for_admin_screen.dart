import 'package:file_sys/modules/group_files_for_admin/group_files_for_admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../compoents/app_bar.dart';
import '../../compoents/loading.dart';
import '../../compoents/loading/loading_file_card.dart';
import '../../compoents/open_and_download_file.dart';

class GroupFilesForAdminScreen extends StatelessWidget {

  final LoadingMessage loadingMessage = LoadingMessage();

  final GroupFilesForAdminController groupFilesForAdminController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      BuildAppBar(context, true, '${groupFilesForAdminController.GroupName}'),
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
      if (groupFilesForAdminController.IsLoadedFile.value) {
        if (groupFilesForAdminController.NumberOfFileInList.value == 0)
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
            itemCount: groupFilesForAdminController.NumberOfFileInList.value + 1,
            controller: groupFilesForAdminController.FileListController,
            itemBuilder: (context, index) {
              if (index < groupFilesForAdminController.NumberOfFileInList.value)
                return BuildFileCard(context, index);
              else {
                if (!groupFilesForAdminController.ArrivedToEndOfFilesList)
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
        OpenFile(context , groupFilesForAdminController.FilesGroupList[index].path, groupFilesForAdminController.FilesGroupList[index].id);
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
          groupFilesForAdminController.FilesGroupList[index].path,
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
    await groupFilesForAdminController.GetFilePath(FileId);
    if(groupFilesForAdminController.State){
      OpenTheFile(groupFilesForAdminController.PathReadFile!, FileName);
      loadingMessage.Dismiss();
    }else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          groupFilesForAdminController.Message,
          true);
    }
  }

  void RefreshGroupScreen() {
    groupFilesForAdminController.Refresh();
  }
}
