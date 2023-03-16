import 'dart:convert';

import '../../config/server_config.dart';
import '../../storage/shared_data.dart';
import 'package:http/http.dart' as http;

class ChangPortServer{
  String Message = '';

  SharedData sharedAppData = SharedData();
  var ChangPUSHER_APP_IDRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.ChangPUSHER_APP_IDAdminURL);

  Future<bool> SendPUSHER_APP_ID(int PUSHER_APP_ID)async{
    String Token = await sharedAppData.GetToken();
    try{
      var jsonResponse = await http.post(ChangPUSHER_APP_IDRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
          body: {
            'PUSHER_APP_ID':'${PUSHER_APP_ID}',
          }
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        Message = response['msg'];
        if(response['status'] == true){
          return true;
        }else{
          return false;
        }
      }else{
        Message = 'Connection error';
        return false;
      }
    }catch(e){
      print(e);
      Message = 'Connection error';
      return false;
    }

  }
}