import 'dart:convert';

ModelAddPengaduan modelAddPengaduanFromJson(String str) => ModelAddPengaduan.fromJson(json.decode(str));

String modelAddPengaduanToJson(ModelAddPengaduan data) => json.encode(data.toJson());

class ModelAddPengaduan {
  bool isSuccess;
  String message;

  ModelAddPengaduan({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddPengaduan.fromJson(Map<String, dynamic> json) => ModelAddPengaduan(
    isSuccess: json["isSuccess"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
