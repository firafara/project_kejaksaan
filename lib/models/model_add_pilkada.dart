import 'dart:convert';

ModelAddPilkada modelAddPilkadaFromJson(String str) => ModelAddPilkada.fromJson(json.decode(str));

String modelAddPilkadaToJson(ModelAddPilkada data) => json.encode(data.toJson());

class ModelAddPilkada {
  bool isSuccess;
  String message;

  ModelAddPilkada({
    required this.isSuccess,
    required this.message,
  });

  factory ModelAddPilkada.fromJson(Map<String, dynamic> json) => ModelAddPilkada(
    isSuccess: json["isSuccess"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
