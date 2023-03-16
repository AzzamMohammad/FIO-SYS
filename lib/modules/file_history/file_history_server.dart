import 'package:http/http.dart' as http;

import '../../config/server_config.dart';
import '../../models/history_of_file.dart';

class FileHistoryServer{
  String Message = '';
  bool IsLoaded = false;
  String NextPageUrl = '';
  int CurrentPage = 0;
  int LastPage = 0;
  var GetFileHistoryRoute = Uri.parse(ServerConfig.ServerDomain + ServerConfig.GetFileHistoryURL);

  Future<List<HistoryData>> GetNewHistoryFile(String Token , int FileId , String NextPageUrl)async{
    IsLoaded = false;
    var PageUrl ;
    if(NextPageUrl == '')
      PageUrl = GetFileHistoryRoute;
    else
      PageUrl = Uri.parse(NextPageUrl);
    // try{
      var jsonResponse = await http.post(PageUrl,
          headers: {
            'auth-token':'${Token}',
            'Accept': 'application/json',
          },
        body: {
          'file_id':'${FileId}'
        }
      );
      if(jsonResponse.statusCode == 200){

        HistoryOfFile response = historyOfFileFromJson(jsonResponse.body);
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
    // }catch(e){
    //   print(e);
    //   return [];
    // }
  }

}