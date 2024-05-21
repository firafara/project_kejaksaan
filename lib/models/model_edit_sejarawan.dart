// To parse this JSON data, do
//
//     final modelEditPegawai = modelEditPegawaiFromJson(jsonString);

import 'dart:convert';

ModelEditSejarawan modelEditSejarawanFromJson(String str) => ModelEditSejarawan.fromJson(json.decode(str));

String modelEditPegawaiToJson(ModelEditSejarawan data) => json.encode(data.toJson());

class ModelEditSejarawan {
  bool isSuccess;
  String message;

  ModelEditSejarawan({
    required this.isSuccess,
    required this.message,
  });

  factory ModelEditSejarawan.fromJson(Map<String, dynamic> json) => ModelEditSejarawan(
    isSuccess: json["isSuccess"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
