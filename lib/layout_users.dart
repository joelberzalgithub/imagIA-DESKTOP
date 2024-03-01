import 'package:flutter/material.dart';

class LayoutUsers extends StatefulWidget {
  const LayoutUsers({Key? key}) : super(key: key);

  @override
  LayoutUserState createState() => LayoutUserState();
}

class LayoutUserState extends State<LayoutUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Usuaris registrats', style: TextStyle(fontSize: 25))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
