// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:project_kejaksaan/login/login_page.dart';
// // import 'package:project_kejaksaan/models/model_register.dart';
// //
// // class RegisterPage extends StatefulWidget {
// //   const RegisterPage({super.key});
// //
// //   @override
// //   State<RegisterPage> createState() => _RegisterPageState();
// // }
// //
// // class _RegisterPageState extends State<RegisterPage> {
// //   TextEditingController txtFullName = TextEditingController();
// //   TextEditingController txtUsername = TextEditingController();
// //   TextEditingController txtEmail = TextEditingController();
// //   TextEditingController txtPassword = TextEditingController();
// //   TextEditingController txtPhoneNumber = TextEditingController();
// //   TextEditingController txtKtp = TextEditingController();
// //   TextEditingController txtAlamat = TextEditingController();
// //   String _roleValue = '';
// //
// //   GlobalKey<FormState> keyForm = GlobalKey<FormState>();
// //
// //   bool isLoading = false;
// //   bool _isPasswordVisible = false;
// //   Future<ModelRegister?> registerAccount() async {
// //     try {
// //       setState(() {
// //         isLoading = true;
// //       });
// //       http.Response res = await http.post(
// //         Uri.parse('http://192.168.31.53/kejaksaan/register.php'),
// //         body: {
// //           "username": txtUsername.text,
// //           "password": txtPassword.text,
// //           "fullname": txtFullName.text,
// //           "email": txtEmail.text,
// //           "phone_number": txtPhoneNumber.text,
// //           "ktp": txtKtp.text,
// //           "alamat": txtAlamat.text,
// //           "role": _roleValue,
// //         },
// //       );
// //
// //       ModelRegister data = modelRegisterFromJson(res.body);
// //       //cek kondisi respon
// //       if (data.value == 1) {
// //         setState(() {
// //           isLoading = false;
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text('${data.message}')),
// //           );
// //           //kondisi berhasil dan pindah ke page login
// //           Navigator.pushAndRemoveUntil(
// //             context,
// //             MaterialPageRoute(builder: (context) => LoginPage()),
// //                 (route) => false,
// //           );
// //         });
// //         //kondisi email sudah ada
// //       } else if (data.value == 2) {
// //         setState(() {
// //           isLoading = false;
// //           ScaffoldMessenger.of(context).showSnackBar(
// //             SnackBar(content: Text('${data.message}')),
// //           );
// //         });
// //         //kondisi gagal daftar
// //       } else {
// //         isLoading = false;
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text('${data.message}')),
// //         );
// //       }
// //     } catch (e) {
// //       isLoading = false;
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text(e.toString())),
// //       );
// //     }
// //   }
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Color(0xFF5BB04B),
// //       body: SingleChildScrollView(
// //         child: Padding(
// //           padding: EdgeInsets.all(16.0),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             crossAxisAlignment: CrossAxisAlignment.center,
// //             children: [
// //               Center(
// //                 child: Column(
// //                   children: [
// //                     Image.asset(
// //                       'assets/images/login.png',
// //                       width: 200,
// //                       height: 100,
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 5),
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.center,
// //                 children: [
// //                   Text(
// //                     "Sign Up",
// //                     style: TextStyle(
// //                       fontFamily: 'Jost',
// //                       fontSize: 24,
// //                       fontWeight: FontWeight.w600,
// //                     ),
// //                   ),
// //                   Text(
// //                     "Create your Account ",
// //                     style: TextStyle(
// //                       fontFamily: 'Mulish',
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.w700,
// //                     ),
// //                   ),
// //                   SizedBox(height: 10),
// //                 ],
// //               ),
// //               SizedBox(height: 10),
// //               Form(
// //                 key: keyForm,
// //                 autovalidateMode: AutovalidateMode.onUserInteraction,
// //                 child: Column(
// //                   children: [
// //                     TextFormField(
// //                       validator: (val) {
// //                         return val!.isEmpty ? "Username cannot be empty" : null;
// //                       },
// //                       controller: txtUsername,
// //                       style: TextStyle(
// //                         fontFamily: 'Mulish',
// //                       ),
// //                       decoration: InputDecoration(
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         hintText: "Username",
// //                         prefixIcon: Icon(Icons.person, color: Color(0xFF545454)),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8.0),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                         contentPadding: EdgeInsets.symmetric(vertical: 0),
// //                       ),
// //                     ),
// //                     SizedBox(height: 10),
// //                     TextFormField(
// //                       validator: (val) {
// //                         return val!.isEmpty ? "Password cannot be empty" : null;
// //                       },
// //                       controller: txtPassword,
// //                       style: TextStyle(
// //                         fontFamily: 'Mulish',
// //                       ),
// //                       obscureText: !_isPasswordVisible,
// //                       decoration: InputDecoration(
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         hintText: "Password",
// //                         prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF545454)),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8.0),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                         suffixIcon: IconButton(
// //                           icon: Icon(
// //                             _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
// //                             color: Color(0xFF545454),
// //                           ),
// //                           onPressed: () {
// //                             setState(() {
// //                               _isPasswordVisible = !_isPasswordVisible;
// //                             });
// //                           },
// //                         ),
// //                         contentPadding: EdgeInsets.symmetric(vertical: 0),
// //                       ),
// //                     ),
// //                     SizedBox(height: 10),
// //                     TextFormField(
// //                       validator: (val) {
// //                         return val!.isEmpty ? "Email cannot be empty" : null;
// //                       },
// //                       controller: txtEmail,
// //                       style: TextStyle(
// //                         fontFamily: 'Mulish',
// //                       ),
// //                       decoration: InputDecoration(
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         hintText: "Email",
// //                         prefixIcon: Icon(Icons.mail_outline, color: Color(0xFF545454)),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8.0),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                         contentPadding: EdgeInsets.symmetric(vertical: 0),
// //                       ),
// //                     ),
// //                     SizedBox(height: 10),
// //                     TextFormField(
// //                       validator: (val) {
// //                         return val!.isEmpty ? "Fullname cannot be empty" : null;
// //                       },
// //                       controller: txtFullName,
// //                       style: TextStyle(
// //                         fontFamily: 'Mulish',
// //                       ),
// //                       decoration: InputDecoration(
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         hintText: "Full name",
// //                         prefixIcon: Icon(Icons.people_alt, color: Color(0xFF545454)),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8.0),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                         contentPadding: EdgeInsets.symmetric(vertical: 0),
// //                       ),
// //                     ),
// //                     SizedBox(height: 10),
// //                     TextFormField(
// //                       validator: (val) {
// //                         return val!.isEmpty ? "Phone Number cannot be empty" : null;
// //                       },
// //                       controller: txtPhoneNumber,
// //                       style: TextStyle(
// //                         fontFamily: 'Mulish',
// //                       ),
// //                       decoration: InputDecoration(
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         hintText: "Phone Number",
// //                         prefixIcon: Icon(Icons.phone, color: Color(0xFF545454)),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8.0),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                         contentPadding: EdgeInsets.symmetric(vertical: 0),
// //                       ),
// //                     ),
// //                     SizedBox(height: 10),
// //                     TextFormField(
// //                       validator: (val) {
// //                         return val!.isEmpty ? "KTP cannot be empty" : null;
// //                       },
// //                       controller: txtKtp,
// //                       style: TextStyle(
// //                         fontFamily: 'Mulish',
// //                       ),
// //                       decoration: InputDecoration(
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         hintText: "KTP",
// //                         prefixIcon: Icon(Icons.perm_identity, color: Color(0xFF545454)),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8.0),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                         contentPadding: EdgeInsets.symmetric(vertical: 0),
// //                       ),
// //                     ),
// //                     SizedBox(height: 10),
// //                     TextFormField(
// //                       validator: (val) {
// //                         return val!.isEmpty ? "Alamat cannot be empty" : null;
// //                       },
// //                       controller: txtAlamat,
// //                       style: TextStyle(
// //                         fontFamily: 'Mulish',
// //                       ),
// //                       decoration: InputDecoration(
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         hintText: "Alamat",
// //                         prefixIcon: Icon(Icons.location_city, color: Color(0xFF545454)),
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(8.0),
// //                           borderSide: BorderSide.none,
// //                         ),
// //                         contentPadding: EdgeInsets.symmetric(vertical: 0),
// //                       ),
// //                     ),
// //                     // SizedBox(height: 10),
// //                     // DropdownButtonFormField<String>(
// //                     //   decoration: InputDecoration(
// //                     //     labelText: 'Role',
// //                     //     filled: true,
// //                     //     fillColor: Colors.white,
// //                     //     prefixIcon: Icon(Icons.person_outline),
// //                     //     border: OutlineInputBorder(
// //                     //       borderRadius: BorderRadius.circular(8.0),
// //                     //       borderSide: BorderSide.none,
// //                     //     ),
// //                     //     contentPadding:
// //                     //     EdgeInsets.symmetric(vertical: 16, horizontal: 16),
// //                     //   ),
// //                     //   value: _roleValue.isNotEmpty ? _roleValue : null,
// //                     //   onChanged: (String? newValue) {
// //                     //     setState(() {
// //                     //       _roleValue = newValue!;
// //                     //     });
// //                     //   },
// //                     //   items: <String>['', 'Admin', 'Customer']
// //                     //       .map<DropdownMenuItem<String>>((String value) {
// //                     //     return DropdownMenuItem<String>(
// //                     //       value: value,
// //                     //       child: Text(value),
// //                     //     );
// //                     //   }).toList(),
// //                     // ),
// //                     SizedBox(height: 10),
// //
// //                     InkWell(
// //                       onTap: () {
// //                         if (keyForm.currentState?.validate() == true) {
// //                           registerAccount();
// //                         }
// //                       },
// //                       child: Container(
// //                         height: 60,
// //                         decoration: BoxDecoration(
// //                           color: Color(0xFF275D20),
// //                           borderRadius: BorderRadius.circular(30),
// //                         ),
// //                         child: Stack(
// //                           alignment: Alignment.center,
// //                           children: <Widget>[
// //                             Align(
// //                               alignment: Alignment.center,
// //                               child: Text(
// //                                 'Sign Up',
// //                                 textAlign: TextAlign.center,
// //                                 style: TextStyle(
// //                                   fontSize: 16,
// //                                   fontWeight: FontWeight.bold,
// //                                   color: Colors.white,
// //                                   fontFamily: 'Jost',
// //                                 ),
// //                               ),
// //                             ),
// //                             Positioned(
// //                               right: 16,
// //                               child: Container(
// //                                 decoration: BoxDecoration(
// //                                   shape: BoxShape.circle,
// //                                   color: Colors.white,
// //                                 ),
// //                                 child: Padding(
// //                                   padding: const EdgeInsets.all(10),
// //                                   child: Icon(
// //                                     Icons.arrow_forward,
// //                                     color: Color(0xFF275D20),
// //                                     size: 24,
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //               InkWell(
// //                 onTap: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(builder: (context) => LoginPage()),
// //                   );
// //                 },
// //                 child: Container(
// //                   alignment: Alignment.center,
// //                   child: RichText(
// //                     textAlign: TextAlign.center,
// //                     text: TextSpan(
// //                       style: TextStyle(
// //                         color: Color(0xFF545454),
// //                         fontFamily: 'Mulish',
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                       ),
// //                       children: [
// //                         TextSpan(text: "Already have an Account? "),
// //                         TextSpan(
// //                           text: "SIGN IN",
// //                           style: TextStyle(
// //                             color: Color(0xFF0961F5),
// //                             decoration: TextDecoration.underline,
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:project_kejaksaan/login/login_page.dart';
// import 'package:project_kejaksaan/models/model_register.dart';
//
// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});
//
//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   TextEditingController txtFullName = TextEditingController();
//   TextEditingController txtUsername = TextEditingController();
//   TextEditingController txtEmail = TextEditingController();
//   TextEditingController txtPassword = TextEditingController();
//   TextEditingController txtPhoneNumber = TextEditingController();
//   TextEditingController txtKtp = TextEditingController();
//   TextEditingController txtAlamat = TextEditingController();
//   String _roleValue = 'User';  // Default role set to "User"
//
//   GlobalKey<FormState> keyForm = GlobalKey<FormState>();
//
//   bool isLoading = false;
//   bool _isPasswordVisible = false;
//
//   Future<ModelRegister?> registerAccount() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });
//       http.Response res = await http.post(
//         Uri.parse('http://192.168.1.20/kejaksaan/register.php'),
//         body: {
//           "username": txtUsername.text,
//           "password": txtPassword.text,
//           "fullname": txtFullName.text,
//           "email": txtEmail.text,
//           "phone_number": txtPhoneNumber.text,
//           "ktp": txtKtp.text,
//           "alamat": txtAlamat.text,
//           "role": _roleValue,  // Use the default role value
//         },
//       );
//
//       ModelRegister data = modelRegisterFromJson(res.body);
//       //cek kondisi respon
//       if (data.value == 1) {
//         setState(() {
//           isLoading = false;
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('${data.message}')),
//           );
//           //kondisi berhasil dan pindah ke page login
//           Navigator.pushAndRemoveUntil(
//             context,
//             MaterialPageRoute(builder: (context) => LoginPage()),
//                 (route) => false,
//           );
//         });
//         //kondisi email sudah ada
//       } else if (data.value == 2) {
//         setState(() {
//           isLoading = false;
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('${data.message}')),
//           );
//         });
//         //kondisi gagal daftar
//       } else {
//         isLoading = false;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('${data.message}')),
//         );
//       }
//     } catch (e) {
//       isLoading = false;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
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
//               Center(
//                 child: Column(
//                   children: [
//                     Image.asset(
//                       'assets/images/login.png',
//                       width: 200,
//                       height: 100,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 5),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Sign Up",
//                     style: TextStyle(
//                       fontFamily: 'Jost',
//                       fontSize: 24,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Text(
//                     "Create your Account ",
//                     style: TextStyle(
//                       fontFamily: 'Mulish',
//                       fontSize: 14,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                 ],
//               ),
//               SizedBox(height: 10),
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
//                         prefixIcon: Icon(Icons.person, color: Color(0xFF545454)),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(vertical: 0),
//                       ),
//                     ),
//                     SizedBox(height: 10),
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
//                         prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF545454)),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
//                     SizedBox(height: 10),
//                     TextFormField(
//                       validator: (val) {
//                         return val!.isEmpty ? "Email cannot be empty" : null;
//                       },
//                       controller: txtEmail,
//                       style: TextStyle(
//                         fontFamily: 'Mulish',
//                       ),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: "Email",
//                         prefixIcon: Icon(Icons.mail_outline, color: Color(0xFF545454)),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(vertical: 0),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       validator: (val) {
//                         return val!.isEmpty ? "Fullname cannot be empty" : null;
//                       },
//                       controller: txtFullName,
//                       style: TextStyle(
//                         fontFamily: 'Mulish',
//                       ),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: "Full name",
//                         prefixIcon: Icon(Icons.people_alt, color: Color(0xFF545454)),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(vertical: 0),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       validator: (val) {
//                         return val!.isEmpty ? "Phone Number cannot be empty" : null;
//                       },
//                       controller: txtPhoneNumber,
//                       style: TextStyle(
//                         fontFamily: 'Mulish',
//                       ),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: "Phone Number",
//                         prefixIcon: Icon(Icons.phone, color: Color(0xFF545454)),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(vertical: 0),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       validator: (val) {
//                         return val!.isEmpty ? "KTP cannot be empty" : null;
//                       },
//                       controller: txtKtp,
//                       style: TextStyle(
//                         fontFamily: 'Mulish',
//                       ),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: "KTP",
//                         prefixIcon: Icon(Icons.perm_identity, color: Color(0xFF545454)),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(vertical: 0),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       validator: (val) {
//                         return val!.isEmpty ? "Alamat cannot be empty" : null;
//                       },
//                       controller: txtAlamat,
//                       style: TextStyle(
//                         fontFamily: 'Mulish',
//                       ),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: Colors.white,
//                         hintText: "Alamat",
//                         prefixIcon: Icon(Icons.location_city, color: Color(0xFF545454)),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8.0),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(vertical: 0),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     InkWell(
//                       onTap: () {
//                         if (keyForm.currentState?.validate() == true) {
//                           registerAccount();
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
//                                 'Sign Up',
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
//               SizedBox(height: 20),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => LoginPage()),
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
//                         TextSpan(text: "Already have an Account? "),
//                         TextSpan(
//                           text: "SIGN IN",
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

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_kejaksaan/login/login_page.dart';
import 'package:project_kejaksaan/models/model_register.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController txtFullName = TextEditingController();
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtPhoneNumber = TextEditingController();
  TextEditingController txtKtp = TextEditingController();
  TextEditingController txtAlamat = TextEditingController();
  String _roleValue = 'User';  // Default role set to "User"

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> registerAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(
        Uri.parse('http://192.168.1.3/kejaksaan/register.php'),
        body: {
          "username": txtUsername.text,
          "password": txtPassword.text,
          "fullname": txtFullName.text,
          "email": txtEmail.text,
          "phone_number": txtPhoneNumber.text,
          "ktp": txtKtp.text,
          "alamat": txtAlamat.text,
          "role": _roleValue,  // Use the default role value
        },
      );

      ModelRegister data = modelRegisterFromJson(res.body);

      if (data.value == 1) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
          );
        });
      } else if (data.value == 2) {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.message}')),
          );
        });
      } else {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );
      }
    } catch (e) {
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      // Optionally, you can log the error for debugging purposes
      print('Error in registerAccount: $e');
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
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/kejati.png',
                      width: 200,
                      height: 100,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "Create your Account ",
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
              SizedBox(height: 10),
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
                        prefixIcon: Icon(Icons.person, color: Color(0xFF545454)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    SizedBox(height: 10),
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
                        prefixIcon: Icon(Icons.lock_outline, color: Color(0xFF545454)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Email cannot be empty" : null;
                      },
                      controller: txtEmail,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Email",
                        prefixIcon: Icon(Icons.mail_outline, color: Color(0xFF545454)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Fullname cannot be empty" : null;
                      },
                      controller: txtFullName,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Full name",
                        prefixIcon: Icon(Icons.people_alt, color: Color(0xFF545454)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Phone Number cannot be empty" : null;
                      },
                      controller: txtPhoneNumber,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Phone Number",
                        prefixIcon: Icon(Icons.phone, color: Color(0xFF545454)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "KTP cannot be empty" : null;
                      },
                      controller: txtKtp,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "KTP",
                        prefixIcon: Icon(Icons.perm_identity, color: Color(0xFF545454)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (val) {
                        return val!.isEmpty ? "Alamat cannot be empty" : null;
                      },
                      controller: txtAlamat,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "Alamat",
                        prefixIcon: Icon(Icons.location_city, color: Color(0xFF545454)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        if (keyForm.currentState?.validate() == true) {
                          registerAccount();
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
                                'Sign Up',
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
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
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
                        TextSpan(text: "Already have an Account? "),
                        TextSpan(
                          text: "SIGN IN",
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
