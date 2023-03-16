import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/server_config.dart';
import '../../models/group_users.dart';

class UsersGroupServer{
  String Message = '';
  bool State = false;
  bool IsLoaded = false;
  var GetUsersOfGroupRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetUsersOfGroupURL);
  var DeleteUsersFromGroupRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.DeleteUsersFromGroupURL);
  Future<List<GroupUser>> GetUsersOfGroup(String Token , int GroupId)async{
    try{
      var jsonResponse = await http.post(GetUsersOfGroupRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
          body: {
            'group_id' : '${GroupId}'
          }
      );
      if(jsonResponse.statusCode == 200){
        GroupUsers response = groupUsersFromJson(jsonResponse.body);
        IsLoaded = true;
        Message = response.msg;
        if(response.status == true){
          State = true;
          return response.data;
        }else{
          State = false;
          return [];
        }
      }else{
        Message = 'Connection error';
        State = false;
        return [];
      }
    }catch(e){
      Message = 'Connection error';
      print(e);
      State = false;
      return [];
    }
  }

  Future<bool> DeleteTheUser(String Token , int GroupId , int UserId)async{
    try{
      var jsonResponse = await http.post(DeleteUsersFromGroupRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
          body: {
            'group_id' : '${GroupId}',
            'user_id' : '${UserId}',
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
      Message = 'Connection error';
      print(e);
      return false;
    }
  }
}