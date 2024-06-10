// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:project_kejaksaan/home_page.dart';
// import 'package:project_kejaksaan/login/register_page.dart';
//
// import '../models/ModelLogin.dart';
// import '../utils/session_manager.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   TextEditingController txtUsername = TextEditingController();
//   TextEditingController txtPassword = TextEditingController();
//   GlobalKey<FormState> keyForm = GlobalKey<FormState>();
//
//   bool isLoading = false;
//   bool _isPasswordVisible = false;
//   Future<void> loginAccount() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });
//
//       http.Response res = await http.post(
//         Uri.parse('http://192.168.31.53/kejaksaan/login.php'),
//         body: {
//           "login": "1",
//           "username": txtUsername.text,
//           "password": txtPassword.text,
//         },
//       );
//
//       if (res.statusCode == 200) {
//         ModelLogin data = ModelLogin.fromJson(json.decode(res.body));
//         if (data.sukses) {
//           if (data.data != null &&
//               data.data.id != null &&
//               data.data.username != null &&
//               data.data.fullname != null &&
//               data.data.email != null &&
//               data.data.phone_number != null &&
//               data.data.ktp != null &&
//               data.data.alamat != null &&
//               data.data.role != null) {
//             sessionManager.saveSession(
//               data.status,
//               data.data.id,
//               data.data.username,
//               data.data.fullname,
//               data.data.email,
//               data.data.phone_number,
//               data.data.ktp,
//               data.data.alamat,
//               data.data.role,
//             );
//
//             print('Nilai sesi disimpan:');
//             print('ID: ${data.data.id}');
//             print('Username: ${data.data.username}');
//             print('Fullname: ${data.data.fullname}');
//             print('Email: ${data.data.email}');
//
//             ScaffoldMessenger.of(context)
//                 .showSnackBar(SnackBar(content: Text('${data.pesan}')));
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => HomePage()),
//             );
//           } else {
//             throw Exception('Data pengguna tidak lengkap atau null');
//           }
//         } else {
//           ScaffoldMessenger.of(context)
//               .showSnackBar(SnackBar(content: Text('${data.pesan}')));
//         }
//       } else {
//         throw Exception('Failed to load data');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFF5BB04B),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(height: 30),
//               Center(
//                 child: Column(
//                   children: [
//                     Image.asset(
//                       'assets/images/login.png',
//                       width: 200,
//                       height: 150,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 10),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Sign In",
//                     style: TextStyle(
//                       fontFamily: 'Jost',
//                       fontSize: 24,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Text(
//                     "Log in with your Account",
//                     style: TextStyle(
//                       fontFamily: 'Mulish',
//                       fontSize: 14,
//                       color: Colors.white,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Form(
//                 key: keyForm,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       validator: (val) {
//                         return val!.isEmpty ? "Username cannot be empty" : null;
//                       },
//                       controller: txtUsername,
//                       style: TextStyle(
//                         fontFamily: 'Mulish',
//                       ),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: "Username",
//                         prefixIcon:
//                             Icon(Icons.person, color: Color(0xFF545454)),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(vertical: 0),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     TextFormField(
//                       validator: (val) {
//                         return val!.isEmpty ? "Password cannot be empty" : null;
//                       },
//                       controller: txtPassword,
//                       style: TextStyle(
//                         fontFamily: 'Mulish',
//                       ),
//                       obscureText: !_isPasswordVisible,
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: "Password",
//                         prefixIcon:
//                             Icon(Icons.lock_outline, color: Color(0xFF545454)),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible
//                                 ? Icons.visibility
//                                 : Icons.visibility_off,
//                             color: Color(0xFF545454),
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isPasswordVisible = !_isPasswordVisible;
//                             });
//                           },
//                         ),
//                         contentPadding: EdgeInsets.symmetric(vertical: 0),
//                       ),
//                     ),
//                     SizedBox(height: 40),
//                     InkWell(
//                       onTap: () {
//                         if (keyForm.currentState?.validate() == true) {
//                           loginAccount();
//                         }
//                       },
//                       child: Container(
//                         height: 60,
//                         decoration: BoxDecoration(
//                           color: Color(0xFF275D20),
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: <Widget>[
//                             Align(
//                               alignment: Alignment.center,
//                               child: Text(
//                                 'Sign In',
//                                 textAlign: TextAlign.center,
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   fontFamily: 'Jost',
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               right: 16,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   color: Colors.white,
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(10),
//                                   child: Icon(
//                                     Icons.arrow_forward,
//                                     color: Color(0xFF275D20),
//                                     size: 24,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 30),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => RegisterPage()),
//                   );
//                 },
//                 child: Container(
//                   alignment: Alignment.center,
//                   child: RichText(
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                       style: TextStyle(
//                         color: Color(0xFF545454),
//                         fontFamily: 'Mulish',
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       children: [
//                         TextSpan(
//                             text: "Don't have an account? ",
//                             style: TextStyle(
//                               color: Colors.white,
//                             )),
//                         TextSpan(
//                           text: "SIGN UP",
//                           style: TextStyle(
//                             color: Color(0xFF0961F5),
//                             decoration: TextDecoration.underline,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_kejaksaan/home_page.dart';
import 'package:project_kejaksaan/login/register_page.dart';

import '../models/ModelLogin.dart';
import '../utils/session_manager.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(
        Uri.parse('http://192.168.31.53/kejaksaan/login.php'),
        body: {
          "login": "1",
          "username": txtUsername.text,
          "password": txtPassword.text,
        },
      );

      if (res.statusCode == 200) {
        ModelLogin data = ModelLogin.fromJson(json.decode(res.body));
        if (data.sukses) {
          if (data.data != null &&
              data.data.id != null &&
              data.data.username != null &&
              data.data.fullname != null &&
              data.data.email != null &&
              data.data.phone_number != null &&
              data.data.ktp != null &&
              data.data.alamat != null &&
              data.data.role != null) {
            await sessionManager.saveSession(
              data.status,
              data.data.id,
              data.data.username,
              data.data.fullname,
              data.data.email,
              data.data.phone_number,
              data.data.ktp,
              data.data.alamat,
              data.data.role,
            );

            print('Session saved:');
            print('ID: ${data.data.id}');
            print('Username: ${data.data.username}');
            print('Fullname: ${data.data.fullname}');
            print('Email: ${data.data.email}');

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${data.pesan}')));

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            throw Exception('Data pengguna tidak lengkap atau null');
          }
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.pesan}')));
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5BB04B),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/login.png',
                      width: 200,
                      height: 150,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Log in with your Account",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              SizedBox(height: 20),
              Form(
                key: keyForm,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Username cannot be empty" : null;
                      },
                      controller: txtUsername,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Username",
                        prefixIcon:
                        Icon(Icons.person, color: Color(0xFF545454)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Password cannot be empty" : null;
                      },
                      controller: txtPassword,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                      ),
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Password",
                        prefixIcon:
                        Icon(Icons.lock_outline, color: Color(0xFF545454)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFF545454),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        if (keyForm.currentState?.validate() == true) {
                          loginAccount();
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
                                'Sign In',
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
                  ],
                ),
              ),
              SizedBox(height: 30),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Color(0xFF545454),
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        TextSpan(
                          text: "SIGN UP",
                          style: TextStyle(
                            color: Color(0xFF0961F5),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
