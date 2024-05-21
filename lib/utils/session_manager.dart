// import 'package:shared_preferences/shared_preferences.dart';
//
// class SessionManager {
//   int? value;
//   String? id;
//   String? username;
//   String? fullname;
//   String? email;
//   String? phone_number;
//   String? ktp;
//   String? alamat;
//   String? role;
//
//   Future<void> saveSession(int val, String id, String username, String fullname, String email, String phone_number,String ktp, String alamat,String role) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setInt("value", val);
//     await pref.setString("id", id);
//     await pref.setString("username", username);
//     await pref.setString("fullname", fullname);
//     await pref.setString("email", email);
//     await pref.setString("phone_number", phone_number);
//     await pref.setString("ktp", ktp);
//     await pref.setString("alamat", alamat);
//     await pref.setString("role", role);
//
//   }
//
//   Future<bool> getSession() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     value = pref.getInt("value");
//     id = pref.getString("id");
//     username = pref.getString("username");
//     fullname = pref.getString("fullname");
//     email = pref.getString("email");
//     phone_number = pref.getString("phone_number");
//     ktp = pref.getString("ktp");
//     alamat = pref.getString("alamat");
//     role = pref.getString("role");
//
//     return username != null;
//   }
//
//   Future<void> clearSession() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.clear();
//   }
// }
//
// SessionManager sessionManager = SessionManager();
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  int? value;
  String? id;
  String? username;
  String? fullname;
  String? email;
  String? phone_number;
  String? ktp;
  String? alamat;
  String? role;

  Future<void> saveSession(int val, String id, String username, String fullname, String email, String phone_number,String ktp, String alamat,String role) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("value", val);
    await pref.setString("id", id);
    await pref.setString("username", username);
    await pref.setString("fullname", fullname);
    await pref.setString("email", email);
    await pref.setString("phone_number", phone_number);
    await pref.setString("ktp", ktp);
    await pref.setString("alamat", alamat);
    await pref.setString("role", role);
  }

  Future<bool> getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    value = pref.getInt("value");
    id = pref.getString("id");
    username = pref.getString("username");
    fullname = pref.getString("fullname");
    email = pref.getString("email");
    phone_number = pref.getString("phone_number");
    ktp = pref.getString("ktp");
    alamat = pref.getString("alamat");
    role = pref.getString("role");

    return username != null;
  }

  Future<String?> getUserID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("id");
  }

  Future<void> clearSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}

SessionManager sessionManager = SessionManager();
