import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:map_app/screens/private_facility_screen.dart';

class MyPrivateFacilitiesScreen extends StatefulWidget {
  final String name, email, password, role;
  const MyPrivateFacilitiesScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.password,
      required this.role});

  @override
  State<MyPrivateFacilitiesScreen> createState() =>
      _MyPrivateFacilitiesScreenState();
}

class _MyPrivateFacilitiesScreenState extends State<MyPrivateFacilitiesScreen> {
  List<dynamic> _dataList = [];
  bool _dataLoaded = false;
  List<String> binTypes = ['Cardboard', 'Glass', 'Paper', 'Package', 'Textile'];

  String get name => widget.name;
  String get email => widget.email;
  String get password => widget.password;
  String get role => widget.role;

  String? _binType; // Default selected period

  @override
  void initState() {
    super.initState();
    //fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _dataLoaded = false; // Set _dataLoaded to false before fetching data
    });

    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    final response = await http.post(
      Uri.parse('$baseUrl/commands?email=$email&password=$password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'type': 'PRIVATE_FACILITIES',
        'data': {'bin_type': _binType!.toLowerCase()}
      }),
    );

    if (response.statusCode == 201) {
      if (mounted) {
        setState(() {
          _dataList = json.decode(response.body);
          _dataLoaded = true; // Set _dataLoaded to true after data is fetched
        });
      }
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 45, 50),
      appBar: AppBar(
        title: const Text('My Private Recycle Facilities',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 40, 45, 50),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 16.0), // Adjust the padding as needed
            child: Row(
              children: [
                const Text(
                  'Select Bin Type:',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(
                    width: 16), // Add space between label and dropdown
                DropdownButton<String>(
                  value: _binType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _binType = newValue!;
                      fetchData(); // Fetch data again when period changes
                    });
                  },
                  dropdownColor: const Color.fromARGB(255, 40, 45, 50),
                  style: const TextStyle(
                      color:
                          Colors.white), // Set the color of the dropdown button
                  items: binTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: !_dataLoaded
                ? const Center(
                    //child: CircularProgressIndicator()
                    //child: Text("Please choose bin type",
                    //    style: TextStyle(color: Colors.white, fontSize: 24)))
                    )
                : ListView.builder(
                    itemCount: _dataList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          _dataList[index]['data']['private_name'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          _dataList[index]['data']['name'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PrivateFacilityScreen(
                                  name: name,
                                  email: email,
                                  password: password,
                                  role: role,
                                  facilityData: _dataList[
                                      index], // Pass the facility data
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
