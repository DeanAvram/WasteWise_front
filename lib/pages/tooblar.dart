import 'package:flutter/material.dart';
import 'package:map_app/pages/account_screen.dart';


class Tooblar extends StatelessWidget {
  const Tooblar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(
          height: 65.0,
          child: DrawerHeader(
            padding: EdgeInsets.only(top: 15, left: 10), // Adjust the padding as needed
            
            decoration: BoxDecoration(
              color: Colors.blue
            ),
            child: Text(
              'Toolbar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
        ListTile(
          title: const Text('My Account'),
          onTap: () {
            Navigator.pop(context); // Close the drawer
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountScreen()));
          },
        ),
        ListTile(
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