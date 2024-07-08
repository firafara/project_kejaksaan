import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:csv/csv.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:project_kejaksaan/models/model_user.dart';
import 'package:project_kejaksaan/utils/session_manager.dart';
import 'package:project_kejaksaan/home_page.dart';
import 'package:project_kejaksaan/login/login_page.dart';
import 'package:open_file/open_file.dart';

class ListUserDataPage extends StatefulWidget {
  const ListUserDataPage({Key? key}) : super(key: key);

  @override
  _ListUserDataPageState createState() => _ListUserDataPageState();
}

class _ListUserDataPageState extends State<ListUserDataPage> {
  List<ModelUsers> _userList = [];
  List<ModelUsers> _filteredUserList = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  String? username;
  String? role;
  String? userId;

  @override
  void initState() {
    super.initState();
    _filteredUserList = [];
    getDataSession();
  }

  Future<void> getDataSession() async {
    bool hasSession = await sessionManager.getSession();
    if (hasSession) {
      setState(() {
        username = sessionManager.username;
        role = sessionManager.role;
        userId = sessionManager.id;
        print('Data session: $username');
      });
      _fetchUser();
    } else {
      print('Session tidak ditemukan!');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _exportToCsv() async {
    // Assuming filePath is correctly set up
    String filePath = '/Downloads/file.csv';

    try {
      await OpenFile.open(filePath);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Export Complete'),
            content: Text('CSV file exported successfully.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error opening file: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to open CSV file.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _fetchUser() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.11/kejaksaan/user.php'));
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        if (parsed['data'] != null) {
          setState(() {
            _userList = List<ModelUsers>.from(parsed['data'].map((x) => ModelUsers.fromJson(x)));
            _filterUserByRole();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }



  void _filterUserByRole() {
    if (role == 'User') {
      setState(() {
        _filteredUserList = _userList.where((user) => user.id.toString() == userId).toList();
      });
    } else {
      setState(() {
        _filteredUserList = _userList;
      });
    }
  }

  void _filterUsers(String keyword) {
    setState(() {
      _filteredUserList = _userList
          .where((user) =>
      user.fullname!.toLowerCase().contains(keyword.toLowerCase()) ||
          user.email!.toLowerCase().contains(keyword.toLowerCase()) ||
          user.phone_number!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List user",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF5BB04B),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Hi, ${username ?? ''}',
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
      backgroundColor: Color(0xFF5BB04B),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _filteredUserList.isEmpty
          ? Center(
        child: Text('Belum ada User'),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Cari',
                suffixIcon: IconButton(
                  onPressed: () => _searchController.clear(),
                  icon: Icon(Icons.clear),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUserList.length,
              itemBuilder: (context, index) {
                final user = _filteredUserList[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle user tap
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildListItem('Nama : ' + (user.fullname ?? 'Loading...')),
                          _buildListItem('Email : ' + (user.email ?? 'Loading...')),
                          _buildListItem('No HP : ' + (user.phone_number ?? 'Loading...')),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exportToCsv,
        backgroundColor: Colors.green,
        tooltip: 'Export to CSV',
        child: Icon(Icons.download),
      ),
    );
  }

  Widget _buildListItem(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Jost',
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }
}
