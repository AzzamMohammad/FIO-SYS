import 'dart:convert';
import 'dart:io';

import 'package:file_sys/models/file_info.dart';
import 'package:http/http.dart' as http;

import '../../config/server_config.dart';
import '../../models/groups.dart';
import '../../models/sys_files.dart';

class HomeServer{
  String Message = '';
  bool IsLoaded = false;
  String NextPageUrl = '';
  int CurrentPage = 0;
  int LastPage = 0;
  bool StateGetInfo = false;
  var GetUserFilesRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetUserFilesURL);
  var AddUserFilesRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.AddUserFilesURL);
  var GetUserGroupsRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetUserGroupsURL);
  var AddFileToGroupRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.AddFileToGroupURL);
  var DeleteUserFileRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.DeleteUserFileURL);
  var FileInfoRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.FileInfoURL);
  var GetFilePathRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFilePathURL);

  Future<List<MyFile>> GetNewUserFiles(String Token , String NextPage) async{
    IsLoaded = false;
    var PageUrl ;
    if(NextPage == '')
      PageUrl = GetUserFilesRoute;
    else
      PageUrl = Uri.parse(NextPage);
    try{
      var jsonResponse = await http.get(PageUrl,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          }
      );
      if(jsonResponse.statusCode == 200){

        SysFiles response = sysFilesFromJson(jsonResponse.body);
        IsLoaded = true;
        Message = response.msg;
        if(response.status == true){

          if(response.data.nextPageUrl != null)
            NextPageUrl = response.data.nextPageUrl;
          else
            NextPageUrl = '';
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

  Future<bool> SendFile( String Token, File? NewFile) async {
    try {
      var JsonResponse = http.MultipartRequest(
          'post', AddUserFilesRoute);
      JsonResponse.headers['auth-token'] = '${Token}';
      JsonResponse.headers['Accept'] = 'application/json';
      if (NewFile != null) {
        var SendFile = http.MultipartFile.fromBytes(
            'path', NewFile.readAsBytesSync(),
            filename: NewFile.path);
        JsonResponse.files.add(SendFile);
      }
      var request = await JsonResponse.send();
      if (request.statusCode == 200) {
        var ResponseData = await request.stream.toBytes();
        var Result = String.fromCharCodes(ResponseData);
        var Response = jsonDecode(Result);
        IsLoaded = true;
        Message = Response['msg'];
        if (Response['status'] == true)
          return true;
        return false;
      }
      Message = 'Connection error';
      return false;
    } catch (e) {
      print(e);
      Message = 'Connection error';
      return false;
    }
  }


  Future<List<Grope>> GetNewUserGroupList(String Token , String NextPage) async{
    IsLoaded = false;
    var PageUrl ;
    if(NextPage == '')
      PageUrl = GetUserGroupsRoute;
    else
      PageUrl = NextPage;
    try{
      var jsonResponse = await http.get(PageUrl,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          }
      );
      if(jsonResponse.statusCode == 200){

        Groups response = groupsFromJson(jsonResponse.body);
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


  Future<bool> SendFileToGroup(String Token ,int FileId, int GroupId) async{
    IsLoaded = false;
    try{
      var jsonResponse = await http.post(AddFileToGroupRoute,
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

  Future<bool> DeleteUserFile(String Token ,int FileId) async{
    IsLoaded = false;
    try{
      var jsonResponse = await http.post(DeleteUserFileRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
        body: {
        'file_id':'${FileId}',
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

  Future<FileInfo?> GetFileInfoList(String Token , int FileId) async{

    try{
      var jsonResponse = await http.post(FileInfoRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
        body: {
        'file_id':'${FileId}'
        }
      );
      if(jsonResponse.statusCode == 200){
        print(jsonResponse.body);
      FileInfoApi response = fileInfoApiFromJson(jsonResponse.body);
        Message = response.msg;
        print(response.status);
        if(response.status ){
          Message = 'This file is free';

          StateGetInfo = true;
          return response.data;
        }else{
          StateGetInfo = false;
          return null;
        }

      }else{
        Message = 'Connection error';
        StateGetInfo = false;
        return null;
      }
    }catch(e){
      Message = 'Connection error';
      StateGetInfo = false;
      print(e);
      return null;
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