import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_data.dart';

class LayoutUsers extends StatefulWidget {
  const LayoutUsers({Key? key}) : super(key: key);

  @override
  LayoutUserState createState() => LayoutUserState();
}

class LayoutUserState extends State<LayoutUsers> {
  List<Map<String, dynamic>> usersData = [];

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
              final standardUsers = appData.userData.where((userData) => userData['pla'] == 'standard').toList();
              final premiumUsers = appData.userData.where((userData) => userData['pla'] == 'premium').toList();
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
                          const Text('Standard Users', style: TextStyle(fontSize: 25)),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: standardUsers.length,
                              itemBuilder: (BuildContext context, int index) {
                                final userData = standardUsers[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (kDebugMode) {
                                        print(userData['email']);
                                      }
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
                                                Text('Phone: ${userData['telefon']}'),
                                                Text('Groups: ${userData['grups'].join(', ')}'),
                                                Text('Total Quota: ${userData['quota']['total']}'),
                                                Text('Consumed Quota: ${userData['quota']['consumida']}'),
                                                Text('Available Quota: ${userData['quota']['disponible']}'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20), // Add some space between the columns
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text('Premium Users', style: TextStyle(fontSize: 25)),
                          const SizedBox(height: 20),
                          Expanded(
                            child: ListView.builder(
                              itemCount: premiumUsers.length,
                              itemBuilder: (BuildContext context, int index) {
                                final userData = premiumUsers[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (kDebugMode) {
                                        print(userData['email']);
                                      }
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
                                                Text('Phone: ${userData['telefon']}'),
                                                Text('Groups: ${userData['grups'].join(', ')}'),
                                                Text('Total Quota: ${userData['quota']['total']}'),
                                                Text('Consumed Quota: ${userData['quota']['consumida']}'),
                                                Text('Available Quota: ${userData['quota']['disponible']}'),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
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
}
