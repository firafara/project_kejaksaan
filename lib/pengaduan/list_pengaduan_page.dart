import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_kejaksaan/home_page.dart';
import 'package:project_kejaksaan/login/login_page.dart';
import 'package:project_kejaksaan/models/model_pengaduan.dart';
import 'package:project_kejaksaan/models/model_user.dart';
import 'package:project_kejaksaan/pengaduan/add_pengaduan_page.dart';
import 'package:project_kejaksaan/pengaduan/edit_pengaduan_page.dart';
import 'package:project_kejaksaan/pengaduan/pengaduan_detail_page.dart';
import 'package:project_kejaksaan/utils/session_manager.dart';

class ListPengaduanPage extends StatefulWidget {
  const ListPengaduanPage({Key? key}) : super(key: key);

  @override
  State<ListPengaduanPage> createState() => _ListPengaduanPageState();
}

class _ListPengaduanPageState extends State<ListPengaduanPage> {
  late List<Datum> _pengaduanList = [];
  late List<Datum> _filteredPengaduanList;
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
    _fetchPengaduan();
    _filteredPengaduanList = [];
  }

  Future<void> getDataSession() async {
    bool hasSession = await sessionManager.getSession();
    if (hasSession) {
      setState(() {
        username = sessionManager.username;
        role = sessionManager.role; // Simpan peran pengguna dari sesi
        userId = sessionManager.id; // Simpan user_id dari sesi
        print('Data session: $username');
      });
    } else {
      print('Session tidak ditemukan!');
    }
  }

  // Future<void> _fetchPengaduan() async {
  //   final response = await http.get(Uri.parse('http://192.168.31.53/kejaksaan/pengaduan.php'));
  //   if (response.statusCode == 200) {
  //     final parsed = jsonDecode(response.body);
  //     setState(() {
  //       _pengaduanList = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
  //       _filterPengaduanByRole();
  //       _isLoading = false;
  //     });
  //
  //     for (var pengaduan in _pengaduanList) {
  //       await _fetchUserData(pengaduan.user_id);
  //     }
  //   } else {
  //     throw Exception('Failed to load pengaduan');
  //   }
  // }

  Future<void> _fetchPengaduan() async {
    final response = await http.get(Uri.parse('http://192.168.31.53/kejaksaan/pengaduan.php'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      if (parsed['data'] != null) {
        setState(() {
          _pengaduanList = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
          _filterPengaduanByRole();
          _isLoading = false;
        });

        for (var pengaduan in _pengaduanList) {
          await _fetchUserData(pengaduan.user_id);
        }
      }
    }
    setState(() {
      _isLoading = false; // Pastikan _isLoading diatur ke false di sini
    });
  }

  Future<void> _fetchUserData(String userId) async {
    final response = await http.get(Uri.parse('http://192.168.31.53/kejaksaan/getUser.php?id=$userId'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      print('Response for user $userId: $parsed'); // Print the response body to debug

      if (parsed['data'] != null && parsed['data'].isNotEmpty) {
        final userDataMap = parsed['data'][0]; // Assuming user data is returned as an array
        final userData = ModelUsers.fromJson(userDataMap);

        setState(() {
          _pengaduanList.forEach((pengaduan) {
            if (pengaduan.user_id == userId) {
              pengaduan.fullname = userData.fullname;
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

  void _filterPengaduanByRole() {
    if (role == 'User') {
      setState(() {
        _filteredPengaduanList = _pengaduanList.where((pengaduan) => pengaduan.user_id == userId).toList();
      });
    } else {
      setState(() {
        _filteredPengaduanList = _pengaduanList;
      });
    }
  }

  void _filterPengaduanList(String query) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.31.53/kejaksaan/pengaduan.php'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
        List<Datum> filteredData;
        if (query.isNotEmpty) {
          filteredData = allData.where((pengaduan) =>
          pengaduan.user_id.toLowerCase().contains(query.toLowerCase()) ||
              pengaduan.nama_pelapor.toLowerCase().contains(query.toLowerCase())).toList();
        } else {
          filteredData = allData;
        }
        setState(() {
          if (role == 'User') {
            _filteredPengaduanList = filteredData.where((pengaduan) => pengaduan.user_id == userId).toList();
          } else {
            _filteredPengaduanList = filteredData;
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

  Future<void> _saveStatus(Datum pengaduan, String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.31.53/kejaksaan/updateStatusPengaduan.php'),
        body: {
          'id': pengaduan.id,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        print('Status berhasil disimpan: $status');
        setState(() {
          pengaduan.status = status;
        });
      } else {
        print('Gagal menyimpan status: ${response.body}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  void _handleStatusButtonPress(Datum pengaduan) {
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
                  _saveStatus(pengaduan, 'Approved');
                },
                child: Text('Approve'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _saveStatus(pengaduan, 'Rejected');
                },
                child: Text('Reject'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _handleEdit(Datum pengaduan) async {
    // Menunggu hasil dari EditAliranPage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditPengaduanPage(pengaduan: pengaduan) // Pastikan AddAliranPage menerima parameter aliran
      ),
    );

    // Memeriksa apakah hasil pengeditan sukses
    if (result == true) {
      // Ambil ulang data dari server untuk merefresh tampilan
      _fetchPengaduan();
    }
  }

  Future<void> _handleDelete(Datum pengaduan) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.7/kejaksaan/deletepengaduan.php'),
        body: {
          'id': pengaduan.id,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _filteredPengaduanList.remove(pengaduan);
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
  void _handleItemClick(Datum pengaduan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengaduanDetailPage(pengaduan: pengaduan)
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Pengaduan",
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
                  onChanged: _filterPengaduanList,
                  decoration: InputDecoration(
                    labelText: 'Search Pengaduan',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredPengaduanList.isEmpty
                  ? Center(
                child: Text('Anda belum membuat permohonan'),
              )
                  : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _filteredPengaduanList.length,
                itemBuilder: (context, index) {
                if (_filteredPengaduanList.isEmpty) {
                  return Center(
                    child: Text('Belum ada permohonan'),
                  );
                } else {
                  final pengaduan = _filteredPengaduanList[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () => _handleItemClick(pengaduan),

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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pengaduan.laporan_pengaduan ?? '',
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
                                      (pengaduan.nama_pelapor ?? 'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tanggal Pelaporan: ' +
                                      (pengaduan.created_at ?? 'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Created by: ${pengaduan.fullname ??
                                      'Loading...'}',
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          _handleStatusButtonPress(pengaduan),
                                      child: Text(
                                        pengaduan.status,
                                        style: TextStyle(
                                          fontFamily: 'Jost',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // if (role == 'Customer' &&
                                    //     pengaduan.status == 'Pending') ...[
                                    //   Row(
                                    //     children: [
                                    //       IconButton(
                                    //         icon: Icon(Icons.edit),
                                    //         onPressed: () =>
                                    //             _handleEdit(pengaduan),
                                    //         tooltip: 'Edit',
                                    //       ),
                                    //       IconButton(
                                    //         icon: Icon(Icons.delete),
                                    //         onPressed: () =>
                                    //             _handleDelete(pengaduan),
                                    //         tooltip: 'Delete',
                                    //         color: Colors.red,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
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
              builder: (context) => AddPengaduanPage(), // Ganti dengan halaman penambahan data yang sesuai
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}

