import 'dart:convert';

FileInfoApi fileInfoApiFromJson(String str) => FileInfoApi.fromJson(json.decode(str));

String fileInfoApiToJson(FileInfoApi data) => json.encode(data.toJson());

class FileInfoApi {
  FileInfoApi({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  FileInfo? data;

  factory FileInfoApi.fromJson(Map<String, dynamic> json) => FileInfoApi(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data:FileInfo.fromJson(json["Data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": data?.toJson(),
  };
}

class FileInfo {
  FileInfo({
   required this.id,
    required this.fileId,
    required this.userId,
    required this.user,
  });

  int id;
  int fileId;
  int userId;
  User user;

  factory FileInfo.fromJson(Map<String, dynamic> json) => FileInfo(
    id: json["id"],
    fileId: json["file_id"],
    userId: json["user_id"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "file_id": fileId,
    "user_id": userId,
    "user": user.toJson(),
  };
}

class User {
  User({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
