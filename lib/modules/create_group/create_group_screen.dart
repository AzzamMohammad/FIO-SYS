import 'package:file_sys/compoents/BuildDrawer.dart';
import 'package:file_sys/modules/create_group/create_group_server.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../compoents/loading.dart';


CreateGroupServer createGroupServer = CreateGroupServer();
void BuildAddGroupBar(BuildContext context){
  String GropeName = '';
  Alert(
      context: context,
      content:TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: "Group name",
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter Your Email';
          } else {
            return null;
          }
        },
        onChanged: (value) {
          GropeName = value;
        },
      ),

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
            SendGroupNameToAdd(context,GropeName);
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


void SendGroupNameToAdd(BuildContext context , String GroupName)async{
  final LoadingMessage loadingMessage = LoadingMessage();
  if(GroupName == ''){
    loadingMessage.DisplayError(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        'Enter the name of group',
        true);
    return ;
  }
  loadingMessage.DisplayLoading(
    Theme.of(context).scaffoldBackgroundColor,
    Theme.of(context).primaryColor,
  );
  bool State = await createGroupServer.SendGroupName(GroupName);
  if(State){
    Navigator.of(context).pop();
    loadingMessage.DisplaySuccess(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        createGroupServer.Message,
        true);

  }
  else{
    loadingMessage.DisplayError(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        createGroupServer.Message,
        true);
  }
}