// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:project_kejaksaan/home_page.dart';
// // import 'package:project_kejaksaan/login/login_page.dart';
// // import 'package:project_kejaksaan/models/model_pengaduan.dart';
// // import 'package:project_kejaksaan/models/model_user.dart';
// // import 'package:project_kejaksaan/pengaduan/add_pengaduan_page.dart';
// // import 'package:project_kejaksaan/utils/session_manager.dart';
// //
// // class ListPengaduanPage extends StatefulWidget {
// //   const ListPengaduanPage({Key? key}) : super(key: key);
// //
// //   @override
// //   State<ListPengaduanPage> createState() => _ListPengaduanPageState();
// // }
// //
// // class _ListPengaduanPageState extends State<ListPengaduanPage> {
// //   late List<Datum> _pengaduanList = [];
// //   late List<Datum> _filteredPengaduanList;
// //   late bool _isLoading;
// //   TextEditingController _searchController = TextEditingController();
// //   String? username;
// //   String? role; // Simpan peran pengguna (admin / customer)
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _isLoading = true;
// //     getDataSession();
// //     _fetchPengaduan();
// //     _filteredPengaduanList = [];
// //   }
// //
// //   Future<void> getDataSession() async {
// //     bool hasSession = await sessionManager.getSession();
// //     if (hasSession) {
// //       setState(() {
// //         username = sessionManager.username;
// //         role = sessionManager.role; // Simpan peran pengguna dari sesi
// //         print('Data session: $username');
// //       });
// //     } else {
// //       print('Session tidak ditemukan!');
// //     }
// //   }
// //
// //   Future<void> _fetchPengaduan() async {
// //     final response = await http.get(Uri.parse('http://192.168.1.8/kejaksaan/pengaduan.php'));
// //     if (response.statusCode == 200) {
// //       final parsed = jsonDecode(response.body);
// //       setState(() {
// //         _pengaduanList = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
// //         _filteredPengaduanList = _pengaduanList;
// //         _isLoading = false;
// //       });
// //
// //       // Ambil data pengguna berdasarkan user_id untuk setiap pengaduan
// //       for (var pengaduan in _pengaduanList) {
// //         await _fetchUserData(pengaduan.user_id);
// //       }
// //     } else {
// //       throw Exception('Failed to load pengaduan');
// //     }
// //   }
// //
// //   // Future<void> _fetchUserData(String userId) async {
// //   //   final response = await http.get(Uri.parse('http://192.168.31.52/kejaksaan/getUser.php?id=$userId'));
// //   //   if (response.statusCode == 200) {
// //   //     final parsed = jsonDecode(response.body);
// //   //     print(parsed); // Print the response body to debug
// //   //
// //   //     final userDataMap = parsed['data'][0]; // Assuming user data is returned as an array
// //   //     final userData = ModelUsers.fromJson(userDataMap);
// //   //
// //   //     // Update data pengaduan with user's fullname
// //   //     setState(() {
// //   //       _pengaduanList.forEach((pengaduan) {
// //   //         if (pengaduan.user_id == userId) {
// //   //           pengaduan.fullname = userData.fullname;
// //   //         }
// //   //       });
// //   //     });
// //   //   } else {
// //   //     throw Exception('Failed to load user data');
// //   //   }
// //   // }
// //   Future<void> _fetchUserData(String userId) async {
// //     final response = await http.get(Uri.parse('http://192.168.1.8/kejaksaan/getUser.php?id=$userId'));
// //     if (response.statusCode == 200) {
// //       final parsed = jsonDecode(response.body);
// //       print('Response for user $userId: $parsed'); // Print the response body to debug
// //
// //       if (parsed['data'] != null && parsed['data'].isNotEmpty) {
// //         final userDataMap = parsed['data'][0]; // Assuming user data is returned as an array
// //         final userData = ModelUsers.fromJson(userDataMap);
// //
// //         // Update data pengaduan with user's fullname
// //         setState(() {
// //           _pengaduanList.forEach((pengaduan) {
// //             if (pengaduan.user_id == userId) {
// //               pengaduan.fullname = userData.fullname;
// //             }
// //           });
// //         });
// //       } else {
// //         print('User data not found for user $userId');
// //       }
// //     } else {
// //       throw Exception('Failed to load user data');
// //     }
// //   }
// //
// //
// //   void _filterPengaduanList(String query) async {
// //     try {
// //       final response = await http.get(Uri.parse('http://192.168.1.8/kejaksaan/pengaduan.php'));
// //       if (response.statusCode == 200) {
// //         final parsed = jsonDecode(response.body);
// //         List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
// //         if (query.isNotEmpty) {
// //           setState(() {
// //             _filteredPengaduanList = allData.where((pengaduan) =>
// //             pengaduan.user_id.toLowerCase().contains(query.toLowerCase()) ||
// //                 pengaduan.status.toLowerCase().contains(query.toLowerCase())).toList();
// //           });
// //         } else {
// //           setState(() {
// //             _filteredPengaduanList = allData;
// //           });
// //         }
// //       } else {
// //         throw Exception('Failed to load data');
// //       }
// //     } catch (e) {
// //       setState(() {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text(e.toString()))
// //         );
// //       });
// //     }
// //   }
// //   Future<void> _saveStatus(Datum pengaduan, String status) async {
// //     try {
// //       // Kirim permintaan HTTP POST ke backend untuk menyimpan status
// //       final response = await http.post(
// //         Uri.parse('http://192.168.1.8/kejaksaan/updateStatusPengaduan.php'), // Sesuaikan dengan URL endpoint Anda
// //         body: {
// //           'id': pengaduan.id,
// //           'status': status,
// //         },
// //       );
// //
// //       // Periksa kode status HTTP untuk menentukan apakah permintaan berhasil
// //       if (response.statusCode == 200) {
// //         // Status berhasil disimpan
// //         print('Status berhasil disimpan: $status');
// //         // Update status pengaduan di dalam daftar lokal
// //         setState(() {
// //           pengaduan.status = status;
// //         });
// //       } else {
// //         // Gagal menyimpan status, tampilkan pesan kesalahan
// //         print('Gagal menyimpan status: ${response.body}');
// //       }
// //     } catch (e) {
// //       // Tangani kesalahan jika terjadi
// //       print('Terjadi kesalahan: $e');
// //     }
// //   }
// //
// //   // void _handleStatusButtonPress(Datum pengaduan) {
// //   //   // Lakukan sesuatu ketika status ditekan
// //   //   // Misalnya, jika pengguna adalah admin, izinkan mereka untuk menyetujui atau menolak pengaduan
// //   //   if (role == 'Admin') { // Cek apakah pengguna adalah admin
// //   //     // Misalnya, Anda dapat menampilkan dialog konfirmasi
// //   //     showDialog(
// //   //       context: context,
// //   //       builder: (BuildContext context) {
// //   //         return AlertDialog(
// //   //           title: Text('Approve Pengaduan?'),
// //   //           content: Text('Apakah Anda ingin menyetujui pengaduan ini?'),
// //   //           actions: <Widget>[
// //   //             TextButton(
// //   //               onPressed: () {
// //   //                 // Lakukan tindakan untuk menyetujui pengaduan di sini
// //   //                 // Misalnya, kirim permintaan HTTP ke backend untuk memperbarui status pengaduan menjadi disetujui
// //   //                 Navigator.of(context).pop(); // Tutup dialog
// //   //               },
// //   //               child: Text('Approve'),
// //   //             ),
// //   //             TextButton(
// //   //               onPressed: () {
// //   //                 // Lakukan tindakan untuk menolak pengaduan di sini
// //   //                 // Misalnya, kirim permintaan HTTP ke backend untuk memperbarui status pengaduan menjadi ditolak
// //   //                 Navigator.of(context).pop(); // Tutup dialog
// //   //               },
// //   //               child: Text('Reject'),
// //   //             ),
// //   //           ],
// //   //         );
// //   //       },
// //   //     );
// //   //   }
// //   // }
// //   void _handleStatusButtonPress(Datum pengaduan) {
// //     // Lakukan sesuatu ketika status ditekan
// //     // Misalnya, jika pengguna adalah admin, izinkan mereka untuk menyetujui atau menolak pengaduan
// //     if (role == 'Admin') {
// //       // Menampilkan dialog konfirmasi
// //       showDialog(
// //         context: context,
// //         builder: (BuildContext context) {
// //           return AlertDialog(
// //             title: Text('Approve Pengaduan?'),
// //             content: Text('Apakah Anda ingin menyetujui pengaduan ini?'),
// //             actions: <Widget>[
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.of(context).pop(); // Tutup dialog
// //                   _saveStatus(pengaduan, 'Approved'); // Simpan status sebagai disetujui
// //                 },
// //                 child: Text('Approve'),
// //               ),
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.of(context).pop(); // Tutup dialog
// //                   _saveStatus(pengaduan, 'Rejected'); // Simpan status sebagai ditolak
// //                 },
// //                 child: Text('Reject'),
// //               ),
// //             ],
// //           );
// //         },
// //       );
// //     }
// //   }
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(
// //           "List Pengaduan",
// //           style: TextStyle(
// //             fontFamily: 'Jost',
// //             fontSize: 18,
// //             fontWeight: FontWeight.bold,
// //           ),
// //         ),
// //         backgroundColor: Color(0xFF5BB04B),
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back),
// //           onPressed: () {
// //             Navigator.pushAndRemoveUntil(
// //               context,
// //               MaterialPageRoute(builder: (context) => HomePage()), // Ganti dengan halaman beranda yang sesuai
// //                   (route) => false,
// //             );
// //           },
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () {},
// //             child: Text(
// //               'Hi, ${username ?? ''}',
// //               style: TextStyle(
// //                   color: Colors.black,
// //                   fontSize: 18,
// //                   fontFamily: 'Jost'
// //               ),
// //             ),
// //           ),
// //           IconButton(
// //             icon: const Icon(Icons.exit_to_app),
// //             tooltip: 'Logout',
// //             color: Colors.black,
// //             onPressed: () {
// //               setState(() {
// //                 sessionManager.clearSession();
// //                 Navigator.pushAndRemoveUntil(
// //                   context,
// //                   MaterialPageRoute(builder: (context) => LoginPage()),
// //                       (route) => false,
// //                 );
// //               });
// //             },
// //           ),
// //         ],
// //       ),
// //       backgroundColor: Color(0xFF5BB04B),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: EdgeInsets.symmetric(horizontal: 16.0),
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               Padding(
// //                 padding: EdgeInsets.all(8.0),
// //                 child: TextField(
// //                   controller: _searchController,
// //                   onChanged: _filterPengaduanList,
// //                   decoration: InputDecoration(
// //                     labelText: 'Search Pengaduan',
// //                     prefixIcon: Icon(Icons.search),
// //                     border: OutlineInputBorder(),
// //                   ),
// //                 ),
// //               ),
// //               _isLoading
// //                   ? Center(child: CircularProgressIndicator())
// //                   : ListView.builder(
// //                 physics: NeverScrollableScrollPhysics(),
// //                 shrinkWrap: true,
// //                 itemCount: _filteredPengaduanList.length,
// //                 itemBuilder: (context, index) {
// //                   final pengaduan = _filteredPengaduanList[index];
// //                   return Padding(
// //                     padding: EdgeInsets.only(bottom: 16.0),
// //                     child: GestureDetector(
// //                       onTap: () {
// //                         // Navigasi ke CompletedLesson ketika card diklik
// //                         // Navigator.push(
// //                         //   context,
// //                         //   MaterialPageRoute(
// //                         //     builder: (context) => CompletedLesson()),
// //                         // );
// //                       },
// //                       child: Stack(
// //                         children: [
// //                           Container(
// //                             margin: EdgeInsets.only(top: 12),
// //                             padding: EdgeInsets.all(16.0), // Added padding to make the text centered
// //                             decoration: BoxDecoration(
// //                               shape: BoxShape.rectangle,
// //                               borderRadius:
// //                               BorderRadius.all(Radius.circular(15)),
// //                               color: Color(0xFFFFFFFF),
// //                             ),
// //                             child: Row(
// //                               mainAxisAlignment: MainAxisAlignment.spaceBetween, // Set to expand horizontally
// //                               children: [
// //                                 Expanded( // Expanded to take remaining space
// //                                   child: Column(
// //                                     crossAxisAlignment: CrossAxisAlignment.start,
// //                                     children: [
// //                                       Text(
// //                                         pengaduan.laporan_pengaduan ?? '', // Menampilkan laporan pengaduan di atas tombol status
// //                                         style: TextStyle(
// //                                           fontFamily: 'Jost',
// //                                           fontSize: 20, // Increased font size
// //                                           color: Colors.orange,
// //                                           fontWeight: FontWeight.bold,
// //                                         ),
// //                                       ),
// //                                       SizedBox(height: 8), // Added SizedBox for spacing
// //                                       Text(
// //                                         'Nama Pelapor: ' + (pengaduan.nama_pelapor ?? 'Loading...'),
// //                                         style: TextStyle(
// //                                           fontFamily: 'Jost',
// //                                           fontSize: 14,
// //                                           color: Colors.black,
// //                                         ),
// //                                       ),
// //                                       SizedBox(height: 8), // Added SizedBox for spacing
// //                                       Text(
// //                                         'Tanggal Pelaporan: ' + (pengaduan.created_at ?? 'Loading...'), // Tampilkan field created_at
// //                                         style: TextStyle(
// //                                           fontFamily: 'Jost',
// //                                           fontSize: 14,
// //                                           color: Colors.black,
// //                                         ),
// //                                       ),
// //                                       SizedBox(height: 20), // Added SizedBox for spacing
// //                                       Text(
// //                                         'Created by: ${pengaduan.fullname ?? 'Loading...'}', // Display the fullname as "created by" information
// //                                         style: TextStyle(
// //                                           fontFamily: 'Jost',
// //                                           fontSize: 14,
// //                                           color: Colors.black,
// //                                           fontWeight: FontWeight.bold
// //                                         ),
// //                                       ),
// //                                       SizedBox(height: 8), // Added SizedBox for spacing
// //                                       ElevatedButton(
// //                                         onPressed: () => _handleStatusButtonPress(pengaduan),
// //                                         child: Text(
// //                                           pengaduan.status,
// //                                           style: TextStyle(
// //                                             fontFamily: 'Jost',
// //                                             fontSize: 14,
// //                                             fontWeight: FontWeight.w600,
// //                                           ),
// //                                           maxLines: 2,
// //                                           overflow: TextOverflow.ellipsis,
// //                                         ),
// //                                       ),
// //                                     ],
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (context) => AddPengaduanPage(), // Ganti dengan halaman penambahan data yang sesuai
// //             ),
// //           );
// //         },
// //         backgroundColor: Colors.green,
// //         child: Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:project_kejaksaan/home_page.dart';
// import 'package:project_kejaksaan/login/login_page.dart';
// import 'package:project_kejaksaan/models/model_pengaduan.dart';
// import 'package:project_kejaksaan/models/model_user.dart';
// import 'package:project_kejaksaan/pengaduan/add_pengaduan_page.dart';
// import 'package:project_kejaksaan/pengaduan/edit_pengaduan_page.dart';
// import 'package:project_kejaksaan/utils/session_manager.dart';
//
// class ListPengaduanPage extends StatefulWidget {
//   const ListPengaduanPage({Key? key}) : super(key: key);
//
//   @override
//   State<ListPengaduanPage> createState() => _ListPengaduanPageState();
// }
//
// class _ListPengaduanPageState extends State<ListPengaduanPage> {
//   late List<Datum> _pengaduanList = [];
//   late List<Datum> _filteredPengaduanList;
//   late bool _isLoading;
//   TextEditingController _searchController = TextEditingController();
//   String? username;
//   String? role; // Simpan peran pengguna (admin / customer)
//   String? userId; // Simpan user_id dari sesi
//
//   @override
//   void initState() {
//     super.initState();
//     _isLoading = true;
//     getDataSession();
//     _fetchPengaduan();
//     _filteredPengaduanList = [];
//   }
//
//   Future<void> getDataSession() async {
//     bool hasSession = await sessionManager.getSession();
//     if (hasSession) {
//       setState(() {
//         username = sessionManager.username;
//         role = sessionManager.role; // Simpan peran pengguna dari sesi
//         userId = sessionManager.id; // Simpan user_id dari sesi
//         print('Data session: $username');
//       });
//     } else {
//       print('Session tidak ditemukan!');
//     }
//   }
//
//   Future<void> _fetchPengaduan() async {
//     final response = await http.get(Uri.parse('http://192.168.1.8/kejaksaan/pengaduan.php'));
//     if (response.statusCode == 200) {
//       final parsed = jsonDecode(response.body);
//       setState(() {
//         _pengaduanList = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
//         _filterPengaduanByRole();
//         _isLoading = false;
//       });
//
//       for (var pengaduan in _pengaduanList) {
//         await _fetchUserData(pengaduan.user_id);
//       }
//     } else {
//       throw Exception('Failed to load pengaduan');
//     }
//   }
//
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
//         setState(() {
//           _pengaduanList.forEach((pengaduan) {
//             if (pengaduan.user_id == userId) {
//               pengaduan.fullname = userData.fullname;
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
//   void _filterPengaduanByRole() {
//     if (role == 'Customer') {
//       setState(() {
//         _filteredPengaduanList = _pengaduanList.where((pengaduan) => pengaduan.user_id == userId).toList();
//       });
//     } else {
//       setState(() {
//         _filteredPengaduanList = _pengaduanList;
//       });
//     }
//   }
//
//   void _filterPengaduanList(String query) async {
//     try {
//       final response = await http.get(Uri.parse('http://192.168.1.8/kejaksaan/pengaduan.php'));
//       if (response.statusCode == 200) {
//         final parsed = jsonDecode(response.body);
//         List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
//         List<Datum> filteredData;
//         if (query.isNotEmpty) {
//           filteredData = allData.where((pengaduan) =>
//           pengaduan.user_id.toLowerCase().contains(query.toLowerCase()) ||
//               pengaduan.status.toLowerCase().contains(query.toLowerCase())).toList();
//         } else {
//           filteredData = allData;
//         }
//         setState(() {
//           if (role == 'Customer') {
//             _filteredPengaduanList = filteredData.where((pengaduan) => pengaduan.user_id == userId).toList();
//           } else {
//             _filteredPengaduanList = filteredData;
//           }
//         });
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       setState(() {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
//       });
//     }
//   }
//
//   Future<void> _saveStatus(Datum pengaduan, String status) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.1.8/kejaksaan/updateStatusPengaduan.php'),
//         body: {
//           'id': pengaduan.id,
//           'status': status,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         print('Status berhasil disimpan: $status');
//         setState(() {
//           pengaduan.status = status;
//         });
//       } else {
//         print('Gagal menyimpan status: ${response.body}');
//       }
//     } catch (e) {
//       print('Terjadi kesalahan: $e');
//     }
//   }
//
//   void _handleStatusButtonPress(Datum pengaduan) {
//     if (role == 'Admin') {
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Approve Pengaduan?'),
//             content: Text('Apakah Anda ingin menyetujui pengaduan ini?'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   _saveStatus(pengaduan, 'Approved');
//                 },
//                 child: Text('Approve'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   _saveStatus(pengaduan, 'Rejected');
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
//   Future<void> _handleEdit(Datum pengaduan) async {
//     // Menunggu hasil dari EditAliranPage
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditPengaduanPage(pengaduan: pengaduan) // Pastikan AddAliranPage menerima parameter aliran
//       ),
//     );
//
//     // Memeriksa apakah hasil pengeditan sukses
//     if (result == true) {
//       // Ambil ulang data dari server untuk merefresh tampilan
//       _fetchPengaduan();
//     }
//   }
//
//   Future<void> _handleDelete(Datum pengaduan) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.1.8/kejaksaan/deletepengaduan.php'),
//         body: {
//           'id': pengaduan.id,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         setState(() {
//           _filteredPengaduanList.remove(pengaduan);
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Data berhasil dihapus')),
//         );
//       } else {
//         print('Gagal menghapus data: ${response.body}');
//       }
//     } catch (e) {
//       print('Terjadi kesalahan: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "List Pengaduan",
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
//               MaterialPageRoute(builder: (context) => HomePage()),
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
//                 color: Colors.black,
//                 fontSize: 18,
//                 fontFamily: 'Jost',
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
//                   onChanged: _filterPengaduanList,
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
//                 itemCount: _filteredPengaduanList.length,
//                 itemBuilder: (context, index) {
//                   final pengaduan = _filteredPengaduanList[index];
//                   return Padding(
//                     padding: EdgeInsets.only(bottom: 16.0),
//                     child: GestureDetector(
//                       onTap: () {},
//                       child: Stack(
//                         children: [
//                           Container(
//                             margin: EdgeInsets.only(top: 12),
//                             padding: EdgeInsets.all(16.0),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.rectangle,
//                               borderRadius: BorderRadius.all(Radius.circular(15)),
//                               color: Color(0xFFFFFFFF),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   pengaduan.laporan_pengaduan ?? '',
//                                   style: TextStyle(
//                                     fontFamily: 'Jost',
//                                     fontSize: 20,
//                                     color: Colors.orange,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   'Nama Pelapor: ' + (pengaduan.nama_pelapor ?? 'Loading...'),
//                                   style: TextStyle(
//                                     fontFamily: 'Jost',
//                                     fontSize: 14,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Text(
//                                   'Tanggal Pelaporan: ' + (pengaduan.created_at ?? 'Loading...'),
//                                   style: TextStyle(
//                                     fontFamily: 'Jost',
//                                     fontSize: 14,
//                                     color: Colors.black,
//                                   ),
//                                 ),
//                                 SizedBox(height: 20),
//                                 Text(
//                                   'Created by: ${pengaduan.fullname ?? 'Loading...'}',
//                                   style: TextStyle(
//                                     fontFamily: 'Jost',
//                                     fontSize: 14,
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 SizedBox(height: 8),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     ElevatedButton(
//                                       onPressed: () => _handleStatusButtonPress(pengaduan),
//                                       child: Text(
//                                         pengaduan.status,
//                                         style: TextStyle(
//                                           fontFamily: 'Jost',
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                     if (role == 'Customer' && pengaduan.status == 'Pending') ...[
//                                       Row(
//                                         children: [
//                                           IconButton(
//                                             icon: Icon(Icons.edit),
//                                             onPressed: () => _handleEdit(pengaduan),
//                                             tooltip: 'Edit',
//                                           ),
//                                           IconButton(
//                                             icon: Icon(Icons.delete),
//                                             onPressed: () => _handleDelete(pengaduan),
//                                             tooltip: 'Delete',
//                                             color: Colors.red,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ],
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
//               builder: (context) => AddPengaduanPage(), // Ganti dengan halaman penambahan data yang sesuai
//             ),
//           );
//         },
//         backgroundColor: Colors.green,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
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

  Future<void> _fetchPengaduan() async {
    final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/pengaduan.php'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      setState(() {
        _pengaduanList = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
        _filterPengaduanByRole();
        _isLoading = false;
      });

      for (var pengaduan in _pengaduanList) {
        await _fetchUserData(pengaduan.user_id);
      }
    } else {
      throw Exception('Failed to load pengaduan');
    }
  }

  Future<void> _fetchUserData(String userId) async {
    final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/getUser.php?id=$userId'));
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
    if (role == 'Customer') {
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
      final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/pengaduan.php'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
        List<Datum> filteredData;
        if (query.isNotEmpty) {
          filteredData = allData.where((pengaduan) =>
          pengaduan.user_id.toLowerCase().contains(query.toLowerCase()) ||
              pengaduan.status.toLowerCase().contains(query.toLowerCase())).toList();
        } else {
          filteredData = allData;
        }
        setState(() {
          if (role == 'Customer') {
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
        Uri.parse('http://192.168.1.7/kejaksaan/updateStatusPengaduan.php'),
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
                  : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _filteredPengaduanList.length,
                itemBuilder: (context, index) {
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
                              borderRadius: BorderRadius.all(Radius.circular(15)),
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
                                  'Nama Pelapor: ' + (pengaduan.nama_pelapor ?? 'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tanggal Pelaporan: ' + (pengaduan.created_at ?? 'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Created by: ${pengaduan.fullname ?? 'Loading...'}',
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
                                      onPressed: () => _handleStatusButtonPress(pengaduan),
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
                                    if (role == 'Customer' && pengaduan.status == 'Pending') ...[
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () => _handleEdit(pengaduan),
                                            tooltip: 'Edit',
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => _handleDelete(pengaduan),
                                            tooltip: 'Delete',
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ],
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

