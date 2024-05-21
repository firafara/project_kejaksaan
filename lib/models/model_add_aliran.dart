import 'dart:convert';

ModelAddAliran modelAddAliranFromJson(String str) => ModelAddAliran.fromJson(json.decode(str));

String modelAddAliranToJson(ModelAddAliran data) => json.encode(data.toJson());

class ModelAddAliran {
  bool isSuccess;
  String message;

  ModelAddAliran({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddAliran.fromJson(Map<String, dynamic> json) => ModelAddAliran(
    isSuccess: json["isSuccess"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
