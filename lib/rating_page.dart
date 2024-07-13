import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:project_kejaksaan/utils/session_manager.dart';
import 'dart:convert';
import 'package:project_kejaksaan/Api/Api.dart';


class RatingDialog extends StatefulWidget {
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  double _rating = 0;
  TextEditingController _ulasanController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitRating() async {
    setState(() {
      _isLoading = true;
    });

    String userId = sessionManager.id!;
    String namaPelapor = sessionManager.username!;

    final response = await http.post(
      Uri.parse(Api.AddRating), // Ganti dengan URL API yang benar
      body: {
        'user_id': userId,
        'rating': _rating.toStringAsFixed(0), // Mengonversi nilai double menjadi string tanpa desimal
        'nama_pelapor': namaPelapor,
        'ulasan': _ulasanController.text,
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['isSuccess']) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rating submitted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit rating: ${jsonResponse['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error, please try again later.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Rate Us',
        style: TextStyle(fontFamily: 'Jost', fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingBar.builder(
            initialRating: 0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          TextField(
            controller: _ulasanController,
            decoration: InputDecoration(
              labelText: 'Ulasan',
              labelStyle: TextStyle(fontFamily: 'Jost'),
            ),
            style: TextStyle(fontFamily: 'Jost'),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(fontFamily: 'Jost'),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: _isLoading
              ? CircularProgressIndicator()
              : Text(
            'Submit',
            style: TextStyle(fontFamily: 'Jost'),
          ),
          onPressed: _isLoading ? null : _submitRating,
        ),
      ],
    );
  }
}
