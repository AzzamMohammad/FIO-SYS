
import 'dart:io';

import 'package:file_sys/compoents/open_and_download_file.dart';
import 'package:file_sys/models/groups.dart';
import 'package:file_sys/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../../compoents/BuildDrawer.dart';
import '../../compoents/app_bar.dart';
import '../../compoents/load_file.dart';
import '../../compoents/loading.dart';
import '../../compoents/loading/loading_file_card.dart';
import '../../constantes.dart';
import '../../constants/colors.dart';

class HomeScreen extends StatelessWidget {
  final ScrollDown = true.obs;
  final HomeController homeController = Get.find();
  final LoadingMessage loadingMessage = LoadingMessage();
  final SelectedGroupValue = ''.obs;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: BuildDrawer(context),
      appBar: BuildAppBar(context, false, 'FIO SYS'),
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              if (ScrollDown.value != true) ScrollDown(true);
            }
            if (notification.direction == ScrollDirection.reverse) {
              if (ScrollDown.value != false) ScrollDown(false);
            }
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: () async {
                await RefreshScreen();
              },
                color: Color(0xffDD5353),
              child:Obx((){
                if(homeController.IsLoaded.value){
                  if(homeController.NumberOfFileInList.value == 0){
                    return Column(
                      children: [
                        SingleChildScrollView(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .4),
                          physics:  AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child:Text(homeController.Message,style: TextStyle(color: Color(0xffDD5353),fontSize: 18),),
                          ),
                        )
                      ],
                    );

                  }
                  else{
                    return  ListView.builder(
                        itemCount: homeController.NumberOfFileInList.value + 1,
                        shrinkWrap: true,
                        primary: false,
                        physics:  AlwaysScrollableScrollPhysics(),
                        controller: homeController.UserFilesListScrollController,
                        itemBuilder: (context, index) {
                          if(index < homeController.NumberOfFileInList.value)
                            return BuildFileCard(context,index);
                          else{
                            if(!homeController.ArrivedToLastPage)
                              return LoadingFileCard(context);
                            return Container();
                          }
                        });
                  }
                }
                 else
                return LoadingFileCard(context);
              })
            ),
          ),
        ),

      ),
      floatingActionButton:  Obx(() {
        if (ScrollDown.value)
          return AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeOut,
              width: 150,
              height: 50,
              child: FloatingActionButton.extended(
                onPressed: () {
                  AddNewFile(context);
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                label: Text(
                  'New file',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Color(0xffDD5353),
              ));
        return AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
          width: 50,
          height: 50,
          child: FloatingActionButton(
            onPressed: () {
              AddNewFile(context);
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),

            backgroundColor: Color(0xffDD5353),
          ),
        );
      }),

    );
  }

  Widget BuildFileCard(BuildContext context, int index){
    return GestureDetector(
      onTap: (){
        OpenFile(context , homeController.UserFilesList[index].path, homeController.UserFilesList[index].id);
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
          homeController.UserFilesList[index].path,
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
                  Text('Add to group'),
                  Icon(Icons.add_to_drive ,color: Colors.black),
                ],
              ),
              onTap: () {
                Future.delayed(
                    Duration(seconds: 0),
                        () async => AddFileTOGroup(context , homeController.UserFilesList[index].id)
                );
              },
            ),
            PopupMenuItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Get info'),
                  Icon(Icons.info_outline ,color: Colors.black,),
                ],
              ),
              onTap: () {
                Future.delayed(
                    Duration(seconds: 0),
                        () async => GetFileInfo(context , homeController.UserFilesList[index].id)
                );
              },
            ),
            PopupMenuItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Get history'),
                  Icon(Icons.history ,color: Colors.black,),
                ],
              ),
              onTap: () {
                Future.delayed(
                    Duration(seconds: 0),
                        () async => Get.toNamed('/file_history',arguments: {'file_id':homeController.UserFilesList[index].id,'file_name':'${homeController.UserFilesList[index].path}'})
                );
              },
            ),

            PopupMenuItem(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                  Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                  )
                ],
              ),
              onTap: () {
                Future.delayed(
                    Duration(seconds: 0),
                        () async =>DeleteUserFile(context ,homeController.UserFilesList[index].id)

                );
              },
            ),
          ],
        )
      ),
    );
  }

  void AddNewFile(BuildContext context)async{
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
    if(NewFile.lengthSync() < MaxSizeOfUploadingFileInBytes){
      double FileSizeInBytes = NewFile.lengthSync()/1000000;
      String Message = 'File size is ${FileSizeInBytes} MB,The max file size to uploading is ${MaxSizeOfUploadingFileInBytes} MB';
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          Message,
          true);
      return;

    }
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );

    homeController.NewFile = File(NewFile.path);
        await homeController.SendNewFile();
    if(homeController.State){
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          homeController.Message,
          true);
      RefreshScreen();
    }
    else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          homeController.Message,
          true);
    }
  }

  Future<void> RefreshScreen()async{
    await homeController.Refresh();
  }


  void AddFileTOGroup( BuildContext context,int index )async{

    BuildGroupSelectionAlert(context,index);
    if(!homeController.ArrivedToLastPageOfGroupList)
      await homeController.GetNewUserGroup();
  }

  BuildGroupSelectionAlert(BuildContext context,int index){

    Alert(
        context: context,
        content:Obx((){
          if(homeController.NumberOfGroupInList.value == 0)
            return LinearProgressIndicator(
            color: Color(0xffDD5353),
          );
          else
            return Container(
              padding:  EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width * .8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(width: 2,color: Color(0xffDD5353))

            ),
            child: DropdownMenuItem(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: Text('Select group ... '),
                  underline: Divider(
                    thickness: 1,
                  ),
                  isExpanded: true,
                  menuMaxHeight: 150,
                  dropdownColor: Color(0xffDBC8AC),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  alignment: AlignmentDirectional.centerStart,
                  items: homeController.UserGroupsList.map((Grope Group) {
                    return DropdownMenuItem(
                      value: Group.group.name,
                      child: Text(Group.group.name),
                    );
                  }).toList(),
                  icon: Icon(Icons.arrow_drop_down_outlined),
                  value: SelectedGroupValue.value == ''? null : SelectedGroupValue.value,
                  onChanged: (value) async {
                    print(value);
                      SelectedGroupValue(value);
                  },
                ),
              ),
            ),
          );
        }),

        buttons: [
          DialogButton(
            width: MediaQuery.of(context).size.width * .8,
            height: 50,
            child:  Text(
              'Add',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: (){
              SendFileToGroup(context,index);
            },
            padding: EdgeInsets.all(8),
            color: Color(0xffDD5353),
          ),
        ],
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        closeIcon: Icon(
          Icons.close,
          size: 20,
        ),
        style: AlertStyle(
          backgroundColor: Color(0xffDBC8AC),
          animationType: AnimationType.fromTop,
          isCloseButton: true,
          isButtonVisible: true,
          isOverlayTapDismiss: false,
          animationDuration: Duration(milliseconds: 800),
          alertBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color:Color(0xffDBC8AC)
              // width: MediaQuery.of(context).size.width
            ),
          ),
          alertPadding:
          EdgeInsets.only(top: MediaQuery.of(context).size.height * .11),
          constraints:
          BoxConstraints.expand(width: MediaQuery.of(context).size.width),
          overlayColor: Colors.black54,
          alertElevation: 200,
          alertAlignment: Alignment.topLeft,
          buttonsDirection: ButtonsDirection.row,
        )).show();
  }

  void SendFileToGroup(BuildContext context,int index)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    homeController.FileId = index;
    if(SelectedGroupValue.value != '')
    homeController.GroupId = homeController.UserGroupsList.where((element) => element.group.name == SelectedGroupValue.value).first.group.id;
    else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          'Select a group',
          true);
      return ;
    }
    await homeController.SendFileToGroup();
    if(homeController.State){
      Navigator.of(context).pop();
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          homeController.Message,
          true);

    }
    else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          homeController.Message,
          true);
    }
  }

  void GetFileInfo(BuildContext context , int FileId)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await homeController.GetInformationFile( FileId);
    print(homeController.State);

    if(homeController.State){
      print('${homeController.FileInformation!.user.name}');
      loadingMessage.DisplayInfoMessage(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          'The file is reserved by ${homeController.FileInformation!.user.name}',
          false);
    }else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          homeController.Message,
          true);
    }
  }


  void DeleteUserFile(BuildContext context , int FileId)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await homeController.DeleteUserFile(FileId);
    if(homeController.State){
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          homeController.Message,
          true);
      RefreshScreen();
    }
    else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          homeController.Message,
          true);
    }
  }

  void OpenFile(BuildContext context,String FileName,int FileId)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await homeController.GetFilePath(FileId);
    if(homeController.State){
      OpenTheFile(homeController.PathReadFile!, FileName);
      loadingMessage.Dismiss();
    }else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          homeController.Message,
          true);
    }
  }

}
