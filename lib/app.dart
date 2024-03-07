import 'package:flutter/material.dart';
import 'layout_login.dart';
import 'layout_users.dart';

// Main application widget
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();
}

// Main application state
class AppState extends State<App> {
  // Definir el contingut del widget 'App'
  @override
  Widget build(BuildContext context) {
    // Farem servir la base 'Cupertino'
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LayoutLogin(),
      routes: {
        'login': (context) => const LayoutLogin(),
        'users': (context) => const LayoutUsers()
      },
    );
  }
}
