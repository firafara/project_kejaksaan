import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:project_kejaksaan/models/model_jms.dart';

class EditJmsPage extends StatefulWidget {
  final Datum jms;

  const EditJmsPage({Key? key, required this.jms}) : super(key: key);

  @override
  _EditJmsPageState createState() => _EditJmsPageState();
}

class _EditJmsPageState extends State<EditJmsPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _sekolahController = TextEditingController();
  TextEditingController _namaPelaporController = TextEditingController();
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    _sekolahController.text = widget.jms.sekolah ?? '';
    _namaPelaporController.text = widget.jms.nama_pelapor ?? '';
  }

  Future<void> _updateAliran() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;  // Atur isLoading menjadi true saat proses dimulai
      });
      try {
        Uri uri = Uri.parse('http://192.168.1.8/kejaksaan/editjms.php');

        http.MultipartRequest request = http.MultipartRequest('POST', uri)
          ..fields['id'] = widget.jms.id
          ..fields['user_id'] = widget.jms.user_id
          ..fields['sekolah'] = _sekolahController.text
          ..fields['nama_pelapor'] = _namaPelaporController.text
          ..fields['status'] = widget.jms.status;


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
    _sekolahController.dispose();
    _namaPelaporController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF5BB04B),
        title: Text(
          'Edit JMS',
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
