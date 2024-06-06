// import 'package:flutter/material.dart';
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
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;
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
//     getDataSession();
//     _isLoading = true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
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
//               'Hi, ${sessionManager.username ?? ''}',
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
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.asset(
//               'assets/images/splashscreen.png',
//               width: double.infinity,
//               height: MediaQuery.of(context).size.height * 0.25,
//               fit: BoxFit.cover,
//             ),
//             SizedBox(height: 20),
//             Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 20),
//                   GridView.count(
//                     physics: NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 16.0,
//                     crossAxisSpacing: 16.0,
//                     children: [
//                       buildCard(context, "Pengaduan Pegawai"),
//                       buildCard(context, "JMS (Jaksa Masuk Sekolah)"),
//                       buildCard(context, "Pengaduan Tindak Pidana Korupsi"),
//                       buildCard(context, "Penyuluhan Hukum"),
//                       buildCard(context, "Pengawasan Aliran & Kepercayaan"),
//                       buildCard(context, "Posko Pilkada"),
//                     ],
//                   ),
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
//   Widget buildCard(BuildContext context, String title) {
//     IconData iconData;
//     switch (title) {
//       case "Pengaduan Pegawai":
//         iconData = Icons.work;
//         break;
//       case "JMS (Jaksa Masuk Sekolah)":
//         iconData = Icons.school;
//         break;
//       case "Pengaduan Tindak Pidana Korupsi":
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
//         // Handle tap on each card
//         switch (title) {
//           case "Pengaduan Pegawai":
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ListPengaduanPage()),
//             );
//             break;
//           case "JMS (Jaksa Masuk Sekolah)":
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ListJmsPage()),
//             );
//             break;
//           case "Pengaduan Tindak Pidana Korupsi":
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ListPidanaPage()),
//             );
//             break;
//           case "Penyuluhan Hukum":
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ListPenyuluhanPage()),
//             );
//             break;
//           case "Pengawasan Aliran & Kepercayaan":
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ListAliranPage()),
//             );
//             break;
//           case "Posko Pilkada":
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ListPilkadaPage()),
//             );
//             break;
//           default:
//             break;
//         }
//       },
//       child: Container(
//         width: double.infinity,
//         margin: EdgeInsets.only(bottom: 20.0),
//         decoration: BoxDecoration(
//           color: Color(0xFF477942),
//           borderRadius: BorderRadius.circular(10.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.5),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(10.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(
//                 iconData,
//                 color: Colors.white,
//                 size: 40,
//               ),
//               SizedBox(height: 10), // Add space between icon and text
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14.0,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Jost',
//                   color: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
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
import 'package:url_launcher/url_launcher.dart'; // Ensure this import is correct

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

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
        _showRatingDialog();
        break;
    }
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) => RatingDialog(),
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

  @override
  void initState() {
    super.initState();
    getDataSession();
    _isLoading = true;
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
      backgroundColor: Color(0xFFE1F6C7),
      body: Column(
        children: [
          Container(
            height: screenHeight * 0.25,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildImageCard(context, 'assets/images/login.png', 'https://kejati-sumaterabarat.kejaksaan.go.id/'),
                buildImageCard(context, 'assets/images/login.png', 'https://kejati-sumaterabarat.kejaksaan.go.id/'),
                buildImageCard(context, 'assets/images/login.png', 'https://kejati-sumaterabarat.kejaksaan.go.id/'),
                buildImageCard(context, 'assets/images/login.png', 'https://kejati-sumaterabarat.kejaksaan.go.id/'),
                buildImageCard(context, 'assets/images/login.png', 'https://kejati-sumaterabarat.kejaksaan.go.id/'),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
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
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Color(0xFF275D20),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.blue,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Rating',
          ),
        ],
      ),
    );
  }

  Widget buildImageCard(BuildContext context, String imagePath, String url) {
    return GestureDetector(
      onTap: () {
        // Open web link
        _launchURL(url);
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
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
      onTap: () {
        // Handle tap on each card
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
