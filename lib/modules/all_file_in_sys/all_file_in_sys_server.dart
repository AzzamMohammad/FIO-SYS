import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/server_config.dart';
import '../../models/sys_admin_file.dart';


class AllFileInSysServer{
  bool IsLoaded = false;
  bool UsersIsLoaded = false;
  String Message = '';
  String NextPage = '';
  int CurrentPage = 0;
  int LastPage = 0;

  var GetAllFilesForAdminRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetAllFilesForAdminURL);
  var GetFilePathRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFilePathURL);

  Future<List<FileSys>> GetNewFilesGroupList(String Token , String NextPage) async{
    IsLoaded = false;
    var PageUrl ;
    if(NextPage == '')
      PageUrl = GetAllFilesForAdminRoute;
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
        SysAdminFile response = sysAdminFileFromJson(jsonResponse.body);

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