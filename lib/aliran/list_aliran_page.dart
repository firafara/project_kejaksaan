// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:project_kejaksaan/aliran/add_aliran_page.dart';
// import 'package:project_kejaksaan/home_page.dart';
// import 'package:project_kejaksaan/login/login_page.dart';
// import 'package:project_kejaksaan/models/model_aliran.dart';
// import 'package:project_kejaksaan/models/model_user.dart';
// import 'package:project_kejaksaan/utils/session_manager.dart';
// import 'package:http/http.dart' as http;
//
// class ListAliranPage extends StatefulWidget {
//   const ListAliranPage({super.key});
//
//   @override
//   State<ListAliranPage> createState() => _ListAliranPageState();
// }
//
// class _ListAliranPageState extends State<ListAliranPage> {
//   late List<Datum> _aliranList = [];
//   late List<Datum> _filteredAliranList;
//   late bool _isLoading;
//   TextEditingController _searchController = TextEditingController();
//   String? username;
//   String? role;
//   String? userId; // Simpan user_id dari sesi
//
//   @override
//   void initState() {
//     super.initState();
//     _isLoading = true;
//     getDataSession();
//     _fetchAliran();
//     _filteredAliranList = [];
//   }
//
//   Future<void> getDataSession() async {
//     bool hasSession = await sessionManager.getSession();
//     if (hasSession) {
//       setState(() {
//         username = sessionManager.username;
//         role = sessionManager.role;
//         userId = sessionManager.id; // Simpan user_id dari sesi
//         print('Data session: $username');
//       });
//     } else {
//       print('Session tidak ditemukan!');
//     }
//   }
//
//   Future<void> _fetchAliran() async {
//     final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/pengawasan.php'));
//     if (response.statusCode == 200) {
//       final parsed = jsonDecode(response.body);
//       setState(() {
//         _aliranList = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
//         _filterAliranByRole();
//         _isLoading = false;
//       });
//
//       for (var aliran in _aliranList) {
//         await _fetchUserData(aliran.user_id);
//       }
//     } else {
//       throw Exception('Failed to load pengaduan');
//     }
//   }
//
//   Future<void> _fetchUserData(String userId) async {
//     final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/getUser.php?id=$userId'));
//     if (response.statusCode == 200) {
//       final parsed = jsonDecode(response.body);
//       print('Response for user $userId: $parsed');
//
//       if (parsed['data'] != null && parsed['data'].isNotEmpty) {
//         final userDataMap = parsed['data'][0];
//         final userData = ModelUsers.fromJson(userDataMap);
//
//         setState(() {
//           _aliranList.forEach((aliran) {
//             if (aliran.user_id == userId) {
//               aliran.fullname = userData.fullname;
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
//   void _filterAliranByRole() {
//     if (role == 'Customer') {
//       setState(() {
//         _filteredAliranList = _aliranList.where((aliran) => aliran.user_id == userId).toList();
//       });
//     } else {
//       setState(() {
//         _filteredAliranList = _aliranList;
//       });
//     }
//   }
//
//   void _filterAliranList(String query) async {
//     try {
//       final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/pengawasan.php'));
//       if (response.statusCode == 200) {
//         final parsed = jsonDecode(response.body);
//         List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
//         List<Datum> filteredData;
//         if (query.isNotEmpty) {
//           filteredData = allData.where((aliran) =>
//           aliran.user_id.toLowerCase().contains(query.toLowerCase()) ||
//               aliran.status.toLowerCase().contains(query.toLowerCase())).toList();
//         } else {
//           filteredData = allData;
//         }
//         setState(() {
//           if (role == 'Customer') {
//             _filteredAliranList = filteredData.where((aliran) => aliran.user_id == userId).toList();
//           } else {
//             _filteredAliranList = filteredData;
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
//   Future<void> _saveStatus(Datum aliran, String status) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.1.7/kejaksaan/updateStatusPengawasan.php'),
//         body: {
//           'id': aliran.id,
//           'status': status,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         print('Status berhasil disimpan: $status');
//         setState(() {
//           aliran.status = status;
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "List Pengawasan Aliran dan Kepercayaan",
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
//                   onChanged: _filterAliranList,
//                   decoration: InputDecoration(
//                     labelText: 'Search Pengawasan Aliran',
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
//                 itemCount: _filteredAliranList.length,
//                 itemBuilder: (context, index) {
//                   final aliran = _filteredAliranList[index];
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
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         aliran.laporan_pengaduan ?? '',
//                                         style: TextStyle(
//                                           fontFamily: 'Jost',
//                                           fontSize: 20,
//                                           color: Colors.orange,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(height: 8),
//                                       Text(
//                                         'Nama Pelapor: ' + (aliran.nama_pelapor ?? 'Loading...'),
//                                         style: TextStyle(
//                                           fontFamily: 'Jost',
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       SizedBox(height: 8),
//                                       Text(
//                                         'Tanggal Pelaporan: ' + (aliran.created_at ?? 'Loading...'),
//                                         style: TextStyle(
//                                           fontFamily: 'Jost',
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       SizedBox(height: 20),
//                                       Text(
//                                         'Created by: ${aliran.fullname ?? 'Loading...'}',
//                                         style: TextStyle(
//                                           fontFamily: 'Jost',
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       SizedBox(height: 8),
//                                       ElevatedButton(
//                                         onPressed: () => _handleStatusButtonPress(aliran),
//                                         child: Text(
//                                           aliran.status,
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
//               builder: (context) => AddAliranPage(),
//             ),
//           );
//         },
//         backgroundColor: Colors.green,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:project_kejaksaan/aliran/add_aliran_page.dart';
// import 'package:project_kejaksaan/aliran/edit_aliran_page.dart';
// import 'package:project_kejaksaan/home_page.dart';
// import 'package:project_kejaksaan/login/login_page.dart';
// import 'package:project_kejaksaan/models/model_aliran.dart';
// import 'package:project_kejaksaan/models/model_user.dart';
// import 'package:project_kejaksaan/utils/session_manager.dart';
// import 'package:http/http.dart' as http;
//
// class ListAliranPage extends StatefulWidget {
//   const ListAliranPage({super.key});
//
//   @override
//   State<ListAliranPage> createState() => _ListAliranPageState();
// }
//
// class _ListAliranPageState extends State<ListAliranPage> {
//   late List<Datum> _aliranList = [];
//   late List<Datum> _filteredAliranList;
//   late bool _isLoading;
//   TextEditingController _searchController = TextEditingController();
//   String? username;
//   String? role;
//   String? userId; // Simpan user_id dari sesi
//
//   @override
//   void initState() {
//     super.initState();
//     _isLoading = true;
//     getDataSession();
//     _fetchAliran();
//     _filteredAliranList = [];
//   }
//
//   Future<void> getDataSession() async {
//     bool hasSession = await sessionManager.getSession();
//     if (hasSession) {
//       setState(() {
//         username = sessionManager.username;
//         role = sessionManager.role;
//         userId = sessionManager.id; // Simpan user_id dari sesi
//         print('Data session: $username');
//       });
//     } else {
//       print('Session tidak ditemukan!');
//     }
//   }
//
//   Future<void> _fetchAliran() async {
//     final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/pengawasan.php'));
//     if (response.statusCode == 200) {
//       final parsed = jsonDecode(response.body);
//       setState(() {
//         _aliranList = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
//         _filterAliranByRole();
//         _isLoading = false;
//       });
//
//       for (var aliran in _aliranList) {
//         await _fetchUserData(aliran.user_id);
//       }
//     } else {
//       throw Exception('Failed to load pengaduan');
//     }
//   }
//
//   Future<void> _fetchUserData(String userId) async {
//     final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/getUser.php?id=$userId'));
//     if (response.statusCode == 200) {
//       final parsed = jsonDecode(response.body);
//       print('Response for user $userId: $parsed');
//
//       if (parsed['data'] != null && parsed['data'].isNotEmpty) {
//         final userDataMap = parsed['data'][0];
//         final userData = ModelUsers.fromJson(userDataMap);
//
//         setState(() {
//           _aliranList.forEach((aliran) {
//             if (aliran.user_id == userId) {
//               aliran.fullname = userData.fullname;
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
//   void _filterAliranByRole() {
//     if (role == 'Customer') {
//       setState(() {
//         _filteredAliranList = _aliranList.where((aliran) => aliran.user_id == userId).toList();
//       });
//     } else {
//       setState(() {
//         _filteredAliranList = _aliranList;
//       });
//     }
//   }
//
//   void _filterAliranList(String query) async {
//     try {
//       final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/pengawasan.php'));
//       if (response.statusCode == 200) {
//         final parsed = jsonDecode(response.body);
//         List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
//         List<Datum> filteredData;
//         if (query.isNotEmpty) {
//           filteredData = allData.where((aliran) =>
//           aliran.user_id.toLowerCase().contains(query.toLowerCase()) ||
//               aliran.status.toLowerCase().contains(query.toLowerCase())).toList();
//         } else {
//           filteredData = allData;
//         }
//         setState(() {
//           if (role == 'Customer') {
//             _filteredAliranList = filteredData.where((aliran) => aliran.user_id == userId).toList();
//           } else {
//             _filteredAliranList = filteredData;
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
//   Future<void> _saveStatus(Datum aliran, String status) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.1.7/kejaksaan/updateStatusPengawasan.php'),
//         body: {
//           'id': aliran.id,
//           'status': status,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         print('Status berhasil disimpan: $status');
//         setState(() {
//           aliran.status = status;
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
//   Future<void> _handleEdit(Datum aliran) async {
//     // Menunggu hasil dari EditAliranPage
//     final result = await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EditAliranPage(aliran: aliran), // Pastikan AddAliranPage menerima parameter aliran
//       ),
//     );
//
//     // Memeriksa apakah hasil pengeditan sukses
//     if (result == true) {
//       // Ambil ulang data dari server untuk merefresh tampilan
//       _fetchAliran();
//     }
//   }
//
//   Future<void> _handleDelete(Datum aliran) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.1.7/kejaksaan/deletepengawasan.php'), // Sesuaikan dengan URL endpoint untuk hapus data
//         body: {
//           'id': aliran.id,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         setState(() {
//           _filteredAliranList.remove(aliran);
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
//           "List Pengawasan Aliran dan Kepercayaan",
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
//                   onChanged: _filterAliranList,
//                   decoration: InputDecoration(
//                     labelText: 'Search Pengawasan Aliran',
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
//                 itemCount: _filteredAliranList.length,
//                 itemBuilder: (context, index) {
//                   final aliran = _filteredAliranList[index];
//                   return Padding(
//                     padding: EdgeInsets.only(bottom: 16.0),
//                     child: Stack(
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(top: 12),
//                           padding: EdgeInsets.all(16.0),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.rectangle,
//                             borderRadius: BorderRadius.all(Radius.circular(15)),
//                             color: Color(0xFFFFFFFF),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 aliran.laporan_pengaduan ?? '',
//                                 style: TextStyle(
//                                   fontFamily: 'Jost',
//                                   fontSize: 20,
//                                   color: Colors.orange,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Nama Pelapor: ' + (aliran.nama_pelapor ?? 'Loading...'),
//                                 style: TextStyle(
//                                   fontFamily: 'Jost',
//                                   fontSize: 14,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Text(
//                                 'Tanggal Pelaporan: ' + (aliran.created_at ?? 'Loading...'),
//                                 style: TextStyle(
//                                   fontFamily: 'Jost',
//                                   fontSize: 14,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               SizedBox(height: 20),
//                               Text(
//                                 'Created by: ${aliran.fullname ?? 'Loading...'}',
//                                 style: TextStyle(
//                                   fontFamily: 'Jost',
//                                   fontSize: 14,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   ElevatedButton(
//                                     onPressed: () => _handleStatusButtonPress(aliran),
//                                     child: Text(
//                                       aliran.status,
//                                       style: TextStyle(
//                                         fontFamily: 'Jost',
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   if (role == 'Customer' && aliran.status == 'Pending') ...[
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: Icon(Icons.edit),
//                                           onPressed: () => _handleEdit(aliran),
//                                           tooltip: 'Edit',
//                                         ),
//                                         IconButton(
//                                           icon: Icon(Icons.delete),
//                                           onPressed: () => _handleDelete(aliran),
//                                           tooltip: 'Delete',
//                                           color: Colors.red,
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
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
//               builder: (context) => AddAliranPage(),
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
import 'package:project_kejaksaan/aliran/add_aliran_page.dart';
import 'package:project_kejaksaan/aliran/edit_aliran_page.dart';
import 'package:project_kejaksaan/aliran/aliran_detail_page.dart';
import 'package:project_kejaksaan/home_page.dart';
import 'package:project_kejaksaan/login/login_page.dart';
import 'package:project_kejaksaan/models/model_aliran.dart';
import 'package:project_kejaksaan/models/model_user.dart';
import 'package:project_kejaksaan/utils/session_manager.dart';
import 'package:http/http.dart' as http;

class ListAliranPage extends StatefulWidget {
  const ListAliranPage({super.key});

  @override
  State<ListAliranPage> createState() => _ListAliranPageState();
}

class _ListAliranPageState extends State<ListAliranPage> {
  late List<Datum> _aliranList = [];
  late List<Datum> _filteredAliranList;
  late bool _isLoading;
  TextEditingController _searchController = TextEditingController();
  String? username;
  String? role;
  String? userId; // Simpan user_id dari sesi

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    getDataSession();
    _fetchAliran();
    _filteredAliranList = [];
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

  Future<void> _fetchAliran() async {
    final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/pengawasan.php'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      setState(() {
        _aliranList = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
        _filterAliranByRole();
        _isLoading = false;
      });

      for (var aliran in _aliranList) {
        await _fetchUserData(aliran.user_id);
      }
    } else {
      throw Exception('Failed to load pengaduan');
    }
  }

  Future<void> _fetchUserData(String userId) async {
    final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/getUser.php?id=$userId'));
    if (response.statusCode == 200) {
      final parsed = jsonDecode(response.body);
      print('Response for user $userId: $parsed');

      if (parsed['data'] != null && parsed['data'].isNotEmpty) {
        final userDataMap = parsed['data'][0];
        final userData = ModelUsers.fromJson(userDataMap);

        setState(() {
          _aliranList.forEach((aliran) {
            if (aliran.user_id == userId) {
              aliran.fullname = userData.fullname;
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

  void _filterAliranByRole() {
    if (role == 'Customer') {
      setState(() {
        _filteredAliranList = _aliranList.where((aliran) => aliran.user_id == userId).toList();
      });
    } else {
      setState(() {
        _filteredAliranList = _aliranList;
      });
    }
  }

  void _filterAliranList(String query) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.7/kejaksaan/pengawasan.php'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        List<Datum> allData = List<Datum>.from(parsed['data'].map((x) => Datum.fromJson(x)));
        List<Datum> filteredData;
        if (query.isNotEmpty) {
          filteredData = allData.where((aliran) =>
          aliran.user_id.toLowerCase().contains(query.toLowerCase()) ||
              aliran.status.toLowerCase().contains(query.toLowerCase())).toList();
        } else {
          filteredData = allData;
        }
        setState(() {
          if (role == 'Customer') {
            _filteredAliranList = filteredData.where((aliran) => aliran.user_id == userId).toList();
          } else {
            _filteredAliranList = filteredData;
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

  Future<void> _saveStatus(Datum aliran, String status) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.7/kejaksaan/updateStatusPengawasan.php'),
        body: {
          'id': aliran.id,
          'status': status,
        },
      );

      if (response.statusCode == 200) {
        print('Status berhasil disimpan: $status');
        setState(() {
          aliran.status = status;
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

  Future<void> _handleEdit(Datum aliran) async {
    // Menunggu hasil dari EditAliranPage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAliranPage(aliran: aliran), // Pastikan AddAliranPage menerima parameter aliran
      ),
    );

    // Memeriksa apakah hasil pengeditan sukses
    if (result == true) {
      // Ambil ulang data dari server untuk merefresh tampilan
      _fetchAliran();
    }
  }

  Future<void> _handleDelete(Datum aliran) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.7/kejaksaan/deletepengawasan.php'), // Sesuaikan dengan URL endpoint untuk hapus data
        body: {
          'id': aliran.id,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _filteredAliranList.remove(aliran);
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

  void _handleItemClick(Datum aliran) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AliranDetailPage(aliran: aliran),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Pengawasan Aliran dan Kepercayaan",
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
                  onChanged: _filterAliranList,
                  decoration: InputDecoration(
                    labelText: 'Search Pengawasan Aliran',
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
                itemCount: _filteredAliranList.length,
                itemBuilder: (context, index) {
                  final aliran = _filteredAliranList[index];
                  return GestureDetector(
                    onTap: () => _handleItemClick(aliran),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
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
                                  aliran.laporan_pengaduan ?? '',
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 20,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Nama Pelapor: ' + (aliran.nama_pelapor ?? 'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tanggal Pelaporan: ' + (aliran.created_at ?? 'Loading...'),
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Created by: ${aliran.fullname ?? 'Loading...'}',
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
                                      onPressed: () => _handleStatusButtonPress(aliran),
                                      child: Text(
                                        aliran.status,
                                        style: TextStyle(
                                          fontFamily: 'Jost',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (role == 'Customer' && aliran.status == 'Pending') ...[
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit),
                                            onPressed: () => _handleEdit(aliran),
                                            tooltip: 'Edit',
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: () => _handleDelete(aliran),
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
              builder: (context) => AddAliranPage(),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
