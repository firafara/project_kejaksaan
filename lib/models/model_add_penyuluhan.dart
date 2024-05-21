import 'dart:convert';

ModelAddPenyuluhan modelAddPenyuluhanFromJson(String str) => ModelAddPenyuluhan.fromJson(json.decode(str));

String modelAddPenyuluhanToJson(ModelAddPenyuluhan data) => json.encode(data.toJson());

class ModelAddPenyuluhan {
  bool isSuccess;
  String message;

  ModelAddPenyuluhan({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddPenyuluhan.fromJson(Map<String, dynamic> json) => ModelAddPenyuluhan(
    isSuccess: json["isSuccess"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
