import 'package:flutter/material.dart';
import 'package:project_kejaksaan/welcome_page.dart';

void main() {
  // Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp()
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Kejaksaan',
      theme: ThemeData(
        // Ini adalah tema aplikasi Anda.
        //
        // COBA INI: Cobalah menjalankan aplikasi Anda dengan "flutter run". Anda akan melihat
        // aplikasi memiliki toolbar berwarna ungu. Kemudian, tanpa keluar dari aplikasi,
        // coba ubah seedColor dalam colorScheme di bawah ini menjadi Colors.green
        // dan kemudian lakukan "hot reload" (simpan perubahan Anda atau tekan tombol "hot reload"
        // di IDE yang mendukung Flutter, atau tekan "r" jika Anda menggunakan
        // baris perintah untuk memulai aplikasi).
        //
        // Perhatikan bahwa penghitung tidak direset kembali ke nol; status aplikasi
        // tidak hilang selama reload. Untuk mereset status, gunakan hot restart sebagai gantinya.
        //
        // Ini juga berfungsi untuk kode, bukan hanya nilai: Sebagian besar perubahan kode dapat diuji
        // dengan hanya hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WelcomePage(),
      debugShowCheckedModeBanner: false, // Menyembunyikan banner mode debug.
    );
  }
}
