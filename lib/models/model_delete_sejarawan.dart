// To parse this JSON data, do
//
//     final modelDeletePegawai = modelDeletePegawaiFromJson(jsonString);

import 'dart:convert';

ModelDeletePegawai modelDeletePegawaiFromJson(String str) =>
    ModelDeletePegawai.fromJson(json.decode(str));

String modelDeletePegawaiToJson(ModelDeletePegawai data) =>
    json.encode(data.toJson());

class ModelDeletePegawai {
  bool isSuccess;
  String message;

  ModelDeletePegawai({
    required this.isSuccess,
    required this.message,
  });

  factory ModelDeletePegawai.fromJson(Map<String, dynamic> json) =>
      ModelDeletePegawai(
        isSuccess: json["isSuccess"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
      };
}
