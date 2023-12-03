import 'package:flutter/material.dart';
import 'package:map_app/pages/account_screen.dart';
import 'package:map_app/pages/login_screen.dart';
import 'package:map_app/pages/recycle_history_screen.dart';

class Tooblar extends StatelessWidget {
  final String name, email, password, role;
  const Tooblar({super.key, required this.name, required this.email, required this.password, required this.role});

  String get userName => name;
  String get userEmail => email;
  String get userPassword => password;
  String get userRole => role;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: SizedBox(
              height: 100.0,
              child: DrawerHeader(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/logos/logo-black-nobackground.png',
                      height: 100.0,
                    ),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.black,
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
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('My Account'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(context, MaterialPageRoute(builder: (context) => AccountScreen(name: userName, email: userEmail, password: userPassword, role: userRole)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('My Recycle History'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RecycleHistoryScreen()));
            },
          ),
          // Add more items as needed
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: FractionalOffset.bottomLeft,
                child: TextButton.icon(
                  onPressed: (){
                    Navigator.pop(context); // Close the drawer
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  }, 
                  icon: const Icon(Icons.logout), 
                  label: const Text('Log Out'))
              ),
            ),
          ),
        ],
      ),
    );
  }
}
