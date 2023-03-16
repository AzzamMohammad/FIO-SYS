import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
// import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';

File? file;

void OpenTheFile(String FileURL,String FileName)async{
   file = await DownloadFile(FileURL,FileName);
  if(file == null)
    return ;

  OpenFile.open(file!.path);
}

Future<File?> DownloadFile(String FileURL , String FileName)async{
  try{
    final AppStorage = await getApplicationDocumentsDirectory();
    final file = File('${AppStorage.path}/$FileName');
    var FileRoute = Uri.parse(FileURL);
    var response = await http.get(
      FileRoute,
      headers: {
        'Keep-Alive':'${true}',
        'Accept': 'application/json',
      }
    );
    final fil = file.openSync(mode: FileMode.write);
    fil.writeFromSync(response.bodyBytes);
    await fil.close();
    return file;
  }catch(e){
    print(e);
    return null;
  }
}

saveFile(){
  OpenFile.open(file!.path);
}