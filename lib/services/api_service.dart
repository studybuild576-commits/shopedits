// lib/services/api_service.dart

import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/constants.dart'; // constants.dart को इम्पोर्ट करें

class ApiService {
  
  static Future<Uint8List?> removeBackground(Uint8List imageBytes) async {
    String base64Image = 'data:image/png;base64,${base64Encode(imageBytes)}';

    try {
      final response = await http.post(
        Uri.parse(huggingFaceApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          // Background Remover का fn_index 0 है
          'fn_index': 0,
          'data': [base64Image],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          String outputImageString = data['data'][0].toString().split(',').last;
          return base64Decode(outputImageString);
        } else {
          Fluttertoast.showToast(msg: "Error: Received empty response from server.");
          return null;
        }
      } else {
        Fluttertoast.showToast(msg: "Error: ${response.statusCode} - ${response.reasonPhrase}");
        print("Server error: ${response.body}");
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred. Check your internet connection.");
      print("Exception: $e");
      return null;
    }
  }

  // भविष्य में आप बाकी फीचर्स के लिए भी यहीं फंक्शन बना सकते हैं
  // static Future<Uint8List?> changeBackground(...) async { ... }
  // static Future<Uint8List?> resizeImage(...) async { ... }
}
