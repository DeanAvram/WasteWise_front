import 'package:flutter/material.dart';
import 'package:map_app/pages/account_info_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        backgroundColor: Colors.blue,
      ),
      body: const Padding(
        padding: EdgeInsets.all(2.0),
        child: AccountInfoScreen(),
      ),
    );
  }
}
