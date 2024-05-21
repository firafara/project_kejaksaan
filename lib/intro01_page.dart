import 'package:flutter/material.dart';
import 'package:project_kejaksaan/login/login_page.dart';

class Intro01 extends StatelessWidget {
  const Intro01({super.key});

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.circular(4);
    return Scaffold(
      backgroundColor: Color(0xFF5BB04B),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tegakkan Keadilan Bersama Aplikasi Kejaksaan Sumbar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    "Solusi Inovatif untuk Pelayanan Hukum\nyang Lebih Efektif dan Terpercaya!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Positioned(
          //   bottom: 20,
          //   right: 16,
          //   child: GestureDetector(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => LoginPage()),
          //       );
          //     },
          //
          //     child: Container(
          //       width: 60,
          //       height: 60,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(30),
          //         color: Color(0xFF915D2D),
          //       ),
          //       child: Icon(
          //         Icons.arrow_forward,
          //         color: Colors.white,
          //         size: 27.3,
          //       ),
          //     ),
          //   ),
          // ),
          Positioned(
            bottom: 20,
            left: 16,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  width: 20,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: borderRadius,
                    color: Color(0xFF275D20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 8),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF275D20),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 8),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Container(
                width: 200,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF275D20),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          "Get Started",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Jost'
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
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
          ),
        ],
      ),
    );
  }
}
