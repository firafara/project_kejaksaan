import 'dart:convert';

ModelGambar modelGambarFromJson(String str) =>
    ModelGambar.fromJson(json.decode(str));

String modelGambarToJson(ModelGambar data) => json.encode(data.toJson());

class ModelGambar {
  bool? sukses;
  int? status; // Make it nullable
  String pesan;
  List<Datum> data;

  ModelGambar({
    this.sukses,
    this.status, // Make it nullable
    required this.pesan,
    required this.data,
  });

  factory ModelGambar.fromJson(Map<String, dynamic> json) => ModelGambar(
    sukses: json["isSuccess"],
    status: json["status"], // This might be null, handle accordingly
    pesan: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": sukses,
    "status": status,
    "message": pesan,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };

}



class Datum {
  String id;
  String gambar;

  Datum({
    required this.id,
    required this.gambar,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    gambar: json["gambar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "gambar": gambar,
  };
}

