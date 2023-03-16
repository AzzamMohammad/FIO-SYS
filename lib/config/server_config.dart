class ServerConfig{

  // static const ServerDomain = 'http://192.168.114.230:8000';
  // static const ServerDomain = 'http://192.168.43.34:8000';
  static const ServerDomain = 'http://10.0.2.2:8000';

  // auth
  static const RegisterURL = '/api/register';
  static const LoginURL = '/api/login';
  static const LogoutURL = '/api/Logout';

  // home
  static const GetUserFilesURL = '/api/getMyFile';
  static const AddUserFilesURL = '/api/add/file';
  static const AddFileToGroupURL = '/api/AddFileToGroup';
  static const DeleteUserFileURL = '/api/delete/file';
  static const FileInfoURL = '/api/getStateFile';
  static const GetFilePathURL = '/api/readFile';
  static const GetFileHistoryURL = '/api/getHistory';

  // group
  static const GetUserGroupsURL = '/api/getMyGroup';
  static const AddGroupURL = '/api/CreateGroup';
  static const GetUsersOfGroupURL = '/api/getAllUserInGroup';
  static const DeleteUsersFromGroupURL = '/api/deleteUserFromGroup';

  // all file's group
  static const GetFilesGroupURL = '/api/getGroupFile';
  static const GetUsersURL = '/api/getAllUserInSystem';
  static const DeleteFileFromGroupURL = '/api/deleteFileFromGroup';
  static const DeleteGroupURL = '/api/deleteGroup';
  static const AddUserToGroupURL = '/api/addUserToGroup';

  //Check In
  static const SendCheckInFilesListURL = '/api/check_in';
  static const GetUserCheckFilesListURL = '/api/getAllFileCheck_InGroupForUser';
  static const SaveNewFileURL = '/api/saveFile';
  static const ChickOutFileURL = '/api/check_outFile';


  // admin
  static const GetSysGroupsURL = '/api/getAllGroupInSystem';
  static const GetFileGroupsForAdminURL = '/api/getAllFileInGroup';
  static const GetAllFilesForAdminURL = '/api/getAllFileInSystem';
  static const ChangPUSHER_APP_IDAdminURL = '/api/changPUSHER_APP_ID';
  static const ChangFileNumberAdminURL = '/api/changeFileNumber';



}