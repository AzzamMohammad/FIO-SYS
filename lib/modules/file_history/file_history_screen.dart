import 'package:file_sys/modules/file_history/file_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../compoents/loading/load_history_card.dart';
class FileHistoryScreen extends StatelessWidget {
  final FileHistoryController fileHistoryController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(fileHistoryController.FileName,style: TextStyle(fontSize: 18,overflow: TextOverflow.ellipsis),maxLines: 1,),

      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async{
            RefreshHistoryScreen();
          },
          child: BuildHistoryList()
        ),
      ),
    );
  }
  Widget BuildHistoryList(){
    return Obx((){
      return Scrollbar(
        thickness: 7,
        radius: Radius.circular(7),
        child: ListView.builder(
          padding: EdgeInsets.only(left: 8,right: 8),
          controller: fileHistoryController.HistoryListController,
          itemCount: fileHistoryController.NumberOfItemInList.value + 1,
          physics:  AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context,index){
            if(index < fileHistoryController.NumberOfItemInList.value)
              return BuildHistoryCard(context,index);
            else{
              if(!fileHistoryController.ArrivedToEndOfList)
                return LoadHistoryCard(context);
              return Container();
            }
          },
        ),
      );
    }
    );
  }

  Widget BuildHistoryCard(BuildContext context , int index){
    return Padding(
      padding:  EdgeInsets.only(top: 8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20),),
          color: Color(0xffDBC8AC),
        ),
        width: MediaQuery.of(context).size.width,
        height: 70,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${fileHistoryController.HistoryOfFileList[index].operation}',
              style: TextStyle(overflow: TextOverflow.ellipsis,fontSize: 18,fontWeight: FontWeight.bold , color: Color(0xffDD5353)),
              maxLines: 2,
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .4,
                  child: Text(
                    '${fileHistoryController.HistoryOfFileList[index].user.name}',
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .12,
                  child: Text(
                    fileHistoryController.HistoryOfFileList[index].user.role == 2? 'User':'Admin',
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
                Container(
                  // padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width *.3 ,
                  child:  Text('${DateFormat('yyyy/MM/dd hh:mm:ss').format(fileHistoryController.HistoryOfFileList[index].date)}', style: TextStyle(fontSize:12,overflow: TextOverflow.ellipsis),maxLines: 1,),
                )
              ],
            ),

          ],
        ),
      ),
    );
  }

  void RefreshHistoryScreen(){
    fileHistoryController.Refresh();
  }
}
