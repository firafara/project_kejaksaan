import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogApplication extends StatefulWidget {
  const LogApplication({Key? key}) : super(key: key);

  @override
  State<LogApplication> createState() => _LogApplicationState();
}

class _LogApplicationState extends State<LogApplication> {
  List<Map<String, dynamic>> logData = []; // List untuk menyimpan data log
  List<Map<String, dynamic>> filteredLogData = []; // List untuk menyimpan data log yang difilter
  Map<String, int> activityCount = {}; // Map untuk menyimpan jumlah aktivitas
  Map<int, String> userIdToUsername = {}; // Map untuk menyimpan username berdasarkan user_id
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData(); // Panggil method fetchData saat initState dipanggil
    _searchController.addListener(_filterLogs); // Tambahkan listener untuk pencarian
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterLogs);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://192.168.1.11/kejaksaan/getLog.php'); // Ganti dengan URL API Anda
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body); // Decode response body menjadi Map<String, dynamic>
        setState(() {
          logData = responseData['data'].cast<Map<String, dynamic>>(); // Ambil 'data' dari responseData dan cast menjadi List<Map<String, dynamic>>
          filteredLogData = logData; // Inisialisasi filteredLogData dengan semua data log
          countActivities(); // Panggil method untuk menghitung jumlah aktivitas setelah data diperbarui
        });
        fetchUsernames(); // Panggil method untuk mengambil username berdasarkan user_id
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error fetching data
    }
  }

  Future<void> fetchUsernames() async {
    // Ambil semua user_id yang unik dari logData
    Set<int> uniqueUserIds = logData.map((log) => int.tryParse(log['user_id'].toString()) ?? 0).toSet();

    // Iterasi dan ambil username untuk setiap user_id
    for (var userId in uniqueUserIds) {
      if (userId == 0) {
        // Jika userId == 0, artinya user_id tidak valid, Anda bisa melewatinya atau menangani secara khusus
        continue;
      }

      final userUrl = Uri.parse('http://192.168.1.11/kejaksaan/getUser.php?id=$userId'); // Ganti dengan URL API getUser.php
      try {
        final userResponse = await http.get(userUrl);
        if (userResponse.statusCode == 200) {
          Map<String, dynamic> userData = jsonDecode(userResponse.body); // Decode response body menjadi Map<String, dynamic>
          String username = userData['data'][0]['username'] ?? 'Unknown'; // Ambil username dari userData
          setState(() {
            userIdToUsername[userId] = username; // Simpan username ke dalam userIdToUsername
          });
        } else {
          throw Exception('Failed to load username for user_id: $userId');
        }
      } catch (e) {
        print('Error fetching username for user_id: $userId, Error: $e');
        // Handle error fetching username
      }
    }
  }

  void countActivities() {
    activityCount.clear(); // Bersihkan activityCount sebelum menghitung ulang

    // Iterasi melalui logData untuk menghitung jumlah aktivitas
    for (var log in logData) {
      String activityType = log['log_activity_type'] ?? '';
      if (activityCount.containsKey(activityType)) {
        activityCount[activityType] = activityCount[activityType]! + 1;
      } else {
        activityCount[activityType] = 1;
      }
    }
  }

  String getUsername(int userId) {
    return userIdToUsername[userId] ?? 'Unknown'; // Ambil username dari userIdToUsername, jika tidak ada kembalikan 'Unknown'
  }

  void _filterLogs() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredLogData = logData.where((log) {
        String logDescription = (log['log_description'] ?? '').toString().toLowerCase();
        return logDescription.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Application'),
        backgroundColor: Color(0xFF428137),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Log Description',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Tampilkan jumlah aktivitas berdasarkan jenis
          Card(
            margin: EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity, // Mengatur lebar Container menjadi sepanjang layar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: activityCount.keys.map((activityType) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '$activityType: ${activityCount[activityType]}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Tampilkan daftar log
          Expanded(
            child: ListView.builder(
              itemCount: filteredLogData.length,
              itemBuilder: (context, index) {
                // Mengambil data dari filteredLogData sesuai dengan index
                var log = filteredLogData[index];
                int userId = int.tryParse(log['user_id'].toString()) ?? 0;
                String username = getUsername(userId); // Ambil username berdasarkan user_id
                return ListTile(
                  title: Text(log['log_description'] ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('Username: $username'),
                      Text(log['table_modified'] ?? ''),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(log['log_date'] ?? ''),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
