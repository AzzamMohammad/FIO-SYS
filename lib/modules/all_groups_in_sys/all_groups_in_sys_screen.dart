import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../compoents/BuildDrawer.dart';
import '../../compoents/app_bar.dart';
import '../../compoents/loading/loading_group_list.dart';
import 'all_groups_in_sys_controller.dart';

class AllGroupsInSysScreen extends StatelessWidget {

  final AllGroupsInSysController allGroupsInSysController = Get.find();
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
      if(allGroupsInSysController.IsLoaded.value){
        if(allGroupsInSysController.NumberOfMemberInList.value == 0)
          return Column(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .4),
                physics:  AlwaysScrollableScrollPhysics(),
                child: Center(
                  child:Text(allGroupsInSysController.Message,style: TextStyle(color: Color(0xffDD5353),fontSize: 18),),
                ),
              )
            ],
          );
        else{
          return ListView.builder(
            controller: allGroupsInSysController.GroupListController,
            itemCount: allGroupsInSysController.NumberOfMemberInList.value+1,
            shrinkWrap: true,
            primary: false,
            physics:  AlwaysScrollableScrollPhysics(),
            itemBuilder:(context,index){
              if(index< allGroupsInSysController.NumberOfMemberInList.value)
                return BuildGroupBar(context,index);
              else{
                if(!allGroupsInSysController.ArrivedToEndOfList){
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
        Get.toNamed('/group_files_for_admin',arguments: {
          'group_id': allGroupsInSysController.ListOfSysGroup[index].id,
          'group_name':allGroupsInSysController.ListOfSysGroup[index].name
        });
      },
      child: ListTile(
        leading: Icon(Icons.groups,size: 35,),
        title: Text(allGroupsInSysController.ListOfSysGroup[index].name,style: TextStyle(fontSize: 20),),
      ),
    );
  }

  void RefreshScreen(){
    allGroupsInSysController.Refresh();
  }
}
