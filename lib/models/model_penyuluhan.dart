import 'dart:convert';

ModelPenyuluhan modelPenyuluhanFromJson(String str) =>
    ModelPenyuluhan.fromJson(json.decode(str));

String modelPenyuluhanToJson(ModelPenyuluhan data) => json.encode(data.toJson());

class ModelPenyuluhan {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelPenyuluhan({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelPenyuluhan.fromJson(Map<String, dynamic> json) => ModelPenyuluhan(
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
  String fullname;
  String bentuk_permasalahan;
  String nama_pelapor;
  String ktp; // Field for KTP
  String no_hp; // Field for No HP
  String bentuk_permasalahan_pdf; // New field for PDF
  String ktp_pdf; // New field for PDF

  Datum({
    required this.id,
    required this.user_id,
    required this.status,
    required this.created_at,
    required this.fullname,
    required this.bentuk_permasalahan,
    required this.nama_pelapor,
    required this.ktp, // Include ktp in the constructor
    required this.no_hp, // Include no_hp in the constructor
    required this.bentuk_permasalahan_pdf, // Include bentuk_permasalahan_pdf in the constructor
    required this.ktp_pdf, // Include bentuk_permasalahan_pdf in the constructor
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] ?? '0',
    user_id: json["user_id"] ?? 'No Title',
    status: json["status"] ?? 'No Content',
    created_at: json["created_at"] ?? '',
    fullname: json["fullname"] ?? 'Unknown',
    bentuk_permasalahan: json["bentuk_permasalahan"] ?? '',
    nama_pelapor: json["nama_pelapor"] ?? '',
    ktp: json["ktp"] ?? '', // Parse ktp from JSON
    no_hp: json["no_hp"] ?? '', // Parse no_hp from JSON
    bentuk_permasalahan_pdf: json["bentuk_permasalahan_pdf"] ?? '', // Parse bentuk_permasalahan_pdf from JSON
    ktp_pdf: json["ktp_pdf"] ?? '', // Parse bentuk_permasalahan_pdf from JSON

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": user_id,
    "status": status,
    "created_at": created_at,
    "fullname": fullname,
    "bentuk_permasalahan": bentuk_permasalahan,
    "nama_pelapor": nama_pelapor,
    "ktp": ktp, // Include ktp in JSON serialization
    "no_hp": no_hp, // Include no_hp in JSON serialization
    "bentuk_permasalahan_pdf": bentuk_permasalahan_pdf, // Include bentuk_permasalahan_pdf in JSON serialization
    "ktp_pdf": ktp_pdf, // Include bentuk_permasalahan_pdf in JSON serialization

  };
}

