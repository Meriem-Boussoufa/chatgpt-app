import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgpt_app/models/chat.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../models/model.dart';

class ApiService {
  static Future<List<Model>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        log("jsonResponse['error'] : ${jsonResponse['error']['message']}");
        throw HttpException(jsonResponse['error']['message']);
      }
      log("jsonResponse: $jsonResponse");
      List temp = [];
      for (var value in jsonResponse["data"]) {
        temp.add(value);
        log("temp: ${value["id"]}");
      }
      return Model.modelsFromSnapshot(temp);
    } catch (error) {
      log("error: $error");
      rethrow;
    }
  }

  static Future<List<Chat>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      var response = await http.post(Uri.parse("$BASE_URL/chat/completions"),
          headers: {
            'Authorization': 'Bearer $API_KEY',
            'Content-Type': "application/json"
          },
          body: jsonEncode({
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ],
            "temperature": 0.7,
          }));
      Map jsonResponse = jsonDecode(response.body);
      //log(response.body.toString());
      if (jsonResponse['error'] != null) {
        throw HttpException(jsonResponse['error']['message']);
      }
      List<Chat> chatList = [];

      if (jsonResponse["choices"].length > 0) {
        log("jsonResponse[choices][text] : ${jsonResponse['choices'][0]['message']['content']}");
        chatList = List.generate(
            jsonResponse['choices'].length,
            (index) => Chat(
                  msg: jsonResponse['choices'][index]['message']['content'],
                  chatIndex: 1,
                ));
      }
      return chatList;
    } catch (error) {
      log("error: $error");
      rethrow;
    }
  }
}
