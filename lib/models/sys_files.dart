import 'dart:convert';

SysFiles sysFilesFromJson(String str) => SysFiles.fromJson(json.decode(str));

String sysFilesToJson(SysFiles data) => json.encode(data.toJson());

class SysFiles {
  SysFiles({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  dynamic errNum;
  String msg;
  dynamic data;

  factory SysFiles.fromJson(Map<String, dynamic> json) => SysFiles(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data:json["Data"]!=null? Data.fromJson(json["Data"]):[],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": data.toJson(),
  };
}

class Data {
  Data({
    required this.currentPage,
    required this.data,
    required this.lastPage,
    required this.nextPageUrl,
  });

  int currentPage;
  dynamic data;
  int lastPage;
  dynamic nextPageUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data:json["data"] != null? List<MyFile>.from(json["data"].map((x) => MyFile.fromJson(x))):[],
    lastPage: json["last_page"],
    nextPageUrl: json["next_page_url"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "last_page": lastPage,
    "next_page_url": nextPageUrl,
  };
}

class MyFile {
  MyFile({
    required this.id,
    required this.path,
    required this.delete,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  dynamic path;
  int delete;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  factory MyFile.fromJson(Map<String, dynamic> json) => MyFile(
    id: json["id"],
    path: json["path"],
    delete: json["delete"] != null  ?json["delete"]:0,
    userId:json["user_id"] != null  ?json["user_id"]:0 ,
    createdAt:json["created_at"]!=null? DateTime.parse(json["created_at"]):DateTime.now(),
    updatedAt: json["updated_at"]!=null? DateTime.parse(json["updated_at"]):DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "path": path,
    "delete": delete,
    "user_id": userId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
