import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AppData with ChangeNotifier {
  String adminToken = "";
  List<Map<String, dynamic>> userData = [];
  
  Future<void> readUserData(String token) async {
    final url = Uri.parse('https://ams24.ieti.site/api/users/admin_get_list');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final jsonData = json.decode(response.body);
    final dataList = jsonData['data'];

    userData.clear();

    for (var data in dataList) {
      Map<String, dynamic> userDataMap = {
        'nickname': data['nickname'],
        'email': data['email'],
        'telefon': data['telefon'],
        'validat': data['validat'],
        'tos': data['tos'],
        'pla': data['pla'],
        'grups': data['grups'],
        'quota': data['quota'],
      };
      userData.add(userDataMap);
    }
    notifyListeners();
  }
  
  void changeUserPlan(String email, String newPlan) {
    for (var user in userData) {
      if (user['email'] == email) {
        user['pla'] = newPlan;
        notifyListeners();
        break;
      }
    }
  }

  Future<void> fetchUserData() async {
    try {
      var response = await http.get(
        Uri.parse('https://ams24.ieti.site/api/users/admin_get_list'),
        headers: {
          'Authorization': 'Bearer $adminToken',
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        
        var userData = jsonResponse['data'];
        
        for (var user in userData) {
          if (kDebugMode) { print('Nickname: ${user['nickname']}'); }
          if (kDebugMode) { print('Email: ${user['email']}'); }
          if (kDebugMode) { print('Telephone: ${user['telefon']}'); }
          if (kDebugMode) { print('Validated: ${user['validat']}'); }
          if (kDebugMode) { print('Quota Total: ${user['quota']['total']}'); }
          if (kDebugMode) { print('Quota Consumed: ${user['quota']['consumida']}'); }
          if (kDebugMode) { print('Quota Available: ${user['quota']['disponible']}'); }
          if (kDebugMode) { print('Groups: ${user['grups']}'); }
          if (kDebugMode) { print('-------------------'); }
        }
        
        if (kDebugMode) { print('Message: ${jsonResponse['message']}'); }
        if (kDebugMode) { print('Status: ${jsonResponse['status']}'); }
        notifyListeners();
      } else {
        if (kDebugMode) { print('Request failed with status: ${response.statusCode}'); }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception: $e');
      }
    }
  }
}
