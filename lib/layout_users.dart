import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'app_data.dart';

class LayoutUsers extends StatefulWidget {
  const LayoutUsers({Key? key}) : super(key: key);

  @override
  LayoutUserState createState() => LayoutUserState();
}

class LayoutUserState extends State<LayoutUsers> {
  String adminToken = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AppData>(
            builder: (context, appData, child) {
              adminToken = appData.adminToken;
              final standardUsers =
                  appData.userData.where((userData) => userData['pla'] == 'Free').toList();
              final premiumUsers =
                  appData.userData.where((userData) => userData['pla'] == 'Premium').toList();
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text('Usuaris Free', style: TextStyle(fontSize: 25)),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: standardUsers.length,
                              itemBuilder: (BuildContext context, int index) {
                                final userData = standardUsers[index];
                                return buildUserItem(userData, appData);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text('Usuaris Premium', style: TextStyle(fontSize: 25)),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: premiumUsers.length,
                              itemBuilder: (BuildContext context, int index) {
                                final userData = premiumUsers[index];
                                return buildUserItem(userData, appData);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildUserItem(Map<String, dynamic> userData, AppData appData) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Canviar plà de l\'usuari'),
              content: Text(
                  'Vols canviar el plà de ${userData['nickname']} a ${userData['pla'] == 'Free' ? 'Premium' : 'Free'}?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel·lar'),
                ),
                TextButton(
                  onPressed: () async {
                    final newPlan = userData['pla'] == 'Free' ? 'Premium' : 'Free';
                    final email = userData['email'];
                    final tfn = userData['telefon'];
                    final response = await sendPlanChangeRequest(tfn, newPlan);
                    final jsonResponse = jsonDecode(response.body);
                    if (jsonResponse['status'] == "OK") {
                      await appData.fetchUserData();
                      appData.changeUserPlan(email, newPlan);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('El plà de l\'usuari s\'ha canviat amb éxit!')));
                    } else {
                      if (kDebugMode) {
                        print('Failed to change plan: ${jsonResponse['message']}');
                      }
                    }
                  },
                  child: const Text('Canviar'),
                ),
              ],
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userData['nickname'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userData['email']),
                    Text('Telèfon: ${userData['telefon']}'),
                    Text('Grups: ${userData['grups'].join(', ')}'),
                    Text('Quota Total: ${userData['quota']['total']}'),
                    Text('Quota Consumida: ${userData['quota']['consumida']}'),
                    Text('Quota Disponible: ${userData['quota']['disponible']}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<http.Response> sendPlanChangeRequest(String tfn, String newPlan) async {
    final Map<String, dynamic> requestData = {
      'phone_number': tfn,
      'plan': newPlan,
    };
    final response = await http.post(
      Uri.parse('https://ams24.ieti.site/api/users/admin_change_plan'),
      body: jsonEncode(requestData),
      headers: {'Content-Type': 'application/json', 'Authorization': "Bearer $adminToken"},
    );
    return response;
  }
}
