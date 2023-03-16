import 'dart:convert';

SysGroups sysGroupsFromJson(String str) => SysGroups.fromJson(json.decode(str));

String sysGroupsToJson(SysGroups data) => json.encode(data.toJson());

class SysGroups {
  SysGroups({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  Data data;

  factory SysGroups.fromJson(Map<String, dynamic> json) => SysGroups(
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
    data:json["data"] != null ? List<Group>.from(json["data"].map((x) => Group.fromJson(x))):[],
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

class Group {
  Group({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
