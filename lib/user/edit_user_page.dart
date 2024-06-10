import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_kejaksaan/models/model_user.dart';
import 'package:project_kejaksaan/user/list_user_page.dart'; // Update with your model path
import 'package:http/http.dart' as http;

class EditUserPage extends StatefulWidget {
  final ModelUsers currentUser;

  const EditUserPage({required this.currentUser});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtFullname = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPhoneNumber = TextEditingController();
  TextEditingController txtKtp = TextEditingController();
  TextEditingController txtAlamat = TextEditingController();
  String _roleValue = '';

  @override
  void initState() {
    super.initState();
    txtUsername.text = widget.currentUser.username;
    txtFullname.text = widget.currentUser.fullname;
    txtEmail.text = widget.currentUser.email;
    txtPhoneNumber.text = widget.currentUser.phone_number;
    txtKtp.text = widget.currentUser.ktp;
    txtAlamat.text = widget.currentUser.alamat;
    _roleValue = widget.currentUser.role;
  }

  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Text(""),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/congratulation.png',
                height: 200,
                width: 200,
              ),
              Text(
                "Congratulations",
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Jost', fontSize: 24),
              ),
              SizedBox(height: 20),
              Text(
                "Your Account is Ready to Use",
                style: TextStyle(fontFamily: 'Mulish'),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/images/loading.png',
                height: 30,
                width: 30,
              ),
            ],
          ),
          actions: [],
        );
      },
    );
  }

  void saveChanges(String newUsername, String newFullName, String newEmail, String newPhoneNumber, String newKtp, String newAlamat, String newRole) async {
    if (newUsername.isEmpty || newFullName.isEmpty || newEmail.isEmpty || newPhoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All fields are required')));
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(newEmail)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid email format')));
      return;
    }

    try {
      var url = Uri.parse('http://192.168.31.53/kejaksaan/updateUser.php');
      var response = await http.post(url, body: {
        'id': widget.currentUser.id.toString(),
        'username': newUsername,
        'email': newEmail,
        'fullname': newFullName,
        'phone_number': newPhoneNumber,
        'ktp': newKtp,
        'alamat': newAlamat,
        'role': newRole,
      });

      var data = json.decode(response.body);

      if (data['is_success']) {
        setState(() {
          widget.currentUser.username = newUsername;
          widget.currentUser.email = newEmail;
          widget.currentUser.fullname = newFullName;
          widget.currentUser.phone_number = newPhoneNumber;
          widget.currentUser.ktp = newKtp;
          widget.currentUser.alamat = newAlamat;
          widget.currentUser.role = newRole;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));

        Navigator.pop(context, widget.currentUser); // Pass the updated user back to the previous screen
        _showCongratulationsDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5BB04B),
      appBar: AppBar(
        backgroundColor: Color(0xFF5BB04B),
        title: Row(
          children: [
            Text(
              'Edit Your Profile',
              style: TextStyle(fontSize: 18.0, fontFamily: 'Jost', fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(0xFF275D20),
                      radius: 50,
                      child: Text(
                        widget.currentUser.username[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Color(0xFF275D20),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(
                  fontFamily: 'Mulish',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "UserName",
                  prefixIcon: Icon(Icons.person, color: Color(0xFF545454)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                controller: txtUsername,
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(
                  fontFamily: 'Mulish',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Full Name",
                  prefixIcon: Icon(Icons.person_2, color: Color(0xFF545454)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                controller: txtFullname,
              ),
              SizedBox(height: 20),
              TextField(
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
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                controller: txtEmail,
              ),
              SizedBox(height: 20),
              TextField(
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
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                controller: txtPhoneNumber,
              ),
              SizedBox(height: 10),
              TextField(
                style: TextStyle(
                  fontFamily: 'Mulish',
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Ktp",
                  prefixIcon: Icon(Icons.card_giftcard, color: Color(0xFF545454)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                controller: txtKtp,
              ),
              SizedBox(height: 10),
              TextField(
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
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                controller: txtAlamat,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Role',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.person_2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                value: _roleValue,
                onChanged: (value) {
                  setState(() {
                    _roleValue = value!;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: 'Admin',
                    child: Text('Admin'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Customer',
                    child: Text('Customer'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () {
                  // Implement logic to save changes
                  String newUsername = txtUsername.text;
                  String newEmail = txtEmail.text;
                  String newFullName = txtFullname.text;
                  String newPhoneNumber = txtPhoneNumber.text;
                  String newKtp = txtKtp.text;
                  String newAlamat = txtAlamat.text;
                  String newRole = _roleValue;

                  // Call the function to save changes
                  saveChanges(newUsername, newFullName, newEmail, newPhoneNumber, newKtp, newAlamat, newRole);
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
                          'Save Changes',
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
      ),
    );
  }
}
