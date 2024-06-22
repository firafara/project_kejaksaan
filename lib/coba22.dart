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
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Future<void> launchWhatsapp({required String number, required String message}) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: number,
      queryParameters: {
        'text': message,
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Can't open Whatsapp");
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
    // Periksa dan set session setelah frame saat ini selesai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDataSession();
      _isLoading = true;
    });
  }

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
// import 'package:project_kejaksaan/rating_page.dart';
// import 'package:url_launcher/url_launcher.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   Future<void> launchWhatsapp({required String number, required String message}) async {
//     final Uri uri = Uri(
//       scheme: 'https',
//       host: 'wa.me',
//       path: number,
//       queryParameters: {
//         'text': message,
//       },
//     );

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       print("Can't open Whatsapp");
//     }
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

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

//   void _showRatingDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => RatingDialog(),
//     );
//   }

//   String? username;

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

//   late bool _isLoading;
//   TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     // Periksa dan set session setelah frame saat ini selesai
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       getDataSession();
//       _isLoading = true;
//     });
//   }

//   // Widget buildImageCard(BuildContext context, String imagePath, String number, String message) {
//   //   return GestureDetector(
//   //     onTap: () {
//   //       launchWhatsapp(number: number, message: message);
//   //     },
//   //     child: Card(
//   //       margin: EdgeInsets.all(10),
//   //       shape: RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.circular(10),
//   //       ),
//   //       elevation: 4,
//   //       child: Column(
//   //         mainAxisAlignment: MainAxisAlignment.center,
//   //         children: [
//   //           Expanded(
//   //             child: Image.asset(
//   //               imagePath,
//   //               fit: BoxFit.cover,
//   //               width: double.infinity,
//   //             ),
//   //           ),
//   //           SizedBox(height: 8),
//   //           Padding(
//   //             padding: const EdgeInsets.all(8.0),
//   //             child: Text(
//   //               'Click the image to send a message via WhatsApp',
//   //               textAlign: TextAlign.center,
//   //               style: TextStyle(
//   //                 fontSize: 12,
//   //                 fontFamily: 'Rubik',
//   //                 color: Color.fromRGBO(103, 114, 148, 1),
//   //               ),
//   //             ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//   //

//   Widget buildImageCard(BuildContext context, String imagePath, String number, String message) {
//     return GestureDetector(
//       onTap: () {
//         launchWhatsapp(number: number, message: message);
//       },
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Mengurangi jarak bottom
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(8.0), // Membuat border radius untuk gambar
//           child: Image.asset(
//             imagePath,
//             fit: BoxFit.contain, // Menggunakan BoxFit.contain agar gambar tidak terpotong
//           ),
//         ),
//       ),
//       // child: Card(
//       //   color: Color(0xFF5BB04B),
//       //   shape: RoundedRectangleBorder(
//       //     borderRadius: BorderRadius.circular(10),
//       //   ),
//       //   elevation: 4,
//       //   child: Column(
//       //     mainAxisAlignment: MainAxisAlignment.center,
//       //     children: [
//       //       Expanded(
//       //         child: Image.asset(
//       //           imagePath,
//       //           height: 80,
//       //           width:80,
//       //           fit: BoxFit.cover,
//       //           // width: double.inf/inity,
//       //         ),
//       //       ),
//       //       SizedBox(height: 8),
//       //       Padding(
//       //         padding: const EdgeInsets.all(8.0),
//       //         child: Text(
//       //           'Click the image to send a message via WhatsApp',
//       //           textAlign: TextAlign.center,
//       //           style: TextStyle(
//       //             fontSize: 12,
//       //             fontFamily: 'Rubik',
//       //             color: Colors.white,
//       //           ),
//       //         ),
//       //       ),
//       //     ],
//       //   ),
//       // ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;

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
//       body: Column(
//         children: [
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.all(12.0),
//               child: GridView.count(
//                 crossAxisCount: 2, // Set number of columns
//                 mainAxisSpacing: 16.0,
//                 crossAxisSpacing: 16.0,
//                 children: [
//                   buildImageCard(context, 'assets/images/gambar1.jpeg', '6282382853191', 'Hello from image 1!'),
//                   buildImageCard(context, 'assets/images/gambar2.jpeg', '6282382853191', 'Hello from image 2!'),
//                   buildImageCard(context, 'assets/images/gambar3.jpeg', '6282382853191', 'Hello from image 3!'),
//                   buildImageCard(context, 'assets/images/gambar4.jpeg', '6282382853191', 'Hello from image 4!'),
//                 ],
//               ),
//             ),
//           ),
//           // Expanded(
//           //   flex: 2,
//           //   child: Padding(
//           //     padding: EdgeInsets.all(12.0),
//           //     child: GridView.count(
//           //       crossAxisCount: 2,
//           //       mainAxisSpacing: 16.0,
//           //       crossAxisSpacing: 16.0,
//           //       children: [
//           //         buildImageCard(context, 'assets/images/gambar1.jpeg', '6282382853191', 'Hello from image 1!'),
//           //         buildImageCard(context, 'assets/images/gambar2.jpeg', '6282382853191', 'Hello from image 2!'),
//           //         buildImageCard(context, 'assets/images/gambar3.jpeg', '6282382853191', 'Hello from image 3!'),
//           //         buildImageCard(context, 'assets/images/gambar4.jpeg', '6282382853191', 'Hello from image 4!'),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//           Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 12.0),
//               child: buildImageCard(context, 'assets/images/gambar5.jpeg', '6282382853191', 'Hello from image 5!'),
//             ),
//           ),
//           // Container(
//           //   height: screenHeight * 0.25,
//           //   child: Stack(
//           //     children: [
//           //       Positioned.fill(
//           //         child: Stack(
//           //           children: [
//           //             buildImageCard(context, 'assets/images/gambar1.jpeg', '6282382853191', 'Hello from image 1!'),
//           //             buildImageCard(context, 'assets/images/gambar2.jpeg', '6282382853191', 'Hello from image 2!'),
//           //             buildImageCard(context, 'assets/images/gambar3.jpeg', '6282382853191', 'Hello from image 3!'),
//           //             buildImageCard(context, 'assets/images/gambar4.jpeg', '6282382853191', 'Hello from image 4!'),
//           //             buildImageCard(context, 'assets/images/gambar5.jpeg', '6282382853191', 'Hello from image 5!'),
//           //           ],
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           SizedBox(height: 20),
//           // Expanded(
//           //   child: Padding(
//           //     padding: EdgeInsets.all(16.0),
//           //     child: GridView.count(
//           //       crossAxisCount: 2,
//           //       mainAxisSpacing: 16.0,
//           //       crossAxisSpacing: 16.0,
//           //       children: [
//           //         buildCard(context, "Pengaduan Pegawai"),
//           //         buildCard(context, "JMS (Jaksa Masuk Sekolah)"),
//           //         buildCard(context, "Pengaduan Tindak Pidana"),
//           //         buildCard(context, "Penyuluhan Hukum"),
//           //         buildCard(context, "Pengawasan Aliran & Kepercayaan"),
//           //         buildCard(context, "Posko Pilkada"),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Users',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.star),
//             label: 'Rating',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildCard(BuildContext context, String title) {
//     IconData iconData;
//     switch (title) {
//       case "Pengaduan Pegawai":
//         iconData = Icons.report;
//         break;
//       case "JMS (Jaksa Masuk Sekolah)":
//         iconData = Icons.school;
//         break;
//       case "Pengaduan Tindak Pidana":
//         iconData = Icons.gavel;
//         break;
//       case "Penyuluhan Hukum":
//         iconData = Icons.book;
//         break;
//       case "Pengawasan Aliran & Kepercayaan":
//         iconData = Icons.security;
//         break;
//       case "Posko Pilkada":
//         iconData = Icons.how_to_vote;
//         break;
//       default:
//         iconData = Icons.help;
//         break;
//     }

//     return GestureDetector(
//       onTap: () {
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
//           case "Pengaduan Tindak Pidana":
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
//       child: Card(
//         color: Color(0xFF5BB04B),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         elevation: 4,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Icon(iconData, size: 50, color: Colors.white),
//             SizedBox(height: 10),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//                 fontFamily: 'Jost',
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



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
          // Expanded(
          //   child: Padding(
          //     padding: EdgeInsets.all(12.0),
          //     child: PageView(
          //       children: [
          //         buildImageCard(context, 'assets/images/gambar1.jpeg', '6282382853191', 'Hello from image 1!'),
          //         buildImageCard(context, 'assets/images/gambar3.jpeg', '6282382853191', 'Hello from image 2!'),
          //         buildImageCard(context, 'assets/images/gambar4.jpeg', '6282382853191', 'Hello from image 3!'),
          //         buildImageCard(context, 'assets/images/gambar2.jpeg', '6282382853191', 'Hello from image 4!'),
          //         buildImageCard(context, 'assets/images/gambar5.jpeg', '6282382853191', 'Hello from image 5!'),
          //       ],
          //     ),
          //   ),
          // ),
          // Container(
          //   height: screenHeight * 0.25,
          //   child: Stack(
          //     children: [
          //       Positioned.fill(
          //         child: Stack(
          //           children: [
          //             buildImageCard(context, 'assets/images/gambar1.jpeg', '6282382853191', 'Hello from image 1!'),
          //             buildImageCard(context, 'assets/images/gambar2.jpeg', '6282382853191', 'Hello from image 2!'),
          //             buildImageCard(context, 'assets/images/gambar3.jpeg', '6282382853191', 'Hello from image 3!'),
          //             buildImageCard(context, 'assets/images/gambar4.jpeg', '6282382853191', 'Hello from image 4!'),
          //             buildImageCard(context, 'assets/images/gambar5.jpeg', '6282382853191', 'Hello from image 5!'),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Rating',
          ),
        ],
      ),
    );
  }

  Widget buildCard(BuildContext context, String title) {
    IconData iconData;
    switch (title) {
      case "Pengaduan Pegawai":
        iconData = Icons.report;
        break;
      case "JMS (Jaksa Masuk Sekolah)":
        iconData = Icons.school;
        break;
      case "Pengaduan Tindak Pidana":
        iconData = Icons.gavel;
        break;
      case "Penyuluhan Hukum":
        iconData = Icons.book;
        break;
      case "Pengawasan Aliran & Kepercayaan":
        iconData = Icons.security;
        break;
      case "Posko Pilkada":
        iconData = Icons.how_to_vote;
        break;
      default:
        iconData = Icons.help;
        break;
    }

    return GestureDetector(
      onTap: () {
        switch (title) {
          case "Pengaduan Pegawai":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPengaduanPage()),
            );
            break;
          case "JMS (Jaksa Masuk Sekolah)":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListJmsPage()),
            );
            break;
          case "Pengaduan Tindak Pidana":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPidanaPage()),
            );
            break;
          case "Penyuluhan Hukum":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPenyuluhanPage()),
            );
            break;
          case "Pengawasan Aliran & Kepercayaan":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListAliranPage()),
            );
            break;
          case "Posko Pilkada":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListPilkadaPage()),
            );
            break;
          default:
            break;
        }
      },
      child: Card(
        color: Color(0xFF5BB04B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData, size: 50, color: Colors.white),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Jost',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
