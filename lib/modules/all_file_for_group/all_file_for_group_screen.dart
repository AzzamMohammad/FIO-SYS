import 'package:file_sys/modules/all_file_for_group/all_file_for_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../compoents/app_bar.dart';
import '../../compoents/loading.dart';
import '../../compoents/loading/loading_file_card.dart';
import '../../compoents/open_and_download_file.dart';
import '../../models/users.dart';

class AllFileForGroupScreen extends StatelessWidget {
  final AllFileForGroupController allFileForGroupController = Get.find();
  final LoadingMessage loadingMessage = LoadingMessage();
  final SelectedUserValue = ''.obs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: BuildGroupDrawer(context, _scaffoldKey),
      appBar:
          BuildAppBar(context, true, '${allFileForGroupController.GroupName}'),
      body: SafeArea(
          child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            RefreshGroupScreen();
          },
          child: Obx(() {
            return Column(
              children: [
                allFileForGroupController.ChickMode.value
                    ? AnimatedContainer(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xffDBC8AC),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'You have selected ${allFileForGroupController.NumberOfCheckFile.value} files',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xffDD5353),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xffDBC8AC)),
                                    minimumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size(90, 30)),
                                    maximumSize:
                                        MaterialStateProperty.all<Size>(
                                            Size(90, 30)),
                                    textStyle:
                                        MaterialStateProperty.all<TextStyle>(
                                      TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffDD5353),
                                      ),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 2,
                                          color: Color(0xffDD5353),
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // style: ButtonStyle(
                                  //   minimumSize: MaterialStateProperty.all<Size>(Size(90, 30)),
                                  //   maximumSize: MaterialStateProperty.all<Size>(Size(90, 30)),
                                  // ),
                                  onPressed: () {
                                    SendCheckInFile(context);
                                  },
                                  child: Text(
                                    'Check in',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xffDD5353),
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    CloseSelectFilesToCheckIn();
                                  },
                                  child: Icon(
                                    Icons.close,
                                    color: Color(0xffDD5353),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: 0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xffDBC8AC),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                      ),
                Expanded(child: BuildFilesList(context)),
              ],
            );
          }),
        ),
      )),
    );
  }

  Widget BuildFilesList(BuildContext context) {
    return Obx(() {
      if (allFileForGroupController.IsLoadedFile.value) {
        if (allFileForGroupController.NumberOfFileInList.value == 0)
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
            itemCount: allFileForGroupController.NumberOfFileInList.value + 1,
            controller: allFileForGroupController.FileListController,
            itemBuilder: (context, index) {
              if (index < allFileForGroupController.NumberOfFileInList.value)
                return BuildFileCard(context, index);
              else {
                if (!allFileForGroupController.ArrivedToEndOfFilesList)
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
    var IsCheck;
    if (allFileForGroupController.ChickInFiles.contains(
        allFileForGroupController.FilesGroupList[index])) {
      IsCheck = true.obs;
    } else {
      IsCheck = false.obs;
    }
    return GestureDetector(
      onTap: () {
        OpenFile(context , allFileForGroupController.FilesGroupList[index].path, allFileForGroupController.FilesGroupList[index].id);
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
          allFileForGroupController.FilesGroupList[index].path,
          style: TextStyle(
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: !allFileForGroupController.ChickMode.value
            ? PopupMenuButton<Widget>(
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
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        )
                      ],
                    ),
                    onTap: () {
                      Future.delayed(
                          Duration(seconds: 0),
                          () async => DeleteFileFromGroup(
                              context,
                              allFileForGroupController
                                  .FilesGroupList[index].id));
                    },
                  ),
                ],
              )
            : Obx(() {
                return GestureDetector(
                  onTap: () {
                    IsCheck(!IsCheck.value);
                    if (IsCheck.value) {
                      allFileForGroupController.ChickInFiles.add(
                          allFileForGroupController.FilesGroupList[index]);
                    } else {
                      allFileForGroupController.ChickInFiles.remove(
                          allFileForGroupController.FilesGroupList[index]);
                    }
                    allFileForGroupController.NumberOfCheckFile(
                        allFileForGroupController.ChickInFiles.length);
                  },
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Color(0xffDD5353)),
                      borderRadius: BorderRadius.circular(6),
                      color:
                          IsCheck.value ? Color(0xffDD5353) : Color(0xffeadcd0),
                    ),
                    child: Icon(
                      Icons.check,
                      color: !IsCheck.value
                          ? Color(0xffDD5353)
                          : Color(0xffeadcd0),
                      size: 15,
                    ),
                  ),
                );
              }),
      ),
    );
  }

  Widget BuildGroupDrawer(
      BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                gradient: LinearGradient(colors: [
                  Color(0xffB73E3E),
                  Color(0xffDD5353),
                  Color(0xffe78383)
                ])),
            child: Center(
              child: Text(
                allFileForGroupController.GroupName,
                style: TextStyle(fontSize: 30, color: Color(0xffDBC8AC)),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0),
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BuildDrawerListItem(context, Icons.person_add, 'Add member',
                    () {
                  AddMemberToGroup(context);
                }),
                BuildDrawerListItem(context, Icons.people, 'Show Group members',
                    () {
                  DeleteMemberFromGroup(context, _scaffoldKey);
                }),
                BuildDrawerListItem(
                    context, Icons.delete_forever_rounded, 'Delete groups', () {
                  DeleteTheGroup(context);
                }),
                BuildDrawerListItem(
                    context, Icons.library_add_check_rounded, 'Check files',
                    () {
                  ActiveTheChickMode(context, _scaffoldKey);
                }),
                BuildDrawerListItem(
                    context, Icons.fact_check_rounded, 'My check in files',
                        () {
                      GoToUserCheckFilesScreen( _scaffoldKey);
                    }),
                // BuildDrawerListItem(context),
                // BuildDrawerListItem(context),
                // BuildDrawerListItem(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget BuildDrawerListItem(BuildContext context, IconData ListTileIcon,
      String Title, void Function()? OnTap) {
    return GestureDetector(
      onTap: () {
        OnTap!();
      },
      child: ListTile(
        leading: Icon(
          ListTileIcon,
          size: 30,
        ),
        title: Text(
          Title,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  void AddMemberToGroup(BuildContext context) async {
    BuildUsersSelectionAlert(context);
    if (allFileForGroupController.NumberOfUsersInList.value == 0) {
      allFileForGroupController.GetNewSysUsers();
    }
  }

  BuildUsersSelectionAlert(BuildContext context) {
    Alert(
        context: context,
        content: Obx(() {
          if (allFileForGroupController.NumberOfUsersInList.value == 0)
            return LinearProgressIndicator(
              color: Color(0xffDD5353),
            );
          else
            return Container(
              padding: EdgeInsets.all(8),
              width: MediaQuery.of(context).size.width * .8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 2, color: Color(0xffDD5353))),
              child: DropdownMenuItem(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    hint: Text('Select user ... '),
                    underline: Divider(
                      thickness: 1,
                    ),
                    isExpanded: true,
                    menuMaxHeight: 150,
                    dropdownColor: Color(0xffDBC8AC),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    alignment: AlignmentDirectional.centerStart,
                    items:
                        allFileForGroupController.SysUsersList.map((User user) {
                      return DropdownMenuItem(
                        value: user.name,
                        child: Text(user.name),
                      );
                    }).toList(),
                    icon: Icon(Icons.arrow_drop_down_outlined),
                    value: SelectedUserValue.value == ''
                        ? null
                        : SelectedUserValue.value,
                    onChanged: (value) async {
                      print(value);
                      SelectedUserValue(value);
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
            child: Text(
              'Add',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              AddTheUserToGroup(context);
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
            side: BorderSide(color: Color(0xffDBC8AC)
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

  void AddTheUserToGroup(BuildContext context) async {
    int UserId;
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    if (SelectedUserValue.value != '')
      UserId = allFileForGroupController.SysUsersList.where(
          (element) => element.name == SelectedUserValue.value).first.id;
    else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          'Select a user',
          true);
      return;
    }
    await allFileForGroupController.AddSelectedUserToGroup(UserId);
    if (allFileForGroupController.State) {
      Navigator.of(context).pop();
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allFileForGroupController.Message,
          true);
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allFileForGroupController.Message,
          true);
    }
  }

  void DeleteFileFromGroup(BuildContext context, int FileId) async {
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await allFileForGroupController.SendDeleteFile(FileId);
    if (allFileForGroupController.State) {
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allFileForGroupController.Message,
          true);
      RefreshGroupScreen();
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allFileForGroupController.Message,
          true);
    }
  }

  void DeleteTheGroup(BuildContext context) async {
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await allFileForGroupController.SendDeleteGroup();
    if (allFileForGroupController.State) {
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allFileForGroupController.Message,
          true);
      Get.offNamed('/all_group_for_user');
      RefreshGroupScreen();
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allFileForGroupController.Message,
          true);
    }
  }

  void DeleteMemberFromGroup(
      BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) async {
    _scaffoldKey.currentState!.closeEndDrawer();
    Get.toNamed('/all_user_of_group', arguments: {
      'group_id': allFileForGroupController.GroupId,
      'group_name': allFileForGroupController.GroupName
    });
  }

  void ActiveTheChickMode(
      BuildContext context, GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState!.closeEndDrawer();
    // allFileForGroupController.ChickInFiles.clear();
    allFileForGroupController.ChickMode(true);
  }

  void SendCheckInFile(BuildContext context) async {
    if (allFileForGroupController.ChickInFiles.length == 0) {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          'Check in files pleas',
          true);
      return;
    }
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await allFileForGroupController.SendCheckInFilesList();
    if (allFileForGroupController.State) {
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allFileForGroupController.Message,
          true);
      CloseSelectFilesToCheckIn();
    } else {
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allFileForGroupController.Message,
          true);
    }
  }

  void CloseSelectFilesToCheckIn() {
    allFileForGroupController.ChickInFiles.clear();
    allFileForGroupController.NumberOfCheckFile(0);
    allFileForGroupController.ChickMode(false);
  }

  void GoToUserCheckFilesScreen( GlobalKey<ScaffoldState> _scaffoldKey){
    _scaffoldKey.currentState!.closeEndDrawer();
    Get.toNamed('/user_check_in_file_in_group',arguments: {'group_name':allFileForGroupController.GroupName , 'group_id':allFileForGroupController.GroupId});
  }

  void OpenFile(BuildContext context,String FileName,int FileId)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await allFileForGroupController.GetFilePath(FileId);
    if(allFileForGroupController.State){
      OpenTheFile(allFileForGroupController.PathReadFile!, FileName);
      loadingMessage.Dismiss();
    }else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          allFileForGroupController.Message,
          true);
    }
  }


  void RefreshGroupScreen() {
    allFileForGroupController.Refresh();
  }
}
