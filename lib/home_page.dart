// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:project_kejaksaan/login/login_page.dart';
// import 'package:project_kejaksaan/models/model_user.dart';
// import 'package:project_kejaksaan/jms/list_jms_page.dart';
// import 'package:project_kejaksaan/pidana/list_pidana_page.dart';
// import 'package:project_kejaksaan/penyuluhan/list_penyuluhan_page.dart';
// import 'package:project_kejaksaan/aliran/list_aliran_page.dart';
// import 'package:project_kejaksaan/pengaduan/list_pengaduan_page.dart';
// import 'package:project_kejaksaan/pilkada/list_pilkada_page.dart';
// import 'package:project_kejaksaan/user/list_user_page.dart';
// import 'package:project_kejaksaan/utils/session_manager.dart';
// import 'package:project_kejaksaan/rating_page.dart'; // Import RatingDialog
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
//
//   Future<void> launchWhatsapp({required String number, required String message}) async {
//     final Uri uri = Uri(
//       scheme: 'https',
//       host: 'wa.me',
//       path: number,
//       queryParameters: {
//         'text': message,
//       },
//     );
//
//     try {
//       if (await canLaunch(uri.toString())) {
//         await launch(uri.toString());
//       } else {
//         print("Can't launch WhatsApp");
//       }
//     } catch (e) {
//       print("Error launching WhatsApp: $e");
//     }
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
//     switch (index) {
//       case 0:
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//         break;
//       case 1:
//         ModelUsers currentUser = ModelUsers(
//           id: int.parse(sessionManager.id!),
//           username: sessionManager.username!,
//           email: sessionManager.email!,
//           fullname: sessionManager.fullname!,
//           phone_number: sessionManager.phone_number!,
//           ktp: sessionManager.ktp!,
//           alamat: sessionManager.alamat!,
//           role: sessionManager.role!,
//         );
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ListUserPage(currentUser: currentUser)),
//         );
//         break;
//       case 2:
//         _showRatingDialog();
//         break;
//     }
//   }
//
//   void _showRatingDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => RatingDialog(),
//     );
//   }
//
//   String? username;
//
//   Future<void> getDataSession() async {
//     bool hasSession = await sessionManager.getSession();
//     if (hasSession) {
//       setState(() {
//         username = sessionManager.username;
//         print('Data session: $username');
//       });
//     } else {
//       print('Session tidak ditemukan!');
//     }
//   }
//
//   late bool _isLoading;
//   TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _isLoading = true;
//     getDataSession();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Pusat Informasi",
//           style: TextStyle(
//             fontFamily: 'Jost',
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Color(0xFF5BB04B),
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: Text(
//               'Hi, ${username ?? ''}', // Menggunakan username yang diambil dari session
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
//       backgroundColor: Color(0xFFE1F6C7),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 16.0,
//                 crossAxisSpacing: 16.0,
//                 childAspectRatio: 1.2,
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 children: [
//                   buildImageCardLink(context, 'assets/images/gambar5.jpeg', 'https://halojpn.id/sites/'),
//                   buildImageCard(context, 'assets/images/gambar1.jpeg', '6281371534130', 'Hello!'),
//                   buildImageCardLink(context, 'assets/images/gambar3.jpeg', 'https://docs.google.com/forms/d/e/1FAIpQLSdplUq-eYLAF73CMDNvVJhdlO10q4Z4CL-kLuavs1muYxpe0Q/viewform'),
//                   buildImageCardLink(context, 'assets/images/gambar2.jpeg', 'https://docs.google.com/forms/d/e/1FAIpQLSdplUq-eYLAF73CMDNvVJhdlO10q4Z4CL-kLuavs1muYxpe0Q/viewform'),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
//               child: Center(
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.7,
//                   child: buildImageCardLink(context, 'assets/images/gambar4.jpeg', 'https://www.lapor.go.id/'),
//                 )
//               ),
//             ),
//             SizedBox(height: 5),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
//               child: GridView.count(
//                 crossAxisCount: 2,
//                 mainAxisSpacing: 5.0,
//                 crossAxisSpacing: 16.0,
//                 childAspectRatio: 1.2,
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 children: [
//                   buildCard(context, "Pengaduan Pegawai"),
//                   buildCard(context, "JMS (Jaksa Masuk Sekolah)"),
//                   buildCard(context, "Pengaduan Tindak Pidana"),
//                   buildCard(context, "Penyuluhan Hukum"),
//                   buildCard(context, "Pengawasan Aliran & Kepercayaan"),
//                   buildCard(context, "Posko Pilkada"),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         backgroundColor: Color(0xFF275D20),
//         selectedItemColor: Colors.white,
//         unselectedItemColor: Colors.blue,
//         showUnselectedLabels: true,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_balance),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.star),
//             label: 'Rating',
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildImageCardLink(BuildContext context, String imagePath, url) {
//     return GestureDetector(
//       onTap: () {
//         launch(url);
//       },
//       child: Image.asset(
//         imagePath,
//         fit: BoxFit.fill,
//         height: 120,
//         alignment: Alignment.center,
//       ),
//     );
//   }
//
//   Widget buildImageCard(BuildContext context, String imagePath, String number, String message) {
//     return GestureDetector(
//       onTap: () {
//         launchWhatsapp(number: number, message: message);
//       },
//       child: Image.asset(
//         imagePath,
//         fit: BoxFit.fill,
//         height: 120,
//         alignment: Alignment.center,
//       ),
//     );
//   }
//
//   void _launchURL(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
//
//   Widget buildCard(BuildContext context, String title) {
//     IconData iconData;
//     switch (title) {
//       case "Pengaduan Pegawai":
//         iconData = Icons.work;
//         break;
//       case "JMS (Jaksa Masuk Sekolah)":
//         iconData = Icons.school;
//         break;
//       case "Pengaduan Tindak Pidana":
//         iconData = Icons.gavel;
//         break;
//       case "Penyuluhan Hukum":
//         iconData = Icons.lightbulb;
//         break;
//       case "Pengawasan Aliran & Kepercayaan":
//         iconData = Icons.waves;
//         break;
//       case "Posko Pilkada":
//         iconData = Icons.account_balance;
//         break;
//       default:
//         iconData = Icons.error;
//     }
//
//     return GestureDetector(
//       onTap: () {
//         switch (title) {
//           case "Pengaduan Pegawai":
//             Navigator.push(context, MaterialPageRoute(builder: (context) => ListPengaduanPage()));
//             break;
//           case "JMS (Jaksa Masuk Sekolah)":
//             Navigator.push(context, MaterialPageRoute(builder: (context) => ListJmsPage()));
//             break;
//           case "Pengaduan Tindak Pidana":
//             Navigator.push(context, MaterialPageRoute(builder: (context) => ListPidanaPage()));
//             break;
//           case "Penyuluhan Hukum":
//             Navigator.push(context, MaterialPageRoute(builder: (context) => ListPenyuluhanPage()));
//             break;
//           case "Pengawasan Aliran & Kepercayaan":
//             Navigator.push(context, MaterialPageRoute(builder: (context) => ListAliranPage()));
//             break;
//           case "Posko Pilkada":
//             Navigator.push(context, MaterialPageRoute(builder: (context) => ListPilkadaPage()));
//             break;
//         }
//       },
//       child: Card(
//         elevation: 2.0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(iconData, size: 48.0),
//             SizedBox(height: 8.0),
//             Text(
//               title,
//               style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_kejaksaan/log_application.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:project_kejaksaan/login/login_page.dart';
import 'package:project_kejaksaan/models/model_user.dart';
import 'package:project_kejaksaan/jms/list_jms_page.dart';
import 'package:project_kejaksaan/pidana/list_pidana_page.dart';
import 'package:project_kejaksaan/penyuluhan/list_penyuluhan_page.dart';
import 'package:project_kejaksaan/aliran/list_aliran_page.dart';
import 'package:project_kejaksaan/pengaduan/list_pengaduan_page.dart';
import 'package:project_kejaksaan/pilkada/list_pilkada_page.dart';
import 'package:project_kejaksaan/user/list_user_page.dart';
import 'package:project_kejaksaan/utils/session_manager.dart';
import 'package:project_kejaksaan/rating_page.dart'; // Import RatingDialog
import 'package:project_kejaksaan/Data_User/list_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // late String role;

  Future<void> launchWhatsapp({required String number, required String message}) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: number,
      queryParameters: {
        'text': message,
      },
    );

    try {
      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        print("Can't launch WhatsApp");
      }
    } catch (e) {
      print("Error launching WhatsApp: $e");
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        ModelUsers currentUser = ModelUsers(
          id: int.parse(sessionManager.id!),
          username: sessionManager.username!,
          email: sessionManager.email!,
          fullname: sessionManager.fullname!,
          phone_number: sessionManager.phone_number!,
          ktp: sessionManager.ktp!,
          alamat: sessionManager.alamat!,
          role: sessionManager.role!,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListUserPage(currentUser: currentUser)),
        );
        break;
      case 2:
        if (sessionManager.role == 'Admin') {
         _showListUser();
        } else {
          _showRatingDialog();
        }

        break;
      case 3:
        if (sessionManager.role == 'Admin') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LogApplication()),
          );
        }
        break;
    }
  }

  void _showListUser() {
    showDialog(
      context: context,
      builder: (context) => ListUserDataPage(),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => ListUserDataPage(),
    );
  }

  String? username;

  Future<void> getDataSession() async {
    bool hasSession = await sessionManager.getSession();
    if (hasSession) {
      setState(() {
        username = sessionManager.username;
        print('Data session: $username');
      });
    } else {
      print('Session tidak ditemukan!');
    }
  }

  late bool _isLoading;
  TextEditingController _searchController = TextEditingController();

  void initState() {
    super.initState();
    _isLoading = true;
    getDataSession();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pusat Informasi",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF5BB04B),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Hi, ${sessionManager.username ?? ''}',
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
      backgroundColor: Color(0xFFA3C073),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  buildImageCardLink(context, 'assets/images/gambar5.jpeg', 'https://halojpn.id/sites/'),
                  buildImageCard(context, 'assets/images/gambar1.jpeg', '6281371534130', 'Hello!'),
                  buildImageCardLink(context, 'assets/images/gambar3.jpeg', 'https://docs.google.com/forms/d/e/1FAIpQLSdplUq-eYLAF73CMDNvVJhdlO10q4Z4CL-kLuavs1muYxpe0Q/viewform'),
                  buildImageCardLink(context, 'assets/images/gambar2.jpeg', 'https://docs.google.com/forms/d/e/1FAIpQLSdplUq-eYLAF73CMDNvVJhdlO10q4Z4CL-kLuavs1muYxpe0Q/viewform'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: buildImageCardLink(context, 'assets/images/gambar4.jpeg', 'https://www.lapor.go.id/'),
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  buildCard(context, "Pengaduan Pegawai"),
                  buildCard(context, "JMS (Jaksa Masuk Sekolah)"),
                  buildCard(context, "Pengaduan Tindak Pidana"),
                  buildCard(context, "Penyuluhan Hukum"),
                  buildCard(context, "Pengawasan Aliran & Kepercayaan"),
                  buildCard(context, "Posko Pilkada"),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFF275D20),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blue,
        showUnselectedLabels: true,
        items: buildBottomNavigationBarItems(), // Use a function to build items dynamically
      ),
    );
  }

  // Function to build bottom navigation items dynamically
  List<BottomNavigationBarItem> buildBottomNavigationBarItems() {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),

    ];
    if (sessionManager.role == 'User') {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.star),
          label: 'Rating',
        ),
      );
    }

    if (sessionManager.role == 'Admin') {
      items.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Data User',
        ),
      );
      items.add(
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
      );
    }


    // You can add more items here based on your requirements

    return items;
  }
  Widget buildImageCardLink(BuildContext context, String imagePath, url) {
    return GestureDetector(
      onTap: () async {
        await sendLog("IMAGE_CLICK", "image", url);
        launch(url);
      },
      child: Image.asset(
        imagePath,
        fit: BoxFit.fill,
        height: 120,
        alignment: Alignment.center,
      ),
    );
  }

  Widget buildImageCard(BuildContext context, String imagePath, String number, String message) {
    return GestureDetector(
      onTap: () async {
        await sendLog("IMAGE_CLICK", "whatsapp", number);
        launchWhatsapp(number: number, message: message);
      },
      child: Image.asset(
        imagePath,
        fit: BoxFit.fill,
        height: 120,
        alignment: Alignment.center,
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget buildCard(BuildContext context, String title) {
    IconData iconData;
    switch (title) {
      case "Pengaduan Pegawai":
        iconData = Icons.work;
        break;
      case "JMS (Jaksa Masuk Sekolah)":
        iconData = Icons.school;
        break;
      case "Pengaduan Tindak Pidana":
        iconData = Icons.gavel;
        break;
      case "Penyuluhan Hukum":
        iconData = Icons.lightbulb;
        break;
      case "Pengawasan Aliran & Kepercayaan":
        iconData = Icons.waves;
        break;
      case "Posko Pilkada":
        iconData = Icons.account_balance;
        break;
      default:
        iconData = Icons.error;
    }

    return GestureDetector(
      onTap: () async {
        await sendLog("CARD_CLICK", "card", title);
        switch (title) {
          case "Pengaduan Pegawai":
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListPengaduanPage()));
            break;
          case "JMS (Jaksa Masuk Sekolah)":
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListJmsPage()));
            break;
          case "Pengaduan Tindak Pidana":
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListPidanaPage()));
            break;
          case "Penyuluhan Hukum":
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListPenyuluhanPage()));
            break;
          case "Pengawasan Aliran & Kepercayaan":
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListAliranPage()));
            break;
          case "Posko Pilkada":
            Navigator.push(context, MaterialPageRoute(builder: (context) => ListPilkadaPage()));
            break;
        }
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 48.0),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }


}

  void navigateToPage(BuildContext context, String title) {
    switch (title) {
      case "JMS (Jaksa Masuk Sekolah)":
        Navigator.push(context, MaterialPageRoute(builder: (context) => ListJmsPage()));
        break;
      case "Pengaduan Tindak Pidana":
        Navigator.push(context, MaterialPageRoute(builder: (context) => ListPidanaPage()));
        break;
      case "Penyuluhan Hukum":
        Navigator.push(context, MaterialPageRoute(builder: (context) => ListPenyuluhanPage()));
        break;
      case "Pengawasan Aliran & Kepercayaan":
        Navigator.push(context, MaterialPageRoute(builder: (context) => ListAliranPage()));
        break;
      case "Posko Pilkada":
        Navigator.push(context, MaterialPageRoute(builder: (context) => ListPilkadaPage()));
        break;
      default:
        break;
    }
  }

  Future<void> sendLog(String method, String table, String description) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.11/kejaksaan/logapp.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': sessionManager.id ?? 'unknown',
        'method': method,
        'table': table,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      print('Log sent successfully');
      print('Response body: ${response.body}');
    } else {
      print('Failed to send log: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

