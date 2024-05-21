
import 'dart:convert';

ModelEditAliran modelEditAliranFromJson(String str) => ModelEditAliran.fromJson(json.decode(str));

String modelEditPegawaiToJson(ModelEditAliran data) => json.encode(data.toJson());

class ModelEditAliran {
  bool isSuccess;
  String message;

  ModelEditAliran({
    required this.isSuccess,
    required this.message,
  });

  factory ModelEditAliran.fromJson(Map<String, dynamic> json) => ModelEditAliran(
    isSuccess: json["isSuccess"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
