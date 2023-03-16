import 'package:file_sys/models/groups.dart';
import 'package:http/http.dart' as http;

import '../../config/server_config.dart';


class AllGroupForUserServer{
  bool IsLoaded = false;
  String Message = '';
  String NextPage = '';
  int CurrentPage = 0;
  int LastPage = 0;

  var GetUserGroupsRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetUserGroupsURL);

  Future<List<Grope>> GetNewUserGroupList(String Token , String NextPage) async{
    IsLoaded = false;
    var PageUrl ;
    if(NextPage == '')
      PageUrl = GetUserGroupsRoute;
    else
      PageUrl = NextPage;
    // try{
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
    // }catch(e){
    //   print(e);
    //   return [];
    // }
  }

}