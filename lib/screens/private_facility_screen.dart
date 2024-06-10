import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

const int dayStart = 5, dayEnd = 18;

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
  GoogleMapController? mapController;
  Position? currentPosition;
  LatLng? tappedPosition;
  String? _binType;

  String? selectedBinType;
  List<String> binTypes = ['Cardboard', 'Glass', 'Paper', 'Package', 'Textile'];
  final Set<Marker> _markers = {}; // Define _markers here
  String _address = "";
  String _name = "";

  @override
  void initState() {
    super.initState();
    initializeMap();
  }

  Future<void> initializeMap() async {
    await getCurrentLocation();
    if (mounted && currentPosition != null) {
      setState(() {
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                currentPosition!.latitude,
                currentPosition!.longitude,
              ),
              zoom: 17.0,
            ),
          ),
        );
      });
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error getting location: $e');
    }
  }

  String get name => widget.name;
  String get email => widget.email;
  String get password => widget.password;
  String get role => widget.role;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Private Recycle Facility',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 40, 45, 50),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color.fromARGB(255, 40, 45, 50),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Theme(
            data: ThemeData.dark(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: nameController,
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Bin Type:',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 16,
                    ), // Add space between label and dropdown
                    DropdownButton<String>(
                      value: _binType,
                      onChanged: (String? newValue) {
                        setState(() {
                          _binType = newValue!;
                        });
                      },
                      dropdownColor: const Color.fromARGB(255, 40, 45, 50),
                      style: const TextStyle(
                          color: Colors
                              .white), // Set the color of the dropdown button
                      items: binTypes
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value.isEmpty ? 'Select' : value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text("Mark Location:",
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 10),
                Expanded(
                  child: currentPosition == null
                      ? const Center(child: CircularProgressIndicator())
                      : GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            changeMapMode(controller);
                            if (mounted) {
                              setState(() {
                                mapController = controller;
                              });
                            }
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              currentPosition!.latitude,
                              currentPosition!.longitude,
                            ),
                            zoom: 17.0,
                          ),
                          onTap: (LatLng position) {
                            setState(() {
                              tappedPosition = position;
                            });
                            // Add a marker on the tapped position
                            _addMarker(position);
                          },
                          markers: _markers
                              .toSet(), // Set of markers to display on the map
                        ),
                ),
                const SizedBox(height: 15),

                //Text(binStreet!,
                //    style: const TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Bin Address: ",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(
                        width: 8), // Add some space between label and value
                    Expanded(
                      child: Text(_address,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    saveBinToDB(_binType, _address, _name);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(
                        150, 50), // Adjust the width and height as needed
                  ),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// Method to add a marker on the map
  Future<void> _addMarker(LatLng position) async {
    setState(() {
      _markers.clear(); // Clear existing markers
      _markers.add(
          Marker(markerId: MarkerId(position.toString()), position: position));
    });

    // Perform reverse geocoding to get the address
    await dotenv.load(fileName: ".env");
    String? googleUrl = dotenv.env['GOOGLE_MAPS_URL'];
    String? apiKey = dotenv.env['API_KEY'];
    String lat = position.latitude.toString();
    String lng = position.longitude.toString();
    final response = await http
        .get(Uri.parse('$googleUrl/json?latlng=$lat,$lng&key=$apiKey'));
    if (response.statusCode == 200) {
      try {
        String binName =
            json.decode(response.body)['results'][0]['formatted_address'];
        setState(() {
          _address = binName;
        });
      } catch (e) {
        throw Exception(e.toString());
      }
    }
  }

  void changeMapMode(GoogleMapController mapController) {
    DateTime now = DateTime.now();
    if (now.hour >= dayStart && now.hour <= dayEnd) {
      // 5 am to 6 pm
      getJsonFile("assets/map_styles/day_map.json")
          .then((value) => setMapStyle(value, mapController));
    } else {
      // 6 pm to 5 am
      getJsonFile("assets/map_styles/night_map.json")
          .then((value) => setMapStyle(value, mapController));
    }
  }

  void setMapStyle(String mapStyle, GoogleMapController mapController) {
    mapController.setMapStyle(mapStyle);
  }

  Future<String> getJsonFile(String path) async {
    ByteData byte = await rootBundle.load(path);
    var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
    return utf8.decode(list);
  }

  Future<void> saveBinToDB(
      String? binType, String address, String privateName) async {
    if (binType == null) {
      _showFailureDialog("Bin type is missing");
      return;
    }
    if (address.isEmpty) {
      _showFailureDialog("Bin location is missing");
    }
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    final response = await http.post(
        Uri.parse('$baseUrl/objects?email=$email&password=$password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'type': 'PRIVATE_FACILITY',
          'data': {
            'bin_type': binType.toLowerCase(),
            'name': address,
            'private_name': privateName,
            'location': {
              'coordinates': [
                _markers.first.position.longitude,
                _markers.first.position.latitude
              ]
            }
          }
        }));
    if (response.statusCode == 201) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text(
              'The recycling facility has been created successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Clear all fields
                setState(() {
                  nameController.clear();
                  _binType = null;
                  _address = "";
                  _name = "";
                  _markers.clear();
                  tappedPosition = null;
                  if (mapController != null && currentPosition != null) {
                    mapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(
                            currentPosition!.latitude,
                            currentPosition!.longitude,
                          ),
                          zoom: 17.0,
                        ),
                      ),
                    );
                  }
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showFailureDialog(String errorMsg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Failure'),
          content: Text(errorMsg),
          actions: <Widget>[
            TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
}
