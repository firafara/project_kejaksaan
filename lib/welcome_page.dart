// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:project_kejaksaan/intro01_page.dart';

// class WelcomePage extends StatefulWidget {
//   const WelcomePage({Key? key}) : super(key: key);

//   @override
//   State<WelcomePage> createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage> {
//   void initState(){
//     super.initState();
//     splashscreenStart();
//   }

//   splashscreenStart() async{
//     var duration = const Duration(seconds: 8);
//     return Timer(duration, (){
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => Intro01()),
//       );
//     });
//   }

//   @override
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           color: Colors.white, // Adjusted to a neutral color to accommodate the colorful welcome image
//         ),
//         child: GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => Intro01()),

//             );
//           },
//           child: Center(
//             child: Stack(
//               alignment: Alignment.center, // This centers the content within the stack
//               children: [
//                 Positioned.fill(
//                   child: Image.asset(
//                     'assets/images/kejati.png', // Make sure this path matches your image asset
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// }
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kejaksaan/intro01_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    splashscreenStart();
  }

  splashscreenStart() async {
    var duration = const Duration(seconds: 8);
    return Timer(duration, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Intro01()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Intro01()),
            );
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 1.1, // Slightly zoom the image
                  child: Image.asset(
                    'assets/images/kejati-edit.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 10), // Reduced space between image and text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Text(
                        'Aplikasi Sikabar',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '(SIKABAR Apps)',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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
