// import 'dart:convert';
//
// ModelAliran modelAliranFromJson(String str) =>
//     ModelAliran.fromJson(json.decode(str));
//
// String modelAliranToJson(ModelAliran data) => json.encode(data.toJson());
//
// class ModelAliran {
//   bool isSuccess;
//   String message;
//   List<Datum> data;
//
//   ModelAliran({
//     required this.isSuccess,
//     required this.message,
//     required this.data,
//   });
//
//   factory ModelAliran.fromJson(Map<String, dynamic> json) => ModelAliran(
//     isSuccess: json["isSuccess"],
//     message: json["message"],
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "isSuccess": isSuccess,
//     "message": message,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//   };
// }
//
// class Datum {
//   String id;
//   String user_id;
//   String status;
//   String created_at;
//   String fullname;
//   String laporan_pengaduan;
//   String nama_pelapor;
//   String ktp; // New field for KTP
//   String no_hp; // New field for No HP
//
//   Datum({
//     required this.id,
//     required this.user_id,
//     required this.status,
//     required this.created_at,
//     required this.fullname,
//     required this.laporan_pengaduan,
//     required this.nama_pelapor,
//     required this.ktp, // Include ktp in the constructor
//     required this.no_hp, // Include no_hp in the constructor
//   });
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//     id: json["id"] ?? '0',
//     user_id: json["user_id"] ?? 'No Title',
//     status: json["status"] ?? 'No Content',
//     created_at: json["created_at"] ?? '',
//     fullname: json["fullname"] ?? 'Unknown',
//     laporan_pengaduan: json["laporan_pengaduan"] ?? '',
//     nama_pelapor: json["nama_pelapor"] ?? '',
//     ktp: json["ktp"] ?? '', // Parse ktp from JSON
//     no_hp: json["no_hp"] ?? '', // Parse no_hp from JSON
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "user_id": user_id,
//     "status": status,
//     "created_at": created_at,
//     "fullname": fullname,
//     "laporan_pengaduan": laporan_pengaduan,
//     "nama_pelapor": nama_pelapor,
//     "ktp": ktp, // Include ktp in JSON serialization
//     "no_hp": no_hp, // Include no_hp in JSON serialization
//   };
// }
//
import 'dart:convert';

ModelAliran modelAliranFromJson(String str) =>
    ModelAliran.fromJson(json.decode(str));

String modelAliranToJson(ModelAliran data) => json.encode(data.toJson());

class ModelAliran {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelAliran({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelAliran.fromJson(Map<String, dynamic> json) => ModelAliran(
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
  String laporan_pengaduan;
  String nama_pelapor;
  String ktp; // Field for KTP
  String no_hp; // Field for No HP
  String laporan_pengaduan_pdf; // New field for PDF
  String ktp_pdf; // New field for PDF

  Datum({
    required this.id,
    required this.user_id,
    required this.status,
    required this.created_at,
    required this.fullname,
    required this.laporan_pengaduan,
    required this.nama_pelapor,
    required this.ktp, // Include ktp in the constructor
    required this.no_hp, // Include no_hp in the constructor
    required this.laporan_pengaduan_pdf, // Include laporan_pengaduan_pdf in the constructor
    required this.ktp_pdf, // Include laporan_pengaduan_pdf in the constructor
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] ?? '0',
    user_id: json["user_id"] ?? 'No Title',
    status: json["status"] ?? 'No Content',
    created_at: json["created_at"] ?? '',
    fullname: json["fullname"] ?? 'Unknown',
    laporan_pengaduan: json["laporan_pengaduan"] ?? '',
    nama_pelapor: json["nama_pelapor"] ?? '',
    ktp: json["ktp"] ?? '', // Parse ktp from JSON
    no_hp: json["no_hp"] ?? '', // Parse no_hp from JSON
    laporan_pengaduan_pdf: json["laporan_pengaduan_pdf"] ?? '', // Parse laporan_pengaduan_pdf from JSON
    ktp_pdf: json["ktp_pdf"] ?? '', // Parse laporan_pengaduan_pdf from JSON

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": user_id,
    "status": status,
    "created_at": created_at,
    "fullname": fullname,
    "laporan_pengaduan": laporan_pengaduan,
    "nama_pelapor": nama_pelapor,
    "ktp": ktp, // Include ktp in JSON serialization
    "no_hp": no_hp, // Include no_hp in JSON serialization
    "laporan_pengaduan_pdf": laporan_pengaduan_pdf, // Include laporan_pengaduan_pdf in JSON serialization
    "ktp_pdf": ktp_pdf, // Include laporan_pengaduan_pdf in JSON serialization

  };
}
