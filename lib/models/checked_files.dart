import 'dart:convert';

CheckedFiles checkedFilesFromJson(String str) => CheckedFiles.fromJson(json.decode(str));

String checkedFilesToJson(CheckedFiles data) => json.encode(data.toJson());

class CheckedFiles {
  CheckedFiles({
    required this.status,
    required this.errNum,
    required this.msg,
    required this.data,
  });

  bool status;
  String errNum;
  String msg;
  dynamic data;

  factory CheckedFiles.fromJson(Map<String, dynamic> json) => CheckedFiles(
    status: json["status"],
    errNum: json["errNum"],
    msg: json["msg"],
    data: json["Data"] != null ?List<CheckedFile>.from(json["Data"].map((x) => CheckedFile.fromJson(x))):[],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "errNum": errNum,
    "msg": msg,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CheckedFile {
  CheckedFile({
    required this.id,
    required this.path,
  });

  int id;
  String path;

  factory CheckedFile.fromJson(Map<String, dynamic> json) => CheckedFile(
    id: json["id"],
    path: json["path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "path": path,
  };
}
