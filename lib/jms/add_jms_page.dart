import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:project_kejaksaan/jms/list_jms_page.dart';
import 'package:project_kejaksaan/models/model_add_pengaduan.dart'; // Menggunakan model pengaduan
import 'package:project_kejaksaan/pengaduan/list_pengaduan_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project_kejaksaan/utils/session_manager.dart';

class AddJmsPage extends StatefulWidget {
  const AddJmsPage({super.key});

  @override
  State<AddJmsPage> createState() => _AddJmsPageState();
}

class _AddJmsPageState extends State<AddJmsPage> {
  TextEditingController _userIdController = TextEditingController();
  TextEditingController _namaPemohonController = TextEditingController(); // Add controller for nama_pelapor
  TextEditingController _sekolahController = TextEditingController(); // Add controller for no_hp
  TextEditingController _permohonanController = TextEditingController(); // Add controller for no_hp


  String _fullname = ''; // Tambahkan variabel untuk menyimpan fullname

  bool isLoading = false;

  Future<bool> requestPermissions() async {
    var status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> getFullName(String userId) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.11/kejaksaan/getUser?id=$userId'));
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

  Future<void> addPengaduan() async {
    String userId = sessionManager.id ?? ''; // Get the user ID from the session manager
    print('User ID: $userId');
    print('Nama Pemohon: ${_namaPemohonController.text}');
    print('Sekolah: ${_sekolahController.text}');
    print('Permohonan: ${_permohonanController.text}');

    // Check if other required fields are empty
    if (userId.isEmpty || _namaPemohonController.text.isEmpty || _sekolahController.text.isEmpty || _permohonanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      Uri uri = Uri.parse('http://192.168.1.11/kejaksaan/addjms.php');

      http.MultipartRequest request = http.MultipartRequest('POST', uri)
        ..fields['user_id'] = userId // Gunakan user ID yang diambil dari sesi
        ..fields['status'] = 'Pending'
        ..fields['nama_pelapor'] = _namaPemohonController.text
        ..fields['sekolah'] = _sekolahController.text
        ..fields['permohonan'] = _permohonanController.text;

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();
      print("Server response: $responseBody");

      if (response.statusCode == 200) {
        try {
          ModelAddPengaduan data = modelAddPengaduanFromJson(responseBody);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
          if (data.isSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListJmsPage()),
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
              'Add JMS',
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
                hintText: "Nama Pemohon",
                prefixIcon: Icon(Icons.person, color: Color(0xFF545454)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              controller: _namaPemohonController,
            ),
            SizedBox(height: 20),
            TextField(
              style: TextStyle(
                fontFamily: 'Mulish',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Sekolah",
                prefixIcon: Icon(Icons.credit_card, color: Color(0xFF545454)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              controller: _sekolahController,
            ),
            SizedBox(height: 20),
            TextField(
              style: TextStyle(
                fontFamily: 'Mulish',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Permohonan",
                prefixIcon: Icon(Icons.file_copy_sharp, color: Color(0xFF545454)), // Mengubah ikon menjadi ikon file
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
              maxLines: null, // Atau jumlah baris yang diinginkan
              controller: _permohonanController,
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

