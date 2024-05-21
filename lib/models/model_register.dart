// To parse this JSON data, do
//
//     final modelRegister = modelRegisterFromJson(jsonString);

import 'dart:convert';

ModelRegister modelRegisterFromJson(String str) => ModelRegister.fromJson(json.decode(str));

String modelRegisterToJson(ModelRegister data) => json.encode(data.toJson());

class ModelRegister {
  int value;
  String username;
  String email;
  String fullname;
  String phone_number;
  String message;

  ModelRegister({
  required this.value,
  required this.username,
  required this.email,
  required this.fullname,
  required this.phone_number,
  required this.message,
  });


  factory ModelRegister.fromJson(Map<String, dynamic> json) => ModelRegister(
    value: json["value"],
    message: json["message"], username: 'json["username"]', email: 'json["email"]', fullname: 'json["fullname"]', phone_number: 'json["phone_number"]',
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
    "username": username,
    "email": email,
    "fullname": fullname,
    "phone_number": phone_number,
  };
}
