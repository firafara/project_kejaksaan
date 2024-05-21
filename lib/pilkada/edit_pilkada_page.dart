import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:project_kejaksaan/models/model_pilkada.dart';

class EditPilkadaPage extends StatefulWidget {
  final Datum pilkada;

  const EditPilkadaPage({Key? key, required this.pilkada}) : super(key: key);

  @override
  _EditPilkadaPageState createState() => _EditPilkadaPageState();
}

class _EditPilkadaPageState extends State<EditPilkadaPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _laporanPengaduanController = TextEditingController();
  TextEditingController _namaPelaporController = TextEditingController();
  TextEditingController _ktpController = TextEditingController();
  TextEditingController _noHpController = TextEditingController();

  String _laporanPengaduanPdfPath = '';
  String _ktpPdfPath = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _laporanPengaduanController.text = widget.pilkada.laporan_pengaduan ?? '';
    _namaPelaporController.text = widget.pilkada.nama_pelapor ?? '';
    _ktpController.text = widget.pilkada.ktp ?? '';
    _noHpController.text = widget.pilkada.no_hp ?? '';
  }

  Future<void> selectFileLaporanPengaduan() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _laporanPengaduanPdfPath = result.files.single.path!;
      });
    }
  }

  Future<void> selectFileKtp() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      setState(() {
        _ktpPdfPath = result.files.single.path!;
      });
    }
  }

  Future<void> _updateAliran() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;  // Atur isLoading menjadi true saat proses dimulai
      });
      try {
        Uri uri = Uri.parse('http://192.168.1.8/kejaksaan/editpilkada.php');

        http.MultipartRequest request = http.MultipartRequest('POST', uri)
          ..fields['id'] = widget.pilkada.id
          ..fields['user_id'] = widget.pilkada.user_id
          ..fields['laporan_pengaduan'] = _laporanPengaduanController.text
          ..fields['nama_pelapor'] = _namaPelaporController.text
          ..fields['ktp'] = _ktpController.text
          ..fields['no_hp'] = _noHpController.text
          ..fields['status'] = widget.pilkada.status;

        if (_laporanPengaduanPdfPath.isNotEmpty) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'laporan_pengaduan_pdf',
              _laporanPengaduanPdfPath,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        }

        if (_ktpPdfPath.isNotEmpty) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'ktp_pdf',
              _ktpPdfPath,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        }

        http.StreamedResponse response = await request.send();
        String responseBody = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil diubah')),
          );
          Navigator.pop(context, true); // Mengirim hasil kembali ke halaman sebelumnya
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update data: $responseBody')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;  // Atur isLoading menjadi false setelah proses selesai
        });
      }
    }
  }

  @override
  void dispose() {
    _laporanPengaduanController.dispose();
    _namaPelaporController.dispose();
    _ktpController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5BB04B),
        title: Text(
          'Edit Posko Pilkada',
          style: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Jost',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color(0xFF5BB04B),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                style: TextStyle(
                  fontFamily: 'Mulish',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Nama Pelapor",
                  prefixIcon: Icon(Icons.person, color: Color(0xFF545454)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                controller: _namaPelaporController,
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(
                  fontFamily: 'Mulish',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "KTP",
                  prefixIcon: Icon(Icons.credit_card, color: Color(0xFF545454)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                controller: _ktpController,
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(
                  fontFamily: 'Mulish',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "No HP",
                  prefixIcon: Icon(Icons.phone, color: Color(0xFF545454)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                controller: _noHpController,
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: selectFileLaporanPengaduan,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Laporan Pengaduan (PDF)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf),
                        SizedBox(width: 10),
                        Text(_laporanPengaduanPdfPath.isNotEmpty ? _laporanPengaduanPdfPath.split('/').last : 'Pilih file PDF'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(
                  fontFamily: 'Mulish',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Laporan Pengaduan",
                  prefixIcon: Icon(Icons.description, color: Color(0xFF545454)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                controller: _laporanPengaduanController,
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: selectFileKtp,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'KTP (PDF)',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Icon(Icons.picture_as_pdf),
                        SizedBox(width: 10),
                        Text(_ktpPdfPath.isNotEmpty ? _ktpPdfPath.split('/').last : 'Pilih file PDF'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              InkWell(
                onTap: _updateAliran,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFF275D20),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Save Changes',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Jost',
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Color(0xFF275D20),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
