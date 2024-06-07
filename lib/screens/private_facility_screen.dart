import 'package:flutter/material.dart';

class PrivateFacilityScreen extends StatefulWidget {
  final String name, email, password, role;

  const PrivateFacilityScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.password,
      required this.role});

  @override
  State<PrivateFacilityScreen> createState() => _PrivateFacilityState();
}

class _PrivateFacilityState extends State<PrivateFacilityScreen> {
  TextEditingController nameController = TextEditingController();

  String get name => widget.name;
  String get email => widget.email;
  String get password => widget.password;
  String get role => widget.role;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Recycle Facility',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 40, 45, 50),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 45, 50),
      body: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle button press here
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
