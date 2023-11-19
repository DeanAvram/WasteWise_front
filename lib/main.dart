import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_app/account_screen.dart';

void main() {
  print("xx");
  runApp(const MapApp());
}

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Position? currentPosition; // To store the user's current position

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best ,
      );
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map App'),
      ),
      drawer: buildDrawer(),
      body: Stack(
        children: [
          GoogleMap(
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
                currentPosition?.latitude ?? 37.7749,
                currentPosition?.longitude ?? -122.4194,
              ), // Use the current position or fallback to San Francisco, CA
              zoom: 17.0,
            ),
            markers: <Marker>{
                Marker(
                  markerId: const MarkerId("user_location"),
                  position: LatLng(
                    currentPosition?.latitude ?? 37.7749,
                    currentPosition?.longitude ?? -122.4194,
                  ),
                  infoWindow: const InfoWindow(title: "Your Location"),
                ),
              },
          ),
          Positioned(
            bottom: 16,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: FloatingActionButton(
              onPressed: () {
                getCurrentLocation();
                mapController?.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        currentPosition?.latitude ?? 37.7749,
                        currentPosition?.longitude ?? -122.4194,
                      ),
                      zoom: 17.0,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.location_searching),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawer() {
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

void changeMapMode(GoogleMapController mapController) {
    getJsonFile("assets/map_style.json")
        .then((value) => setMapStyle(value, mapController));
}

void setMapStyle(String mapStyle, GoogleMapController mapController) {
    mapController.setMapStyle(mapStyle);
}

Future<String> getJsonFile(String path) async {
    ByteData byte = await rootBundle.load(path);
    var list = byte.buffer.asUint8List(byte.offsetInBytes,byte.lengthInBytes);
    return utf8.decode(list);
  }