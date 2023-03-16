import 'package:shared_preferences/shared_preferences.dart';
class SharedData{
  ///////////// token
   Future<void> SaveToken(String Token)async{
    final data = await SharedPreferences.getInstance();
    data.setString('token', Token);
  }

  Future<String> GetToken()async{
    final data = await SharedPreferences.getInstance();
    String? token = data.getString('token');
    return token ?? '';
  }
  Future<bool> DeleteToken ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('token'))
      return true;
    return false;
  }


  /////////////////// email
  Future<void> SaveEmail(String Email)async{
    final data = await SharedPreferences.getInstance();
    data.setString('email', Email);
  }

  Future<String> GetEmail()async{
    final data = await SharedPreferences.getInstance();
    String? Email = data.getString('email');
    return Email ?? '';
  }
  Future<bool> DeleteEmail ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('email'))
      return true;
    return false;
  }

  /////////////////// password
  Future<void> SavePassword(String password)async{
    final data = await SharedPreferences.getInstance();
    data.setString('password', password);
  }

  Future<String> GetPassword()async{
    final data = await SharedPreferences.getInstance();
    String? password = data.getString('password');
    return password ?? '';
  }
  Future<bool> DeletePassword ()async{
    final data = await SharedPreferences.getInstance();
    if(await data.remove('password'))
      return true;
    return false;
  }

}