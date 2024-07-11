// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:project_kejaksaan/home_page.dart';
// import 'package:project_kejaksaan/login/login_page.dart';
// import 'package:project_kejaksaan/models/model_user.dart';
// import 'package:project_kejaksaan/pengaduan/add_pengaduan_page.dart';
// import 'package:project_kejaksaan/pidana/add_pidana_page.dart';
// import 'package:project_kejaksaan/utils/session_manager.dart';
//
// import '../models/model_pidana.dart';
//
// class ListPidanaPage extends StatefulWidget {
//   const ListPidanaPage({super.key});
//
//   @override
//   State<ListPidanaPage> createState() => _ListPidanaPageState();
// }
//
// class _ListPidanaPageState extends State<ListPidanaPage> {
//   late List<Datum> _pidanaList = [];
//   late List<Datum> _filteredPidanaList;
//   late bool _isLoading;
//   TextEditingController _searchController = TextEditingController();
//   String? username;
//   String? role; // Simpan peran pengguna (admin / customer)
//
//   @override
//   void initState() {
//     super.initState();
//     _isLoading = true;
//     getDataSession();
//     _fetchPidana();
//     _filteredPidanaList = [];
//   }
//
//   Future<void> getDataSession() async {
//     bool hasSession = await sessionManager.getSession();
//     if (hasSession) {
//       setState(() {
//         username = sessionManager.username;
//         role = sessionManager.role; // Simpan peran pengguna dari sesi
//         print('Data session: $username');
//       });
//     } else {
//       print('Session tidak ditemukan!');
//     }
//   }
//
//   Future<void> _fetchPidana() async {
//     final response = await http.get(Uri.parse('http://192.168.1.8/kejaksaan/pidana.php'));
//     if (response.statusCode == 200) {
//       final parsed = jsonDecode(response.body);
//       setState(() {
//         _pidanaList = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
//         _filteredPidanaList = _pidanaList;
//         _isLoading = false;
//       });
//
//       // Ambil data pengguna berdasarkan user_id untuk setiap pengaduan
//       for (var pidana in _pidanaList) {
//         await _fetchUserData(pidana.user_id);
//       }
//     } else {
//       throw Exception('Failed to load pengaduan');
//     }
//   }
//
//   // Future<void> _fetchUserData(String userId) async {
//   //   final response = await http.get(Uri.parse('http://192.168.31.52/kejaksaan/getUser.php?id=$userId'));
//   //   if (response.statusCode == 200) {
//   //     final parsed = jsonDecode(response.body);
//   //     print(parsed); // Print the response body to debug
//   //
//   //     final userDataMap = parsed['data'][0]; // Assuming user data is returned as an array
//   //     final userData = ModelUsers.fromJson(userDataMap);
//   //
//   //     // Update data pengaduan with user's fullname
//   //     setState(() {
//   //       _pengaduanList.forEach((pengaduan) {
//   //         if (pengaduan.user_id == userId) {
//   //           pengaduan.fullname = userData.fullname;
//   //         }
//   //       });
//   //     });
//   //   } else {
//   //     throw Exception('Failed to load user data');
//   //   }
//   // }
//   Future<void> _fetchUserData(String userId) async {
//     final response = await http.get(Uri.parse('http://192.168.1.8/kejaksaan/getUser.php?id=$userId'));
//     if (response.statusCode == 200) {
//       final parsed = jsonDecode(response.body);
//       print('Response for user $userId: $parsed'); // Print the response body to debug
//
//       if (parsed['data'] != null && parsed['data'].isNotEmpty) {
//         final userDataMap = parsed['data'][0]; // Assuming user data is returned as an array
//         final userData = ModelUsers.fromJson(userDataMap);
//
//         // Update data pengaduan with user's fullname
//         setState(() {
//           _pidanaList.forEach((pidana) {
//             if (pidana.user_id == userId) {
//               pidana.fullname = userData.fullname;
//             }
//           });
//         });
//       } else {
//         print('User data not found for user $userId');
//       }
//     } else {
//       throw Exception('Failed to load user data');
//     }
//   }
//
//
//   void _filterPidanaList(String query) async {
//     try {
//       final response = await http.get(Uri.parse('http://192.168.1.8/kejaksaan/pidana.php'));
//       if (response.statusCode == 200) {
//         final parsed = jsonDecode(response.body);
//         List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
//         if (query.isNotEmpty) {
//           setState(() {
//             _filteredPidanaList = allData.where((pidana) =>
//             pidana.user_id.toLowerCase().contains(query.toLowerCase()) ||
//                 pidana.status.toLowerCase().contains(query.toLowerCase())).toList();
//           });
//         } else {
//           setState(() {
//             _filteredPidanaList = allData;
//           });
//         }
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       setState(() {
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(e.toString()))
//         );
//       });
//     }
//   }
//   Future<void> _saveStatus(Datum pidana, String status) async {
//     try {
//       // Kirim permintaan HTTP POST ke backend untuk menyimpan status
//       final response = await http.post(
//         Uri.parse('http://192.168.1.8/kejaksaan/updateStatusPidana.php'), // Sesuaikan dengan URL endpoint Anda
//         body: {
//           'id': pidana.id,
//           'status': status,
//         },
//       );
//
//       // Periksa kode status HTTP untuk menentukan apakah permintaan berhasil
//       if (response.statusCode == 200) {
//         // Status berhasil disimpan
//         print('Status berhasil disimpan: $status');
//         // Update status pengaduan di dalam daftar lokal
//         setState(() {
//           pidana.status = status;
//         });
//       } else {
//         // Gagal menyimpan status, tampilkan pesan kesalahan
//         print('Gagal menyimpan status: ${response.body}');
//       }
//     } catch (e) {
//       // Tangani kesalahan jika terjadi
//       print('Terjadi kesalahan: $e');
//     }
//   }
//
//   // void _handleStatusButtonPress(Datum pengaduan) {
//   //   // Lakukan sesuatu ketika status ditekan
//   //   // Misalnya, jika pengguna adalah admin, izinkan mereka untuk menyetujui atau menolak pengaduan
//   //   if (role == 'Admin') { // Cek apakah pengguna adalah admin
//   //     // Misalnya, Anda dapat menampilkan dialog konfirmasi
//   //     showDialog(
//   //       context: context,
//   //       builder: (BuildContext context) {
//   //         return AlertDialog(
//   //           title: Text('Approve Pengaduan?'),
//   //           content: Text('Apakah Anda ingin menyetujui pengaduan ini?'),
//   //           actions: <Widget>[
//   //             TextButton(
//   //               onPressed: () {
//   //                 // Lakukan tindakan untuk menyetujui pengaduan di sini
//   //                 // Misalnya, kirim permintaan HTTP ke backend untuk memperbarui status pengaduan menjadi disetujui
//   //                 Navigator.of(context).pop(); // Tutup dialog
//   //               },
//   //               child: Text('Approve'),
//   //             ),
//   //             TextButton(
//   //               onPressed: () {
//   //                 // Lakukan tindakan untuk menolak pengaduan di sini
//   //                 // Misalnya, kirim permintaan HTTP ke backend untuk memperbarui status pengaduan menjadi ditolak
//   //                 Navigator.of(context).pop(); // Tutup dialog
//   //               },
//   //               child: Text('Reject'),
//   //             ),
//   //           ],
//   //         );
//   //       },
//   //     );
//   //   }
//   // }
//   void _handleStatusButtonPress(Datum pidana) {
//     // Lakukan sesuatu ketika status ditekan
//     // Misalnya, jika pengguna adalah admin, izinkan mereka untuk menyetujui atau menolak pengaduan
//     if (role == 'Admin') {
//       // Menampilkan dialog konfirmasi
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Approve Pengaduan?'),
//             content: Text('Apakah Anda ingin menyetujui pengaduan ini?'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Tutup dialog
//                   _saveStatus(pidana, 'Approved'); // Simpan status sebagai disetujui
//                 },
//                 child: Text('Approve'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop(); // Tutup dialog
//                   _saveStatus(pidana, 'Rejected'); // Simpan status sebagai ditolak
//                 },
//                 child: Text('Reject'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "List Tindak Pidana Korupsi",
//           style: TextStyle(
//             fontFamily: 'Jost',
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Color(0xFF5BB04B),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pushAndRemoveUntil(
//               context,
//               MaterialPageRoute(builder: (context) => HomePage()), // Ganti dengan halaman beranda yang sesuai
//                   (route) => false,
//             );
//           },
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: Text(
//               'Hi, ${username ?? ''}',
//               style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 18,
//                   fontFamily: 'Jost'
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.exit_to_app),
//             tooltip: 'Logout',
//             color: Colors.black,
//             onPressed: () {
//               setState(() {
//                 sessionManager.clearSession();
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginPage()),
//                       (route) => false,
//                 );
//               });
//             },
//           ),
//         ],
//       ),
//       backgroundColor: Color(0xFF5BB04B),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: _searchController,
//                   onChanged: _filterPidanaList,
//                   decoration: InputDecoration(
//                     labelText: 'Search Pengaduan',
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ),
//               _isLoading
//                   ? Center(child: CircularProgressIndicator())
//                   : ListView.builder(
//                 physics: NeverScrollableScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: _filteredPidanaList.length,
//                 itemBuilder: (context, index) {
//                   final pidana = _filteredPidanaList[index];
//                   return Padding(
//                     padding: EdgeInsets.only(bottom: 16.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         // Navigasi ke CompletedLesson ketika card diklik
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (context) => CompletedLesson()),
//                         // );
//                       },
//                       child: Stack(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(top: 12),
//                             padding: EdgeInsets.all(16.0), // Added padding to make the text centered
//                             decoration: BoxDecoration(
//                               shape: BoxShape.rectangle,
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(15)),
//                               color: Color(0xFFFFFFFF),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween, // Set to expand horizontally
//                               children: [
//                                 Expanded( // Expanded to take remaining space
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         pidana.laporan_pengaduan ?? '', // Menampilkan laporan pengaduan di atas tombol status
//                                         style: TextStyle(
//                                           fontFamily: 'Jost',
//                                           fontSize: 20, // Increased font size
//                                           color: Colors.orange,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(height: 8), // Added SizedBox for spacing
//                                       Text(
//                                         'Nama Pelapor: ' + (pidana.nama_pelapor ?? 'Loading...'),
//                                         style: TextStyle(
//                                           fontFamily: 'Jost',
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       SizedBox(height: 8), // Added SizedBox for spacing
//                                       Text(
//                                         'Tanggal Pelaporan: ' + (pidana.created_at ?? 'Loading...'), // Tampilkan field created_at
//                                         style: TextStyle(
//                                           fontFamily: 'Jost',
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       SizedBox(height: 20), // Added SizedBox for spacing
//                                       Text(
//                                         'Created by: ${pidana.fullname ?? 'Loading...'}', // Display the fullname as "created by" information
//                                         style: TextStyle(
//                                             fontFamily: 'Jost',
//                                             fontSize: 14,
//                                             color: Colors.black,
//                                             fontWeight: FontWeight.bold
//                                         ),
//                                       ),
//                                       SizedBox(height: 8), // Added SizedBox for spacing
//                                       ElevatedButton(
//                                         onPressed: () => _handleStatusButtonPress(pidana),
//                                         child: Text(
//                                           pidana.status,
//                                           style: TextStyle(
//                                             fontFamily: 'Jost',
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w600,
//                                           ),
//                                           maxLines: 2,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AddPidanaPage(), // Ganti dengan halaman penambahan data yang sesuai
//             ),
//           );
//         },
//         backgroundColor: Colors.green,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
//
//
//
//
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_kejaksaan/home_page.dart';
import 'package:project_kejaksaan/login/login_page.dart';
import 'package:project_kejaksaan/models/model_user.dart';
import 'package:project_kejaksaan/pidana/add_pidana_page.dart';
import 'package:project_kejaksaan/pidana/edit_pidana_page.dart';
import 'package:project_kejaksaan/pidana/pidana_detail_page.dart';
import 'package:project_kejaksaan/utils/session_manager.dart';

import '../models/model_pidana.dart';

class ListPidanaPage extends StatefulWidget {
  const ListPidanaPage({super.key});

  @override
  State<ListPidanaPage> createState() => _ListPidanaPageState();
}

class _ListPidanaPageState extends State<ListPidanaPage> {
  late List<Datum> _pidanaList = [];
  late List<Datum> _filteredPidanaList;
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
    _fetchPidana();
    _filteredPidanaList = [];
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

  Future<void> _fetchPidana() async {
    final response = await http.get(Uri.parse('http://192.168.1.3/kejaksaan/pidana.php'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      if (parsed['data'] != null) {
        setState(() {
          _pidanaList = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
          _filterPidanaByRole();
        });

        for (var pidana in _pidanaList) {
          await _fetchUserData(pidana.user_id);
        }
      }
    }
    setState(() {
      _isLoading = false; // Pastikan _isLoading diatur ke false di sini
    });

  }

  Future<void> _fetchUserData(String userId) async {
    final response = await http.get(Uri.parse('http://192.168.1.3/kejaksaan/getUser.php?id=$userId'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      print('Response for user $userId: $parsed'); // Print the response body to debug

      if (parsed['data'] != null && parsed['data'].isNotEmpty) {
        final userDataMap = parsed['data'][0]; // Assuming user data is returned as an array
        final userData = ModelUsers.fromJson(userDataMap);

        setState(() {
          _pidanaList.forEach((pidana) {
            if (pidana.user_id == userId) {
              pidana.fullname = userData.fullname;
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

  void _filterPidanaByRole() {
    if (role == 'User') {
      setState(() {
        _filteredPidanaList = _pidanaList.where((pidana) => pidana.user_id == userId).toList();
      });
    } else {
      setState(() {
        _filteredPidanaList = _pidanaList;
      });
    }
  }

  void _filterPidanaList(String query) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.3/kejaksaan/pidana.php'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
        List<Datum> filteredData;
        if (query.isNotEmpty) {
          filteredData = allData.where((pidana) =>
          pidana.user_id.toLowerCase().contains(query.toLowerCase()) ||
              pidana.nama_pelapor.toLowerCase().contains(query.toLowerCase())).toList();
        } else {
          filteredData = allData;
        }
        setState(() {
          if (role == 'User') {
            _filteredPidanaList = filteredData.where((pidana) => pidana.user_id == userId).toList();
          } else {
            _filteredPidanaList = filteredData;
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

  Future<void> _saveStatus(Datum pidana, String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.3/kejaksaan/updateStatusPidana.php'),
        body: {
          'id': pidana.id,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        print('Status berhasil disimpan: $status');
        setState(() {
          pidana.status = status;
        });
      } else {
        print('Gagal menyimpan status: ${response.body}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  void _handleStatusButtonPress(Datum pidana) {
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
                  _saveStatus(pidana, 'Approved');
                },
                child: Text('Approve'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _saveStatus(pidana, 'Rejected');
                },
                child: Text('Reject'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _handleEdit(Datum pidana) async {
    // Menunggu hasil dari EditAliranPage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditPidanaPage(pidana: pidana)
      ),
    );

    // Memeriksa apakah hasil pengeditan sukses
    if (result == true) {
      // Ambil ulang data dari server untuk merefresh tampilan
      _fetchPidana();
    }
  }
  Future<void> _handleDelete(Datum pidana) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.3/kejaksaan/deletepidana.php'), // Sesuaikan dengan URL endpoint untuk hapus data
        body: {
          'id': pidana.id,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _filteredPidanaList.remove(pidana);
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
  void _handleItemClick(Datum pidana) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PidanaDetailPage(pidana: pidana)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Tindak Pidana",
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
                  onChanged: _filterPidanaList,
                  decoration: InputDecoration(
                    labelText: 'Search Pidana',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _filteredPidanaList.isEmpty
                  ? Center(
                child: Text('Anda belum membuat permohonan'),
              )
                  : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _filteredPidanaList.length,
                itemBuilder: (context, index) {
                  final pidana = _filteredPidanaList[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: GestureDetector(
                      onTap: () => _handleItemClick(pidana),
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 12),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              color: Color(0xFFFFFFFF),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pidana.laporan_pengaduan ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 20,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Nama Pelapor: ' + (pidana.nama_pelapor ?? 'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tanggal Pelaporan: ' + (pidana.created_at ?? 'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Created by: ${pidana.fullname ?? 'Loading...'}',
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>_handleStatusButtonPress(pidana),
                                      child: Text(
                                        pidana.status,
                                        style: TextStyle(
                                          fontFamily: 'Jost',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // if (role == 'Customer' && pidana.status == 'Pending') ...[
                                    //   Row(
                                    //     children: [
                                    //       IconButton(
                                    //         icon: Icon(Icons.edit),
                                    //         onPressed: () => _handleEdit(pidana),
                                    //         tooltip: 'Edit',
                                    //       ),
                                    //       IconButton(
                                    //         icon: Icon(Icons.delete),
                                    //         onPressed: () => _handleDelete(pidana),
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
              builder: (context) => AddPidanaPage(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
