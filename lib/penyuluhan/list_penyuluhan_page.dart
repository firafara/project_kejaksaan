import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_kejaksaan/home_page.dart';
import 'package:project_kejaksaan/login/login_page.dart';
import 'package:project_kejaksaan/models/model_user.dart';
import 'package:project_kejaksaan/penyuluhan/add_penyuluhan_page.dart';
import 'package:project_kejaksaan/penyuluhan/edit_penyuluhan_page.dart';
import 'package:project_kejaksaan/penyuluhan/penyuluhan_detail_page.dart';
import 'package:project_kejaksaan/utils/session_manager.dart';
import 'package:project_kejaksaan/Api/Api.dart';

import '../models/model_penyuluhan.dart';

class ListPenyuluhanPage extends StatefulWidget {
  const ListPenyuluhanPage({super.key});

  @override
  State<ListPenyuluhanPage> createState() => _ListPenyuluhanPageState();
}

class _ListPenyuluhanPageState extends State<ListPenyuluhanPage> {
  late List<Datum> _penyuluhanList = [];
  late List<Datum> _filteredPenyuluhanList;
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
    _fetchPenyuluhan();
    _filteredPenyuluhanList = [];
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

  Future<void> _fetchPenyuluhan() async {
    final response = await http.get(Uri.parse(Api.Penyuluhan));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      if (parsed['data'] != null) {
        setState(() {
          _penyuluhanList = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
          _filterPenyuluhanByRole();
        });

        for (var penyuluhan in _penyuluhanList) {
          await _fetchUserData(penyuluhan.user_id);
        }
      }
    }
    setState(() {
      _isLoading = false; // Pastikan _isLoading diatur ke false di sini
    });
  }



  Future<void> _fetchUserData(String userId) async {
    final response = await http.get(Uri.parse(Api.GetUser + '?id=$userId'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      print('Response for user $userId: $parsed');

      if (parsed['data'] != null && parsed['data'].isNotEmpty) {
        final userDataMap = parsed['data'][0];
        final userData = ModelUsers.fromJson(userDataMap);

        setState(() {
          _penyuluhanList.forEach((penyuluhan) {
            if (penyuluhan.user_id == userId) {
              penyuluhan.fullname = userData.fullname;
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

  void _filterPenyuluhanByRole() {
    if (role == 'User') {
      setState(() {
        _filteredPenyuluhanList = _penyuluhanList.where((penyuluhan) => penyuluhan.user_id == userId).toList();
      });
    } else {
      setState(() {
        _filteredPenyuluhanList = _penyuluhanList;
      });
    }
  }

  void _filterPenyuluhanList(String query) async {
    try {
      final response = await http.get(Uri.parse(Api.Penyuluhan));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
        List<Datum> filteredData;
        if (query.isNotEmpty) {
          filteredData = allData.where((penyuluhan) =>
          penyuluhan.user_id.toLowerCase().contains(query.toLowerCase()) ||
              penyuluhan.nama_pelapor.toLowerCase().contains(query.toLowerCase())).toList();
        } else {
          filteredData = allData;
        }
        setState(() {
          if (role == 'User') {
            _filteredPenyuluhanList = filteredData.where((penyuluhan) => penyuluhan.user_id == userId).toList();
          } else {
            _filteredPenyuluhanList = filteredData;
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  Future<void> _saveStatus(Datum penyuluhan, String status) async {
    try {
      final response = await http.post(
        Uri.parse(Api.UpdateStatusPenyuluhan),
        body: {
          'id': penyuluhan.id,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        print('Status berhasil disimpan: $status');
        setState(() {
          penyuluhan.status = status;
        });
      } else {
        print('Gagal menyimpan status: ${response.body}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  void _handleStatusButtonPress(Datum penyuluhan) {
    if (role == 'Admin') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Approve Penyuluhan?'),
            content: Text('Apakah Anda ingin menyetujui penyuluhan ini?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _saveStatus(penyuluhan, 'Approved');
                },
                child: Text('Approve'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _saveStatus(penyuluhan, 'Rejected');
                },
                child: Text('Reject'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _handleEdit(Datum penyuluhan) async {
    // Menunggu hasil dari EditAliranPage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditPenyuluhanPage(penyuluhan: penyuluhan)
      ),
    );

    // Memeriksa apakah hasil pengeditan sukses
    if (result == true) {
      // Ambil ulang data dari server untuk merefresh tampilan
      _fetchPenyuluhan();
    }
  }

  Future<void> _handleDelete(Datum penyuluhan) async {
    try {
      final response = await http.post(
        Uri.parse(Api.DeletePenyuluhan), // Sesuaikan dengan URL endpoint untuk hapus data
        body: {
          'id': penyuluhan.id,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _filteredPenyuluhanList.remove(penyuluhan);
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
  void _handleItemClick(Datum penyuluhan) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PenyuluhanDetailPage(penyuluhan: penyuluhan)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Penyuluhan Hukum",
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
                  onChanged: _filterPenyuluhanList,
                  decoration: InputDecoration(
                    labelText: 'Search Penyuluhan',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredPenyuluhanList.isEmpty
                  ? Center(
                child: Text('Anda belum membuat permohonan'),
              )
                  : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _filteredPenyuluhanList.length,
                itemBuilder: (context, index) {
                  final penyuluhan = _filteredPenyuluhanList[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () => _handleItemClick(penyuluhan),
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
                                  penyuluhan.bentuk_permasalahan ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 20,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Nama Pelapor: ' +
                                      (penyuluhan.nama_pelapor ??
                                          'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tanggal Pelaporan: ' +
                                      (penyuluhan.created_at ??
                                          'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Created by: ${penyuluhan.fullname ?? 'Loading...'}',
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
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => _handleStatusButtonPress(penyuluhan),
                                      child: Text(
                                        penyuluhan.status,
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
              ),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPenyuluhanPage(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
