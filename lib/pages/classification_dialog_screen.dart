import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ClassificationScreen extends StatefulWidget {
  final String email, classification, password;
  final Position? currentLocation;

  const ClassificationScreen(
      {Key? key,
      required this.email,
      required this.password,
      required this.classification,
      required this.currentLocation})
      : super(key: key);

  set chosenClassification(String chosenClassification) {}

  @override
  State<ClassificationScreen> createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  String get email => widget.email;
  String get password => widget.password;
  Position? get currentLocation => widget.currentLocation;
  String chosenClassification = '';

  @override
  void initState() {
    super.initState();
    chosenClassification = widget.classification;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Classification Result"),
      content: Text(chosenClassification),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            directToRecycleBin(chosenClassification);
            Navigator.of(context).pop();
          },
          child: const Text("OK, Direct me"),
        ),
        TextButton(
          onPressed: () {
            _showOptionsBottomSheet();
          },
          child: const Text("Change classification"),
        )
      ],
    );
  }

  void _showOptionsBottomSheet() {
    List<String> options = [
      'cardboard',
      'glass',
      'metal',
      'paper',
      'plastic',
      'trash'
    ]; // Add your list of options here

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.15,
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(options[index]),
                onTap: () {
                  //directToRecycleBin(options[index]);
                  Navigator.of(context).pop(); // Close the bottom sheet
                  setState(() {
                    chosenClassification = options[index];
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  Future<void> directToRecycleBin(String classification) async {
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    Response response = await http.post(
      Uri.parse('$baseUrl/commands?email=$email&password=$password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'type': 'DIRECT',
        'data': {
          'bin_type': classification,
          'location': {
            'lat': currentLocation?.latitude,
            'lng': currentLocation?.longitude
          }
        }
      }),
    );
    print(response.body);
  }
}
