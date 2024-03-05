import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AppData with ChangeNotifier {
  String adminToken = "xd";
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
}
