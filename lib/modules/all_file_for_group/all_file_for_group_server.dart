import 'dart:convert';

import 'package:file_sys/models/sys_files.dart';
import 'package:file_sys/models/users.dart';
import 'package:http/http.dart' as http;

import '../../config/server_config.dart';


class AllFileForGroupServer{
  bool IsLoaded = false;
  bool UsersIsLoaded = false;
  String Message = '';
  String NextPage = '';
  int CurrentPage = 0;
  int LastPage = 0;

  var GetFilesGroupsRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFilesGroupURL);
  var DeleteFileFromGroupsRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.DeleteFileFromGroupURL);
  var DeleteGroupsRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.DeleteGroupURL);
  var GetUsersRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetUsersURL);
  var AddUserToGroupRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.AddUserToGroupURL);
  var SendCheckInFilesListRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.SendCheckInFilesListURL);
  var GetFilePathRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFilePathURL);

  Future<List<MyFile>> GetNewFilesGroupList(String Token , String NextPage , int GroupId) async{
    IsLoaded = false;
    var PageUrl ;
    if(NextPage == '')
      PageUrl = GetFilesGroupsRoute;
    else
      PageUrl = NextPage;
    try{
      var jsonResponse = await http.post(PageUrl,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
        body: {
        'group_id' : '${GroupId}'
        }
      );
      if(jsonResponse.statusCode == 200){
        SysFiles response = sysFilesFromJson(jsonResponse.body);

        IsLoaded = true;
        Message = response.msg;
        if(response.status == true){
          if(response.data.nextPageUrl != null)
            NextPage = response.data.nextPageUrl;
          else
            NextPage = '';
          CurrentPage = response.data.currentPage;
          LastPage = response.data.lastPage;
          return response.data.data;
        }else{
          return [];
        }

      }else{
        return [];
      }
    }catch(e){
      print(e);
      return [];
    }
  }

  Future<List<User>> GetNewUsersList(String Token) async{
    UsersIsLoaded = false;
    var PageUrl ;
    if(NextPage == '')
      PageUrl = GetUsersRoute;
    else
      PageUrl = NextPage;
    try{
      var jsonResponse = await http.get(PageUrl,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
      );
      if(jsonResponse.statusCode == 200){
        Users response = usersFromJson(jsonResponse.body);

        UsersIsLoaded = true;
        Message = response.msg;
        if(response.status == true){
          if(response.data.nextPageUrl != null)
            NextPage = response.data.nextPageUrl;
          else
            NextPage = '';
          CurrentPage = response.data.currentPage;
          LastPage = response.data.lastPage;
          return response.data.data;
        }else{
          return [];
        }

      }else{
        return [];
      }
    }catch(e){
      print(e);
      return [];
    }
  }

  Future<bool> DeleteFile(String Token ,int FileId,int GroupId) async{
    IsLoaded = false;
    try{
      var jsonResponse = await http.post(DeleteFileFromGroupsRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
          body: {
            'file_id':'${FileId}',
            'group_id':'${GroupId}',
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

  Future<bool> DeleteGroup(String Token ,int GroupId) async{
    IsLoaded = false;
    try{
      var jsonResponse = await http.post(DeleteGroupsRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
          body: {
            'group_id':'${GroupId}',
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

  Future<bool> AddUser(String Token ,int GroupId, int UserId) async{
    IsLoaded = false;
    try{
      var jsonResponse = await http.post(AddUserToGroupRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
          body: {
            'user_id':'${UserId}',
            'group_id':'${GroupId}',
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

  Future<bool> SendCheckInFilesList(String Token ,int GroupId, List<int> CheckInFileIdList) async{
    IsLoaded = false;
    try{
      Map<String,String> Data;
      Data = {
        'group_id':'${GroupId}',
      };
      for (int i =0 ; i< CheckInFileIdList.length ; i++){
        Data.addAll({'file_ids[${i}]':'${CheckInFileIdList[i]}'});
      }

      var jsonResponse = await http.post(SendCheckInFilesListRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
          body: Data,
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

  Future<String?> GetFilePath(String Token , int FileId) async{

    try{
      var jsonResponse = await http.post(GetFilePathRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
          body: {
            'file_id':'${FileId}'
          }
      );
      if(jsonResponse.statusCode == 200){
        var response = jsonDecode(jsonResponse.body);
        Message = response['msg'];
        if(response['status']){
          return response['Data'];
        }else{
          return null;
        }

      }else{
        Message = 'Connection error';
        return null;
      }
    }catch(e){
      Message = 'Connection error';
      print(e);
      return null;
    }
  }



}