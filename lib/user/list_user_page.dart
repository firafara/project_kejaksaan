import 'package:flutter/material.dart';
import 'package:project_kejaksaan/login/login_page.dart';
import 'package:project_kejaksaan/models/model_user.dart';
import 'package:project_kejaksaan/user/edit_user_page.dart';
import 'package:project_kejaksaan/user/tentang_kami_page.dart'; // Update with your model path

class ListUserPage extends StatefulWidget {
  final ModelUsers currentUser;

  ListUserPage({required this.currentUser});

  @override
  _ListUserPageState createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  late ModelUsers currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  void _updateUser(ModelUsers updatedUser) {
    setState(() {
      currentUser = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF5BB04B),
        actions: [
          // TextButton(
          //   onPressed: () {},
          //   child: Text(
          //     'Hi, ${username ?? ''}',
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 18,
          //         fontFamily: 'Jost'
          //     ),
          //   ),
          // ),
          // IconButton(
          //   icon: const Icon(Icons.exit_to_app),
          //   tooltip: 'Logout',
          //   color: Colors.black,
          //   onPressed: () {
          //     setState(() {
          //       sessionManager.clearSession();
          //       Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (context) => LoginPage()),
          //             (route) => false,
          //       );
          //     });
          //   },
          // ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF5BB04B),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Color(0xFF275D20),
                  radius: 50,
                  child: Text(
                    currentUser.username[0].toUpperCase(),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20), // Space between avatar and card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set card background color here
                    borderRadius: BorderRadius.circular(10), // Add border radius for card
                    boxShadow: [ // Add shadow for card
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: Color(0xFF275D20),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            currentUser.username,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Jost',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Color(0xFF275D20),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            currentUser.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Jost',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            color: Color(0xFF275D20),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            currentUser.fullname,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Jost',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: Color(0xFF275D20),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            currentUser.phone_number,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Jost',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            color: Color(0xFF275D20),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            currentUser.ktp,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Jost',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Color(0xFF275D20),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            currentUser.alamat,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontFamily: 'Jost',
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 20),
                      // InkWell(
                      //   onTap: () async {
                      //     final updatedUser = await Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => EditUserPage(currentUser: currentUser)),
                      //     );
                      //     if (updatedUser != null) {
                      //       _updateUser(updatedUser);
                      //     }
                      //   },
                      //   child: Container(
                      //     height: 60,
                      //     decoration: BoxDecoration(
                      //       color: Color(0xFF275D20),
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //     child: Stack(
                      //       alignment: Alignment.center,
                      //       children: <Widget>[
                      //         Align(
                      //           alignment: Alignment.center,
                      //           child: Text(
                      //             'Edit Profile',
                      //             textAlign: TextAlign.center,
                      //             style: TextStyle(
                      //               fontSize: 16,
                      //               fontWeight: FontWeight.bold,
                      //               color: Colors.white,
                      //               fontFamily: 'Jost',
                      //             ),
                      //           ),
                      //         ),
                      //         Positioned(
                      //           right: 16,
                      //           child: Container(
                      //             decoration: BoxDecoration(
                      //               shape: BoxShape.circle,
                      //               color: Colors.white,
                      //             ),
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(10),
                      //               child: Icon(
                      //                 Icons.arrow_forward,
                      //                 color: Color(0xFF275D20),
                      //                 size: 24,
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 20),
                      if (currentUser.role != 'Admin')
                        InkWell(
                          onTap: () async {
                            final updatedUser = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditUserPage(currentUser: currentUser)),
                            );
                            if (updatedUser != null) {
                              _updateUser(updatedUser);
                            }
                          },
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color(0xFF275D20),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Edit Profile',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Jost',
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 16,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Color(0xFF275D20),
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TentangKami()),
                          );
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xFF275D20),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Tentang Kami',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Jost',
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 16,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Color(0xFF275D20),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          // Logika untuk log out
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                                (route) => false,
                          );
                        },
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.red, // Warna merah
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row( // Row for icon and text
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.logout, // Icon logout
                                color: Colors.white,
                                size: 24,
                              ),
                              SizedBox(width: 10), // Spacing between icon and text
                              Text(
                                'Log Out',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Jost',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
