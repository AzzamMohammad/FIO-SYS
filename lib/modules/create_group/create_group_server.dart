import 'dart:convert';

import '../../config/server_config.dart';
import '../../storage/shared_data.dart';
import 'package:http/http.dart' as http;

class CreateGroupServer{
  String Message = '';

  SharedData sharedAppData = SharedData();
  var AllGroupRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.AddGroupURL);



  Future<bool> SendGroupName(String GroupName)async{
    String Token = await sharedAppData.GetToken();
    try{
      var jsonResponse = await http.post(AllGroupRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
          body: {
            'name':'${GroupName}',
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