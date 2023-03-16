import 'package:file_sys/storage/shared_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../compoents/loading.dart';
import 'logout_server.dart';

LogoutServer logoutServer = LogoutServer();
void BuildLogoutBar(BuildContext context){
  Alert(
      context: context,
      content: Text('Are you sour'),

      buttons: [
        DialogButton(
          width: MediaQuery.of(context).size.width * .8,
          height: 50,
          child:  Text(
            'OK',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          onPressed: (){
            SendLogout(context);
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


void SendLogout(BuildContext context)async{
  SharedData sharedData = SharedData();

  final LoadingMessage loadingMessage = LoadingMessage();
  loadingMessage.DisplayLoading(
    Theme.of(context).scaffoldBackgroundColor,
    Theme.of(context).primaryColor,
  );
  bool State = await logoutServer.Logout();
  if(State){
    sharedData.DeletePassword();
    sharedData.DeleteEmail();
    sharedData.DeleteToken();
    Get.offAllNamed('/login');
    loadingMessage.DisplaySuccess(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        logoutServer.Message,
        true);

  }
  else{
    loadingMessage.DisplayError(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        logoutServer.Message,
        true);
  }
}