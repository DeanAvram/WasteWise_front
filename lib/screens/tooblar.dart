import 'package:flutter/material.dart';
import 'package:map_app/screens/account_screen.dart';
import 'package:map_app/screens/login_screen.dart';
import 'package:map_app/screens/recycle_history_screen.dart';

class Tooblar extends StatelessWidget {
  final String name, email, password, role;
  const Tooblar(
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
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 40, 45, 50),
      width: 250,
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 120, 15, 125),
            child: SizedBox(
              height: 100.0,
              child: DrawerHeader(
                padding: const EdgeInsets.only(top: 5, left: 15),
                child: Row(
                  children: [
                    /*Image.asset(
                      'assets/logos/logo-black-nobackground.png',
                      height: 100.0,
                    ),*/
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.account_circle_outlined, color: Colors.white),
            title:
                const Text('My Account', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountScreen(
                          name: userName,
                          email: userEmail,
                          password: userPassword,
                          role: userRole)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.white),
            title: const Text('My Recycle History',
                style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RecycleHistoryScreen(
                          name: userName,
                          email: userEmail,
                          password: userPassword,
                          role: userRole)));
            },
          ),
          // Add more items as needed
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context); // Close the drawer
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Log Out',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)))),
            ),
          ),
        ],
      ),
    );
  }
}
