import 'dart:convert';
import 'dart:io';

import 'package:cupertino_base/app_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';


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

  Future<void> saveFiles(String url) async {
    // Save url in txt
    try {
      final file = File('imagIA_server_url.txt');
      await file.writeAsString(url);
      
    } catch (e) {
        if (kDebugMode) {
          print("Error saving text file");
        }
    }
  }

  Future<void> readUrl() async {
    try {
      final file = File('imagIA_server_url.txt');
      if (await file.exists()) {
        final url = await file.readAsString();
        setState(() {
          urlController.text = url;
        });
      }
      
    } catch (e) {
      if (kDebugMode) { print("Error reading server URL: $e"); }
    }
  }

  Future<void> login(BuildContext context, AppData appData) async {
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

        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == "OK") {
          appData.adminToken = jsonResponse["data"]["api_key"];
          if (kDebugMode) {
            print("login exitos");
          }
          // ignore: use_build_context_synchronously
          showToast(context, "Login com admin exitos", Colors.green);
          await saveFiles(url);
          appData.readUserData(appData.adminToken);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, 'users');
          
        } else {
          // ignore: use_build_context_synchronously
          showToast(context, "Login com admin NO exitos", Colors.red);
          if (kDebugMode) {
            print("login NO exitos");
          }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error al enviar peticio");
      }
    }
  }

  void showToast(BuildContext context, String message, Color color) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(message),
      description: RichText(text: const TextSpan(text: 'This is a sample toast message. ')),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      icon: const Icon(Icons.check),
      primaryColor: color,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        // ignore: avoid_print
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        // ignore: avoid_print
        onCloseButtonTap: (toastItem) => print('Toast ${toastItem.id} close button tapped'),
        // ignore: avoid_print
        onAutoCompleteCompleted: (toastItem) => print('Toast ${toastItem.id} auto complete completed'),
        // ignore: avoid_print
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);
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
                    login(context, appData);
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
