import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_kejaksaan/models/model_add_pidana.dart';
import 'package:project_kejaksaan/pidana/list_pidana_page.dart';
import 'package:project_kejaksaan/utils/session_manager.dart';

class AddPidanaPage extends StatefulWidget {
  const AddPidanaPage({super.key});

  @override
  State<AddPidanaPage> createState() => _AddPidanaPageState();
}

class _AddPidanaPageState extends State<AddPidanaPage> {
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _laporanPengaduanController = TextEditingController();
  TextEditingController _namaPelaporController = TextEditingController(); // Add controller for nama_pelapor
  TextEditingController _ktpController = TextEditingController(); // Add controller for ktp
  TextEditingController _noHpController = TextEditingController(); // Add controller for no_hp
  TextEditingController _uraianController = TextEditingController(); // Add controller for no_hp

  String _fullname = ''; // Tambahkan variabel untuk menyimpan fullname

  String _laporanPengaduanPdfPath = ''; // Ubah ke tipe String
  String _ktpPdfPath = ''; // Ubah ke tipe String

  bool isLoading = false;

  Future<bool> requestPermissions() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> getFullName(String userId) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.8/kejaksaan/getUser?id=$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _fullname = data['data'][0]['fullname'];
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  Future<void> selectFileLaporanPengaduan() async {
    if (await requestPermissions()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any); // Ubah menjadi FileType.any
      if (result != null && result.files.single.path != null) {
        setState(() {
          _laporanPengaduanPdfPath = result.files.single.path!;
        });
      } else {
        print("No file selected");
      }
    } else {
      print("Storage permission not granted");
    }
  }

  Future<void> selectFileKtp() async {
    if (await requestPermissions()) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any); // Ubah menjadi FileType.any
      if (result != null && result.files.single.path != null) {
        setState(() {
          _ktpPdfPath = result.files.single.path!;
        });
      } else {
        print("No file selected");
      }
    } else {
      print("Storage permission not granted");
    }
  }

  // Future<void> addPengaduan() async {
  //   if (_userIdController.text.isEmpty ||
  //       _laporanPengaduanPdfPath.isEmpty ||
  //       _ktpPdfPath.isEmpty ||
  //       _laporanPengaduanController.text.isEmpty ||
  //       _statusController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Semua field harus diisi')),
  //     );
  //     return;
  //   }
  //
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     Uri uri = Uri.parse('http://192.168.1.8/kejaksaan/addpengaduan.php');
  //
  //     http.MultipartRequest request = http.MultipartRequest('POST', uri)
  //       ..fields['user_id'] = _userIdController.text
  //       ..fields['laporan_pengaduan'] = _laporanPengaduanController.text
  //       ..fields['status'] = _statusController.text;
  //
  //     if (_laporanPengaduanPdfPath.isNotEmpty) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'laporan_pengaduan_pdf',
  //           _laporanPengaduanPdfPath,
  //           contentType: MediaType('application', 'pdf'), // Ubah tipe konten sesuai dengan yang diperlukan
  //         ),
  //       );
  //     }
  //
  //     if (_ktpPdfPath.isNotEmpty) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           'ktp_pdf',
  //           _ktpPdfPath,
  //           contentType: MediaType('application', 'pdf'), // Ubah tipe konten sesuai dengan yang diperlukan
  //         ),
  //       );
  //     }
  //
  //     http.StreamedResponse response = await request.send();
  //     String responseBody = await response.stream.bytesToString();
  //     print("Server response: $responseBody"); // Ini akan mencetak body respons
  //
  //     if (response.statusCode == 200) {
  //       try {
  //         ModelAddPengaduan data = modelAddPengaduanFromJson(responseBody);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('${data.message}')),
  //         );
  //         if (data.isSuccess) {
  //           Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (context) => ListPengaduanPage()),
  //                 (route) => false,
  //           );
  //         }
  //       } catch (e) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Failed to parse response: $e')),
  //         );
  //       }
  //     } else {
  //       throw Exception('Failed to upload data, status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('An error occurred: $e')),
  //     );
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  Future<void> addPengaduan() async {
    String userId = sessionManager.id ?? ''; // Get the user ID from the session manager
    print('User ID: $userId');
    print('Nama Pelapor: ${_namaPelaporController.text}');
    print('KTP: ${_ktpController.text}');
    print('No HP: ${_noHpController.text}');
    print('Laporan Pengaduan: ${_laporanPengaduanController.text}');

    // Check if other required fields are empty
    if (userId.isEmpty ||
        _laporanPengaduanPdfPath.isEmpty ||
        _ktpPdfPath.isEmpty ||
        _laporanPengaduanController.text.isEmpty ||
        _namaPelaporController.text.isEmpty || // Check if nama_pelapor is empty
        _ktpController.text.isEmpty || // Check if ktp is empty
        _noHpController.text.isEmpty) { // Check if no_hp is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Uri uri = Uri.parse('http://192.168.1.8/kejaksaan/addpidana.php');

      http.MultipartRequest request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = userId // Gunakan user ID yang diambil dari sesi
        ..fields['laporan_pengaduan'] = _laporanPengaduanController.text
        ..fields['status'] = 'Pending'
        ..fields['nama_pelapor'] = _namaPelaporController.text
        ..fields['ktp'] = _ktpController.text
        ..fields['no_hp'] = _noHpController.text
        ..fields['uraian'] = _uraianController.text;


      if (_laporanPengaduanPdfPath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'laporan_pengaduan_pdf',
            _laporanPengaduanPdfPath,
            contentType: MediaType('application', 'pdf'), // Ubah tipe konten sesuai dengan PDF
          ),
        );
      }

      if (_ktpPdfPath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'ktp_pdf',
            _ktpPdfPath,
            contentType: MediaType('application', 'pdf'), // Ubah tipe konten sesuai dengan PDF
          ),
        );
      }

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print("Server response: $responseBody");

      if (response.statusCode == 200) {
        try {
          ModelAddPidana data = modelAddPidanaFromJson(responseBody);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
          if (data.isSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPidanaPage()),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to parse response: $e')),
          );
        }
      } else {
        throw Exception('Failed to upload data, status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }



  @override
  void initState() {
    super.initState();
    // Panggil getFullName ketika halaman pertama kali dimuat
    _userIdController.addListener(() {
      getFullName(_userIdController.text);
    });
  }
  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5BB04B),
        title: Row(
          children: [
            Text(
              'Add Pidana Korupsi',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'Jost',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xFF5BB04B),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField(
            //   style: TextStyle(
            //     fontFamily: 'Mulish',
            //   ),
            //   decoration: InputDecoration(
            //     filled: true,
            //     fillColor: Colors.white,
            //     hintText: "Id User",
            //     prefixIcon: Icon(Icons.person, color: Color(0xFF545454)),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(8.0),
            //       borderSide: BorderSide.none,
            //     ),
            //     contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            //   ),
            //   controller: _userIdController,
            // ),
            // SizedBox(height: 20),
            // Text(
            //   'Fullname: $_fullname', // Tampilkan fullname di sini
            //   style: TextStyle(
            //     fontFamily: 'Mulish',
            //     color: Colors.white,
            //   ),
            // ),
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
            TextField(
              style: TextStyle(
                fontFamily: 'Mulish',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Uraian",
                prefixIcon: Icon(Icons.description, color: Color(0xFF545454)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              controller: _uraianController,
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
              onTap: addPengaduan, // Panggil addPengaduan saat tombol ditekan
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
    );
  }
}
