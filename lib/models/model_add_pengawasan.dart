import 'dart:convert';

ModelAddPengawasan modelAddPengawasanFromJson(String str) => ModelAddPengawasan.fromJson(json.decode(str));

String modelAddPengawasanToJson(ModelAddPengawasan data) => json.encode(data.toJson());

class ModelAddPengawasan {
  bool isSuccess;
  String message;

  ModelAddPengawasan({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddPengawasan.fromJson(Map<String, dynamic> json) => ModelAddPengawasan(
    isSuccess: json["isSuccess"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
