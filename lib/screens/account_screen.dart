import 'package:flutter/material.dart';
import 'package:map_app/screens/account_info_screen.dart';

class AccountScreen extends StatelessWidget {
  final String name, email, password, role;
  const AccountScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.password,
      required this.role});

  String get userName => name;
  String get userEmail => email;
  String get userPassword => password;
  String get userRole => role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Account', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromARGB(255, 40, 45, 50),
          iconTheme: const IconThemeData(color: Colors.white)),
      backgroundColor: const Color.fromARGB(
          255, 40, 45, 50), // Set the background color of the entire screen
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: AccountInfoScreen(
          name: userName,
          email: userEmail,
          password: userPassword,
          role: userRole,
        ),
      ),
    );
  }
}
