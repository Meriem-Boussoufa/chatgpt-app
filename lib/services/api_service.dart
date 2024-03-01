import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class ApiService {
  static Future<void> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );
      Map jsonResponse = jsonDecode(response.body);
      log("jsonResponse: $jsonResponse");
      if (jsonResponse['error'] != null) {
        log("jsonResponse['error'] : ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
    } catch (error) {
      log("error: $error");
    }
  }
}
