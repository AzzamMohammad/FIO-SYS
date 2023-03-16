import 'dart:convert';

HistoryOfFile historyOfFileFromJson(String str) => HistoryOfFile.fromJson(json.decode(str));

String historyOfFileToJson(HistoryOfFile data) => json.encode(data.toJson());

class HistoryOfFile {
  HistoryOfFile({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  Data data;

  factory HistoryOfFile.fromJson(Map<String, dynamic> json) => HistoryOfFile(
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
  List<HistoryData> data;
  int lastPage;
  dynamic nextPageUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<HistoryData>.from(json["data"].map((x) => HistoryData.fromJson(x))),
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

class HistoryData {
  HistoryData({
    required this.id,
    required this.operation,
    required this.date,
    required this.userId,
    required this.fileId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  int id;
  String operation;
  DateTime date;
  int userId;
  int fileId;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
    id: json["id"],
    operation: json["operation"],
    date: DateTime.parse(json["date"]),
    userId: json["user_id"],
    fileId: json["file_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "operation": operation,
    "date": date.toIso8601String(),
    "user_id": userId,
    "file_id": fileId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "user": user.toJson(),
  };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String email;
  dynamic emailVerifiedAt;
  int role;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    emailVerifiedAt: json["email_verified_at"],
    role: json["role"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "email_verified_at": emailVerifiedAt,
    "role": role,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

