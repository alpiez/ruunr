import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ruunr/screens/signin_screen.dart';
import 'package:ruunr/services/firestore_service.dart';

class SettingsScreen extends StatelessWidget {
  static String routeName = "/settings";
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        children: [
          ListTile(onTap: () {print("hello");}, title: const Text("Account"), trailing: const Icon(Icons.keyboard_arrow_right), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ListTile(onTap: () {print("hello");}, title: const Text("Export Data"), trailing: const Icon(Icons.keyboard_arrow_right), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ListTile(onTap: () {print("hello");}, title: const Text("Feedback"), trailing: const Icon(Icons.keyboard_arrow_right), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ElevatedButton(
            onPressed: () { FirebaseAuth.instance.signOut(); Navigator.pushNamedAndRemoveUntil(context, SignInScreen.routeName, (route) => false); }, 
            child: const Text("Log Out"),
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)), minimumSize: const Size(150, 45), primary: const Color(0xffF8F9FA)),
          ),

        ],
      ),
    );
  }
}
