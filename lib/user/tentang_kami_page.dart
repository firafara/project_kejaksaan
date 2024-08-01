import 'package:flutter/material.dart';

class TentangKami extends StatefulWidget {
  const TentangKami({super.key});

  @override
  State<TentangKami> createState() => _TentangKamiState();
}

class _TentangKamiState extends State<TentangKami> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tentang Kami",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF5BB04B),
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
                      Text(
                        "SIKABAR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Jost',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20), // Add some space between the title and the description
                      Text(
                        "Layanan Sistem Informasi Kejaksaan Tinggi Sumatera Barat (SI-KABAR), yang memuat semua layanan yang ada di Kejaksaan Tinggi Sumbar yang bisa dimanfaatkan oleh masyarakat umum khususnya masyarakat Sumatera Barat.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Mulish'
                        ),
                      ),
                      SizedBox(height: 20), // Add some space between the description and the copyright
                      Text(
                        "© 2024 Kejaksaan Sumatera Barat",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
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
