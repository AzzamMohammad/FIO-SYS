import 'dart:convert';

GroupUsers groupUsersFromJson(String str) => GroupUsers.fromJson(json.decode(str));

String groupUsersToJson(GroupUsers data) => json.encode(data.toJson());

class GroupUsers {
  GroupUsers({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  dynamic data;

  factory GroupUsers.fromJson(Map<String, dynamic> json) => GroupUsers(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data: json["Data"] != null ? List<GroupUser>.from(json["Data"].map((x) => GroupUser.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class GroupUser {
  GroupUser({
    required this.id,
    required this.userId,
    required this.user,
  });

  int id;
  int userId;
  User user;

  factory GroupUser.fromJson(Map<String, dynamic> json) => GroupUser(
    id: json["id"],
    userId: json["user_id"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "user": user.toJson(),
  };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.role,
  });

  int id;
  String name;
  int role;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "role": role,
  };
}
