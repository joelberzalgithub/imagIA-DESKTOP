import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AppData with ChangeNotifier {
  String peticio = '''
  {
    "status": "OK",
    "message": "Consulta realitzada correctament",
    "data": [
      {
        "nickname": "SparkleFuzzMcGee",
        "email": "user1@example.com",
        "telefon": "+34 600 000 001",
        "validat": true,
        "tos": true,
        "pla": "premium",
        "grups": ["Desenvolupadors", "Beta Testers"],
        "quota": {
          "total": 100,
          "consumida": 20,
          "disponible": 80
        }
      },
      {
        "nickname": "ShinyGlimmer",
        "email": "user2@example.com",
        "telefon": "+34 600 000 002",
        "validat": true,
        "tos": true,
        "pla": "standard",
        "grups": ["Users"],
        "quota": {
          "total": 50,
          "consumida": 10,
          "disponible": 40
        }
      },
      {
        "nickname": "ShinyGlimmer",
        "email": "user3@example.com",
        "telefon": "+34 600 000 002",
        "validat": true,
        "tos": true,
        "pla": "standard",
        "grups": ["Users"],
        "quota": {
          "total": 50,
          "consumida": 10,
          "disponible": 40
        }
      },
      {
        "nickname": "ShinyGlimmer",
        "email": "user4@example.com",
        "telefon": "+34 600 000 002",
        "validat": true,
        "tos": true,
        "pla": "standard",
        "grups": ["Users"],
        "quota": {
          "total": 50,
          "consumida": 10,
          "disponible": 40
        }
      },
      {
        "nickname": "ShinyGlimmer",
        "email": "user5@example.com",
        "telefon": "+34 600 000 002",
        "validat": true,
        "tos": true,
        "pla": "standard",
        "grups": ["Users"],
        "quota": {
          "total": 50,
          "consumida": 10,
          "disponible": 40
        }
      },
      {
        "nickname": "ShinyGlimmer",
        "email": "user6@example.com",
        "telefon": "+34 600 000 002",
        "validat": true,
        "tos": true,
        "pla": "standard",
        "grups": ["Users"],
        "quota": {
          "total": 50,
          "consumida": 10,
          "disponible": 40
        }
      }
    ]
  }
  ''';

  List<Map<String, dynamic>> userData = [];
  /*
  void readUserData() {
    Map<String, dynamic> jsonData = json.decode(peticio);
    List<dynamic> dataList = jsonData['data'];

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
  }
  */
  Future<void> readUserData(String token) async {
    final url = Uri.parse('https://ams24.ieti.site/api/users/admin_get_list');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
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
    } else {
      throw Exception('Failed to load user data');
    }
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
