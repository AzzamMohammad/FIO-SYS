import 'dart:convert';

Groups groupsFromJson(String str) => Groups.fromJson(json.decode(str));

String groupsToJson(Groups data) => json.encode(data.toJson());

class Groups {
  Groups({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  dynamic errNum;
  String msg;
  dynamic data;

  factory Groups.fromJson(Map<String, dynamic> json) => Groups(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data:json["Data"] != null? Data.fromJson(json["Data"]):[],
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
  List<Grope> data;
  int lastPage;
  dynamic nextPageUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<Grope>.from(json["data"].map((x) => Grope.fromJson(x))),
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

class Grope {
  Grope({
    required this.id,
    required this.delete,
    required this.userId,
    required this.groupId,
    required this.createdAt,
    required this.updatedAt,
    required this.group,
  });

  int id;
  int delete;
  int userId;
  int groupId;
  DateTime createdAt;
  DateTime updatedAt;
  Grp group;

  factory Grope.fromJson(Map<String, dynamic> json) => Grope(
    id: json["id"],
    delete: json["delete"],
    userId: json["user_id"],
    groupId: json["group_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    group: Grp.fromJson(json["group"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "delete": delete,
    "user_id": userId,
    "group_id": groupId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "group": group.toJson(),
  };
}

class Grp {
  Grp({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Grp.fromJson(Map<String, dynamic> json) => Grp(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
