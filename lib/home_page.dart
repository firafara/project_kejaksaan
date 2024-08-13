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
import 'package:project_kejaksaan/rating_page.dart'; 
import 'package:project_kejaksaan/Data_User/list_user.dart';
import 'package:project_kejaksaan/Api/Api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Sikabar',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => ListUserPage(currentUser: currentUser)));
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => LogApplication()));
          }
          break;
      }
    }
  }

  void _showListUser() {
    showDialog(context: context, builder: (context) => ListUserDataPage());
  }

  void _showRatingDialog() async {
    await sendLog("BUTTON_CLICK", "Rating", "User opened rating dialog");
    showDialog(context: context, builder: (context) => RatingDialog());
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

  @override
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
          "Aplikasi Sikabar",
          style: TextStyle(fontFamily: 'Jost', fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF5BB04B),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Hi, ${sessionManager.username ?? ''}',
              style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Jost'),
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
                  buildImageCardLink(context, 'assets/images/gambar3.jpeg', 'https://docs.google.com/forms/d/e/1FAIpQLSdplUq-eYLAF73CMDNvVJhdlO10q4Z4CL-kLuavs1muYxpe0Q/viewform'),
                  buildImageCardLink(context, 'assets/images/gambar2.jpeg', 'https://docs.google.com/forms/d/e/1FAIpQLSdplUq-eYLAF73CMDNvVJhdlO10q4Z4CL-kLuavs1muYxpe0Q/viewform'),
                  buildImageCardLink(context, 'assets/images/gambar4.jpeg', 'https://www.lapor.go.id/'),
                ],
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
                  buildCard(context, "Penyuluhan & Penerangan Hukum"),
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
        items: buildBottomNavigationBarItems(),
      ),
    );
  }

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

  void _launchURL(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  Widget buildCard(BuildContext context, String title) {
    String imagePath;

    switch (title) {
      case "Pengaduan Pegawai":
        imagePath = 'assets/images/rukum2.png';
        break;
      case "JMS (Jaksa Masuk Sekolah)":
        imagePath = 'assets/images/jms.png';
        break;
      case "Pengaduan Tindak Pidana":
        imagePath = 'assets/images/pidana.png';
        break;
      case "Penyuluhan & Penerangan Hukum":
        imagePath = 'assets/images/penkum.png';
        break;
      case "Pengawasan Aliran & Kepercayaan":
        imagePath = 'assets/images/pak.png';
        break;
      case "Posko Pilkada":
        imagePath = 'assets/images/pp.png';
        break;
      default:
        imagePath = 'assets/images/default.jpeg';
    }

    return GestureDetector(
      onTap: () async {
        await sendLog("CARD_CLICK", "card", title);
          navigateToPage(context, title);
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 65,
              width: 80,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void navigateToPage(BuildContext context, String title) {
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
      case "Penyuluhan & Penerangan Hukum":
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
    try {
      final response = await http.post(
        Uri.parse(Api.LogApp),
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
    } catch (e) {
      print('Error sending log: $e');
    }
  }
}
