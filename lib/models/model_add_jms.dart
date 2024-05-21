import 'dart:convert';

ModelAddJms modelAddJmsFromJson(String str) => ModelAddJms.fromJson(json.decode(str));

String modelAddJmsToJson(ModelAddJms data) => json.encode(data.toJson());

class ModelAddJms {
  bool isSuccess;
  String message;

  ModelAddJms({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddJms.fromJson(Map<String, dynamic> json) => ModelAddJms(
    isSuccess: json["isSuccess"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
