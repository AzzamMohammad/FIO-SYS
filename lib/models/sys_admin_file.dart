import 'dart:convert';

SysAdminFile sysAdminFileFromJson(String str) => SysAdminFile.fromJson(json.decode(str));

String sysAdminFileToJson(SysAdminFile data) => json.encode(data.toJson());

class SysAdminFile {
  SysAdminFile({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  Data data;

  factory SysAdminFile.fromJson(Map<String, dynamic> json) => SysAdminFile(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data: Data.fromJson(json["Data"]),
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
    data:json["data"] != null ? List<FileSys>.from(json["data"].map((x) => FileSys.fromJson(x))):[],
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

class FileSys {
  FileSys({
    required this.id,
    required this.path,
  });

  int id;
  String path;

  factory FileSys.fromJson(Map<String, dynamic> json) => FileSys(
    id: json["id"],
    path: json["path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "path": path,
  };
}
