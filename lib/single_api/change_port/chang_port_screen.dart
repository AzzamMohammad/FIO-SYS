import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../compoents/loading.dart';
import 'chang_port_server.dart';

ChangPortServer changPortServer = ChangPortServer();
void BuildChangePort(BuildContext context){
  int Port = -7;
  Alert(
      context: context,
      content:TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: 1,
        decoration: InputDecoration(
          labelText: "PUSHER_APP_ID",
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Enter Your new PUSHER_APP_ID';
          } else {
            return null;
          }
        },
        onChanged: (value) {
          Port = int.parse(value) ;
        },
      ),

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
            SendPUSHER_APP_IDToAdd(context,Port);
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


void SendPUSHER_APP_IDToAdd(BuildContext context , int? port)async{
  final LoadingMessage loadingMessage = LoadingMessage();
  if(port == -7){
    loadingMessage.DisplayError(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        'Enter the new PUSHER_APP_ID',
        true);
    return ;
  }
  loadingMessage.DisplayLoading(
    Theme.of(context).scaffoldBackgroundColor,
    Theme.of(context).primaryColor,
  );
  bool State = await changPortServer.SendPUSHER_APP_ID(port!);
  if(State){
    Navigator.of(context).pop();
    loadingMessage.DisplaySuccess(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        changPortServer.Message,
        true);

  }
  else{
    loadingMessage.DisplayError(
        Theme.of(context).scaffoldBackgroundColor,
        Theme.of(context).primaryColor,
        Theme.of(context).primaryColor,
        changPortServer.Message,
        true);
  }
}