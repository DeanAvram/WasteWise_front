import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_app/pages/Tooblar.dart';
import 'package:camera/camera.dart';
import 'package:map_app/pages/camera_screen.dart';

class MapScreen extends StatefulWidget {
  final String name, email, password, role;
  const MapScreen(
      {super.key,
      required this.name,
      required this.email,
      required this.password,
      required this.role});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Position? currentPosition;

  String get name => widget.name;
  String get email => widget.email;
  String get password => widget.password;
  String get role => widget.role;

  @override
  void initState() {
    super.initState();
    initializeMap();
  }

  Future<void> initializeMap() async {
    await getCurrentLocation();
    if (mounted) {
      setState(() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WasteWise',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      drawer: Tooblar(name: name, email: email, password: password, role: role),
      body: currentPosition != null
          ? Stack(
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
                      currentPosition!.latitude,
                      currentPosition!.longitude,
                    ),
                    zoom: 17.0,
                  ),
                  markers: <Marker>{
                    Marker(
                      markerId: const MarkerId("user_location"),
                      position: LatLng(
                        currentPosition!.latitude,
                        currentPosition!.longitude,
                      ),
                      infoWindow: const InfoWindow(title: "Your Location"),
                    ),
                  },
                ),
                Positioned(
                  bottom: 16,
                  left: MediaQuery.of(context).size.width / 2 - 28,
                  child: FloatingActionButton(
                    onPressed: () async {
                      await availableCameras().then((value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => CameraScreen(
                                  name: name,
                                  email: email,
                                  password: password,
                                  role: role,
                                  cameras: value))));
                    },
                    child: const Icon(Icons.camera_alt_outlined),
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(), // Show a loading indicator
            ),
    );
  }
}

void changeMapMode(GoogleMapController mapController) {
  getJsonFile("assets/map_styles/day_map.json")
      .then((value) => setMapStyle(value, mapController));
}

void setMapStyle(String mapStyle, GoogleMapController mapController) {
  mapController.setMapStyle(mapStyle);
}

Future<String> getJsonFile(String path) async {
  ByteData byte = await rootBundle.load(path);
  var list = byte.buffer.asUint8List(byte.offsetInBytes, byte.lengthInBytes);
  return utf8.decode(list);
}
