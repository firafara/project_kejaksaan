import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:project_kejaksaan/models/model_penyuluhan.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PenyuluhanDetailPage extends StatefulWidget {
  final Datum penyuluhan;

  const PenyuluhanDetailPage({Key? key, required this.penyuluhan}) : super(key: key);

  @override
  _PenyuluhanDetailPageState createState() => _PenyuluhanDetailPageState();
}

class _PenyuluhanDetailPageState extends State<PenyuluhanDetailPage> {
  String? laporanPdfFilePath;
  String? ktpPdfFilePath;

  @override
  void initState() {
    super.initState();
    _downloadPdf('laporan');
    _downloadPdf('ktp');
  }

  Future<void> _downloadPdf(String type) async {
    String pdfUrl;
    if (type == 'laporan') {
      pdfUrl = 'https://umkm-pnp.com/api-kejaksaan/kejaksaan/${widget.penyuluhan.bentuk_permasalahan_pdf}';
    } else {
      pdfUrl = 'https://umkm-pnp.com/api-kejaksaan/kejaksaan/${widget.penyuluhan.ktp_pdf}';
    }

    // Log the URL for debugging
    print('PDF URL: $pdfUrl');

    try {
      var response = await http.get(Uri.parse(pdfUrl));
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        var dir = await getApplicationDocumentsDirectory();
        var uploadDir = Directory('${dir.path}/uploads');

        if (!await uploadDir.exists()) {
          await uploadDir.create(recursive: true);
        }

        String fileName = pdfUrl.split('/').last;
        File file = File('${uploadDir.path}/$fileName');
        await file.writeAsBytes(bytes, flush: true);
        setState(() {
          if (type == 'laporan') {
            laporanPdfFilePath = file.path;
          } else {
            ktpPdfFilePath = file.path;
          }
        });
      } else {
        throw Exception('Failed to download PDF. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Penyuluhan",
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF5BB04B),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.penyuluhan.bentuk_permasalahan ?? '',
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 20,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Nama Pelapor: ' + (widget.penyuluhan.nama_pelapor ?? 'Loading...'),
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tanggal Pelaporan: ' + (widget.penyuluhan.created_at ?? 'Loading...'),
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Created by: ${widget.penyuluhan.fullname ?? 'Loading...'}',
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: laporanPdfFilePath != null
                  ? PDFView(filePath: laporanPdfFilePath!)
                  : Center(child: CircularProgressIndicator()),
            ),
            SizedBox(height: 20),
            Text(
              'KTP PDF',
              style: TextStyle(
                fontFamily: 'Jost',
                fontSize: 20,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ktpPdfFilePath != null
                  ? PDFView(filePath: ktpPdfFilePath!)
                  : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
