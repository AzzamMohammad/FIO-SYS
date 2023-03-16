import 'dart:convert';

import '../../config/server_config.dart';
import '../../storage/shared_data.dart';
import 'package:http/http.dart' as http;

class SplashServer{
  var loginRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.LoginURL);
  String message = '';

  Future<bool> SendLoginRequest(String Email ,String Password  , SharedData sharedData)async{
    try{
      var jsonResponse = await http.post(loginRoute,
          headers: {
            'Accept':'application/json',
          },
          body: {
            'email' : '${Email}',
            'password' : '${Password}',
          }
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        if(response['status'] == true){
          message = response['msg'];
          sharedData.SaveToken(response['Data']['token']);
          return true;
        }
        else{
          message = response['msg'];
          return false;
        }
      }else{
        message =  'Connection error';
        return false;
      }

    }catch(e){
      message =  'Connection error';
      print(e);
      return false;
    }
  }
}