import 'dart:convert';

ModelJms modelJmsFromJson(String str) =>
    ModelJms.fromJson(json.decode(str));

String modelJmsToJson(ModelJms data) => json.encode(data.toJson());

class ModelJms {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelJms({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelJms.fromJson(Map<String, dynamic> json) => ModelJms(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String user_id;
  String status;
  String created_at;
  String sekolah;
  String nama_pelapor;
  String fullname;
  String ktp; // New field for KTP
  String no_hp; // New field for No HP

  Datum({
    required this.id,
    required this.user_id,
    required this.status,
    required this.created_at,
    required this.sekolah,
    required this.nama_pelapor,
    required this.fullname,
    required this.ktp, // Include ktp in the constructor
    required this.no_hp, // Include no_hp in the constructor

  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] ?? '0',
    user_id: json["user_id"] ?? 'No Title',
    status: json["status"] ?? 'No Content',
    created_at: json["created_at"] ?? '',
    sekolah: json["sekolah"] ?? 'Unknown',
    nama_pelapor: json["nama_pelapor"] ?? '',
    fullname: json["fullname"] ?? 'Unknown',
    ktp: json["ktp"] ?? '', // Parse ktp from JSON
    no_hp: json["no_hp"] ?? '', // Parse no_hp from JSON

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": user_id,
    "status": status,
    "created_at": created_at,
    "sekolah": sekolah,
    "nama_pelapor": nama_pelapor,
    "fullname": fullname,
    "ktp": ktp, // Include ktp in JSON serialization
    "no_hp": no_hp, // Include no_hp in JSON serialization

  };
}

