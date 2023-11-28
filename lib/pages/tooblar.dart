import 'package:flutter/material.dart';
import 'package:map_app/pages/account_screen.dart';


class Tooblar extends StatelessWidget {
  const Tooblar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
    child: ListView(
      children: [
        Container(
          color: Colors.white,
          child: SizedBox(
            height: 150.0,
            child: 
            DrawerHeader(
              padding: const EdgeInsets.only(top: 5), // Adjust the padding as needed
              child: Column(
                children: [
                  const Text(
                    'Toolbar',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Image.asset(
                    'assets/logos/logo-black-nobackground.png',
                    height: 100.0,
                    )
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('My Recycle History'),
          onTap: () {
            Navigator.pop(context); // Close the drawer
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountScreen()));
          },
        )
        // Add more items as needed
      ],
    ),
  );
  }
}