import 'dart:convert';

ModelAddPidana modelAddPidanaFromJson(String str) => ModelAddPidana.fromJson(json.decode(str));

String modelAddPidanaToJson(ModelAddPidana data) => json.encode(data.toJson());

class ModelAddPidana {
  bool isSuccess;
  String message;

  ModelAddPidana({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddPidana.fromJson(Map<String, dynamic> json) => ModelAddPidana(
    isSuccess: json["isSuccess"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
