import 'package:file_sys/compoents/loading.dart';
import 'package:file_sys/modules/users_group/users_group_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersGroupScreen extends StatelessWidget {
  final UsersGroupController usersGroupController = Get.find();
  final LoadingMessage loadingMessage = LoadingMessage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          usersGroupController.GroupName,
          style: TextStyle(fontSize: 20),
          maxLines: 1,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            RefreshScreen();
          },
          color: Color(0xffDD5353),
          child: BuildUsersGroupScrollBar(context),
        ),
      ),
    );
  }

  Widget BuildUsersGroupScrollBar(BuildContext context){
    return Obx((){
      if(!usersGroupController.IsLoaded.value){
        return Text('loading');
      }else{
        if(!usersGroupController.State){
          loadingMessage.DisplayError(
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor,
              usersGroupController.Message,
              true);
        }
        if(usersGroupController.UsersOfGroupList.isEmpty){
          return SingleChildScrollView(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .4),
            physics:  AlwaysScrollableScrollPhysics(),
            child: Center(
              child:Text('No Memeber',style: TextStyle(color: Color(0xffDD5353),fontSize: 18),),
            ),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics:  AlwaysScrollableScrollPhysics(),
          itemCount: usersGroupController.UsersOfGroupList.length,
          itemBuilder: (context,index){
            return BuildUserGroupBar(context,index);
          },
        );
      }
    });
  }
  Widget BuildUserGroupBar(BuildContext context ,int index){
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xffDD5353),
          borderRadius: BorderRadius.circular(80),
          image: DecorationImage(
            image: AssetImage(
              'assets/images/father.png',
            ),
            fit: BoxFit.contain
          )
        ),
      ),
      title: Text(
        usersGroupController.UsersOfGroupList[index].user.name,
        style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
          usersGroupController.UsersOfGroupList[index].user.role == 2 ? 'User':'Admin',
        style:TextStyle(color: Colors.black),
      ),
      trailing: PopupMenuButton<Widget>(
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
                      () async =>DeleteTheMember(context,usersGroupController.UsersOfGroupList[index].user.id)

              );
            },
          ),
        ],
      ),
    );
  }
  void DeleteTheMember(BuildContext context,int UserId)async{
    loadingMessage.DisplayLoading(
      Theme.of(context).scaffoldBackgroundColor,
      Theme.of(context).primaryColor,
    );
    await usersGroupController.DeleteTheUser(UserId);
    if(usersGroupController.State){
      loadingMessage.DisplaySuccess(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          usersGroupController.Message,
          true);
      RefreshScreen();
    }
    else{
      loadingMessage.DisplayError(
          Theme.of(context).scaffoldBackgroundColor,
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColor,
          usersGroupController.Message,
          true);
    }
  }
  void RefreshScreen(){
    usersGroupController.Refresh();
  }
}
