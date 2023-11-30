import 'package:flutter/material.dart';
import 'package:map_app/pages/account_info_screen.dart';

class AccountScreen extends StatelessWidget {
  final String name, email, password, role;
  const AccountScreen({super.key, required this.name, required this.email, required this.password, required this.role});

  String get userName => name;
  String get userEmail => email;
  String get userPassword => password;
  String get userRole => role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: AccountInfoScreen(name: userName, email: userEmail, password: userPassword, role: userRole),
      ),
    );
  }
}
