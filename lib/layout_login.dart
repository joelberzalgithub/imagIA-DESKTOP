import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LayoutLogin extends StatefulWidget {
  const LayoutLogin({Key? key}) : super(key: key);

  @override
  LayoutLoginState createState() => LayoutLoginState();
}

class LayoutLoginState extends State<LayoutLogin> {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    readUrl();
  }

  Future<void> saveUrl(String url) async {
    final file = File('imagIA_server_url.txt');
    await file.writeAsString(url);
  }

  Future<void> readUrl() async {
    try {
      final file = File('imagIA_server_url.txt');
      final url = await file.readAsString();
      setState(() {
        urlController.text = url;
      });
    } catch (e) {
      if (kDebugMode) { print("Error reading server URL: $e"); }
    }
  }

  Future<void> login() async {
    final url = urlController.text;
    final email = emailController.text;
    final password = passwordController.text;

    final Map<String, String> data = {
      'email': email,
      'password': password,
    };

    final jsonData = json.encode(data);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String> { 'Content-Type': 'application/json; charset=UTF-8', },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        if (kDebugMode) { print('Login Successful: ${response.body}'); }
        await saveUrl(url);
      } else {
        if (kDebugMode) { print('Failed to login: ${response.statusCode}'); }
      }
    } catch (e) {
      if (kDebugMode) { print('Exception during login: $e'); }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text('ImagIA App Flutter', style: TextStyle(fontSize: 25)),
                TextFormField(
                  controller: urlController,
                  decoration: const InputDecoration(labelText: 'URL del servidor'),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Usuari'),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Contrasenya'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    login();
                  },
                  child: const Text('Iniciar Sessió'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
