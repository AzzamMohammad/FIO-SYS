import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../config/server_config.dart';
import '../../models/checked_files.dart';


class UserCheckInFileInGroupServer{
  String Message = '';
  bool State = false;
  bool IsLoaded = false;
  var GetUserCheckFilesListRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetUserCheckFilesListURL);
  var GetFilePathRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFilePathURL);
  var SaveNewFileRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.SaveNewFileURL);
  var ChickOutFileRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.ChickOutFileURL);

  Future<List<CheckedFile>> GetCheckedFiles(String Token , int GroupID)async{
    try{
      var jsonResponse = await http.post(GetUserCheckFilesListRoute,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
          body: {
            'group_id' : '${GroupID}'
          }
      );
      if(jsonResponse.statusCode == 200){
        CheckedFiles response = checkedFilesFromJson(jsonResponse.body);
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

  Future<bool> ChickOutTheFile(String Token , int FileId) async{

    try{
      var jsonResponse = await http.post(ChickOutFileRoute,
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

  Future<bool> SaveTheNewFileUser( String Token, File? NewFile,int FileId) async {
    try {
      var JsonResponse = http.MultipartRequest(
          'post', SaveNewFileRoute);
      JsonResponse.headers['auth-token'] = '${Token}';
      JsonResponse.headers['Accept'] = 'application/json';
      JsonResponse.fields.addAll({
        'file_id': "${FileId}",
      });
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

}