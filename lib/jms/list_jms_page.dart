import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_kejaksaan/home_page.dart';
import 'package:project_kejaksaan/jms/add_jms_page.dart';
import 'package:project_kejaksaan/jms/edit_jms_page.dart';
import 'package:project_kejaksaan/login/login_page.dart';
import 'package:project_kejaksaan/models/model_user.dart';
import 'package:project_kejaksaan/utils/session_manager.dart';
import '../models/model_jms.dart';
import 'package:project_kejaksaan/Api/Api.dart';


class ListJmsPage extends StatefulWidget {
  const ListJmsPage({super.key});

  @override
  State<ListJmsPage> createState() => _ListJmsPageState();
}

class _ListJmsPageState extends State<ListJmsPage> {
  late List<Datum> _jmsList = [];
  late List<Datum> _filteredJmsList;
  late bool _isLoading;
  TextEditingController _searchController = TextEditingController();
  String? username;
  String? role; // Simpan peran pengguna (admin / customer)
  String? userId; // Simpan user_id dari sesi

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getDataSession();
    _fetchJms();
    _filteredJmsList = [];
  }

  Future<void> getDataSession() async {
    bool hasSession = await sessionManager.getSession();
    if (hasSession) {
      setState(() {
        username = sessionManager.username;
        role = sessionManager.role;
        userId = sessionManager.id; // Simpan user_id dari sesi
        print('Data session: $username');
      });
    } else {
      print('Session tidak ditemukan!');
    }
  }

  Future<void> _fetchJms() async {
    final response =
    await http.get(Uri.parse(Api.JMS));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      if (parsed['data'] != null) {
        setState(() {
          _jmsList =
          List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
          _filterJmsByRole();
          _isLoading = false;
        });

        for (var jms in _jmsList) {
          await _fetchUserData(jms.user_id);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load pengaduan');
    }
  }

  Future<void> _fetchUserData(String userId) async {
    final response = await http.get(
        Uri.parse(Api.GetUser + '?id=$userId'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      print('Response for user $userId: $parsed');

      if (parsed['data'] != null && parsed['data'].isNotEmpty) {
        final userDataMap = parsed['data'][0];
        final userData = ModelUsers.fromJson(userDataMap);

        setState(() {
          _jmsList.forEach((jms) {
            if (jms.user_id == userId) {
              jms.fullname = userData.fullname;
            }
          });
        });
      } else {
        print('User data not found for user $userId');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void _filterJmsByRole() {
    if (role == 'User') {
      setState(() {
        _filteredJmsList =
            _jmsList.where((jms) => jms.user_id == userId).toList();
      });
    } else {
      setState(() {
        _filteredJmsList = _jmsList;
      });
    }
  }

  void _filterJmsList(String query) async {
    try {
      final response =
      await http.get(Uri.parse(Api.JMS));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        List<Datum> allData =
        List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
        List<Datum> filteredData;
        if (query.isNotEmpty) {
          filteredData = allData
              .where((jms) =>
          jms.user_id.toLowerCase().contains(query.toLowerCase()) ||
              jms.nama_pemohon.toLowerCase().contains(query.toLowerCase()))
              .toList();
        } else {
          filteredData = allData;
        }
        setState(() {
          if (role == 'User') {
            _filteredJmsList =
                filteredData.where((jms) => jms.user_id == userId).toList();
          } else {
            _filteredJmsList = filteredData;
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  Future<void> _saveStatus(Datum jms, String status) async {
    try {
      final response = await http.post(
        Uri.parse(Api.UpdateStatusJMS),
        body: {
          'id': jms.id,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        print('Status berhasil disimpan: $status');
        setState(() {
          jms.status = status;
        });
      } else {
        print('Gagal menyimpan status: ${response.body}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  void _handleStatusButtonPress(Datum jms) {
    if (role == 'Admin') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Approve Pengaduan?'),
            content: Text('Apakah Anda ingin menyetujui pengaduan ini?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _saveStatus(jms, 'Approved');
                },
                child: Text('Approve'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _saveStatus(jms, 'Rejected');
                },
                child: Text('Reject'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _handleEdit(Datum jms) async {
    // Menunggu hasil dari EditAliranPage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditJmsPage(jms: jms)),
    );

    // Memeriksa apakah hasil pengeditan sukses
    if (result == true) {
      // Ambil ulang data dari server untuk merefresh tampilan
      _fetchJms();
    }
  }

  Future<void> _handleDelete(Datum jms) async {
    try {
      final response = await http.post(
        Uri.parse(Api.DeleteJMS), // Sesuaikan dengan URL endpoint untuk hapus data
        body: {
          'id': jms.id,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _filteredJmsList.remove(jms);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil dihapus')),
        );
      } else {
        print('Gagal menghapus data: ${response.body}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List JMS",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF5BB04B),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Hi, ${username ?? ''}',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontFamily: 'Jost',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            color: Colors.black,
            onPressed: () {
              setState(() {
                sessionManager.clearSession();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                );
              });
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFF5BB04B),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterJmsList,
                  decoration: InputDecoration(
                    labelText: 'Search JMS',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _jmsList.isEmpty
                  ? Center(
                child: Text('Anda belum membuat permohonan'),
              )
                  : _filteredJmsList.isEmpty
                  ? Center(
                child: Text('Belum ada permohonan'),
              )
                  : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _filteredJmsList.length,
                itemBuilder: (context, index) {
                  final jms = _filteredJmsList[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(15)),
                              color: Color(0xFFFFFFFF),
                            ),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  jms.sekolah ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 20,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Nama Pemohon: ' +
                                      (jms.nama_pemohon ??
                                          'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tanggal Permohonan: ' +
                                      (jms.created_at ??
                                          'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Permohonan: ' +
                                      (jms.permohonan ??
                                          'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Created by: ${jms.fullname ?? 'Loading...'}',
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                      // null,
                                      _handleStatusButtonPress(jms),
                                      child: Text(
                                        jms.status,
                                        style: TextStyle(
                                          fontFamily: 'Jost',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddJmsPage(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
