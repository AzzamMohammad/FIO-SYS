import 'dart:convert';

import 'package:file_sys/models/person.dart';
import 'package:http/http.dart' as http;

import '../../config/server_config.dart';
import '../../storage/shared_data.dart';

class LoginServer {
  var loginRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.LoginURL);
  String message = '';

  Future<bool> SendLoginRequest(Person person  , SharedData sharedData)async{
    try{
      var jsonResponse = await http.post(loginRoute,
          headers: {
            'Accept':'application/json',
          },
          body: {
            'email' : '${person.Email}',
            'password' : '${person.Password}',
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