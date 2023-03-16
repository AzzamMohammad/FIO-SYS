import 'package:file_sys/modules/all_group_for_user/all_group_for_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../compoents/BuildDrawer.dart';
import '../../compoents/app_bar.dart';
import '../../compoents/loading/loading_group_list.dart';

class AllGroupForUserScreen extends StatelessWidget {
  final AllGroupForUserController allGroupForUserController = Get.find();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      endDrawer: BuildDrawer(context),
      appBar: BuildAppBar(context, false, 'All group'),
      body: SafeArea(
          child: RefreshIndicator(
            onRefresh: ()async{
              RefreshScreen();
            },
            color: Color(0xffDD5353),
              child: BuildGroupListView(context),
          ),
      ),
    );
  }

  Widget BuildGroupListView(BuildContext context){
    return Obx((){
      if(allGroupForUserController.IsLoaded.value){
        if(allGroupForUserController.NumberOfMemberInList.value == 0)
          return Column(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .4),
              physics:  AlwaysScrollableScrollPhysics(),
              child: Center(
                child:Text(allGroupForUserController.Message,style: TextStyle(color: Color(0xffDD5353),fontSize: 18),),
              ),
            )
          ],
        );
        else{
          return ListView.builder(
            controller: allGroupForUserController.GroupListController,
            itemCount: allGroupForUserController.NumberOfMemberInList.value+1,
            shrinkWrap: true,
            primary: false,
            physics:  AlwaysScrollableScrollPhysics(),
            itemBuilder:(context,index){
              if(index< allGroupForUserController.NumberOfMemberInList.value)
                return BuildGroupBar(context,index);
              else{
                if(!allGroupForUserController.ArrivedToEndOfList){
                  return SingleChildScrollView(
                    physics:  AlwaysScrollableScrollPhysics(),
                    child:  LoadingGroupCard(context)
                  );
                }
                return Container();
              }
            },
          );
        }
      }else{
        return LoadingGroupCard(context);
      }
    });
  }

  Widget BuildGroupBar(BuildContext context , int index){
    return GestureDetector(
      onTap:(){
        Get.toNamed('/all_file_for_group',arguments: {
          'group_id': allGroupForUserController.ListOfUserGroup[index].group.id,
          'group_name':allGroupForUserController.ListOfUserGroup[index].group.name
        });
      },
      child: ListTile(
        leading: Icon(Icons.groups,size: 35,),
        title: Text(allGroupForUserController.ListOfUserGroup[index].group.name,style: TextStyle(fontSize: 20),),
      ),
    );
  }

  void RefreshScreen(){
    allGroupForUserController.Refresh();
  }
}
