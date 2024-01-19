import 'dart:convert';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_app/pages/Tooblar.dart';
import 'package:camera/camera.dart';
import 'package:map_app/pages/camera_screen.dart';
import 'package:http/http.dart' as http;

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

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    initializeMap();
    //addOtherLocationMarkers();
    getAllPlaces();
    //print(markers);
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
        addCurrentUserLocationMarker(currentPosition);
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error getting location: $e');
    }
  }

  // Function to add markers for additional locations
  void addOtherLocationMarkers() {
    // Add as many markers as needed with specific locations
    Marker otherLocation1 = Marker(
      markerId: const MarkerId("other_location_1"),
      position: const LatLng(37.775, -122.418),
      infoWindow: const InfoWindow(title: "Other Location 1"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );

    Marker otherLocation2 = Marker(
      markerId: const MarkerId("other_location_2"),
      position: const LatLng(37.776, -122.42),
      infoWindow: const InfoWindow(title: "Other Location 2"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );

    // Add other location markers to the list
    markers.addAll([otherLocation1, otherLocation2]);
  }

  void getAllPlaces() async {
    await dotenv.load(fileName: ".env");
    String? baseUrl = dotenv.env['BASE_URL'];
    final response = await http.post(
      Uri.parse('$baseUrl/commands?email=$email&password=$password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'type': 'PLACES',
        'data': {
          'radius': 1000000,
          'location': {'lat': 0, 'lng': 0}
        }
      }),
    );
    if (response.statusCode == 201) {
      List<Map<String, dynamic>> jsonList = [];
      jsonList = List<Map<String, dynamic>>.from(json.decode(response.body));
      for (var item in jsonList) {
        double lng = item['data']['location']['coordinates'][0];
        double lat = item['data']['location']['coordinates'][1];
        String name = item['data']['name'];
        //const String name = 'garbage';
        Marker location = Marker(
          markerId: MarkerId(name),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
        markers.add(location);
      }
    }
    //print(response.body);
  }
  /*Future<ByteData?> createIcon(IconData icon) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final iconStr = String.fromCharCode(icon.codePoint);

    textPainter.text = TextSpan(
        text: iconStr,
        style: TextStyle(
            letterSpacing: 0.0, fontSize: 40.0, fontFamily: icon.fontFamily));
    textPainter.layout();
    textPainter.paint(canvas, const Offset(0.0, 0.0));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(48, 48);
    final bytes = await image.toByteData(format: ImageByteFormat.png);

    return bytes;
  }*/

  void addCurrentUserLocationMarker(Position? p) async {
    //ByteData? bytes = await createIcon(Icons.my_location);
    Marker userLocationMarker = Marker(
        markerId: const MarkerId("user_location"),
        position: LatLng(
          p!.latitude,
          p.longitude,
        ),
        infoWindow: const InfoWindow(title: "Your Location"),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(48, 48)),
            'assets/icons/location.png')

        //icon: BitmapDescriptor.fromBytes(
        //   bytes!.buffer.asUint8List()) // Customize as needed
        );
    markers.add(userLocationMarker);
    // Add the user location marker to the list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WasteWise',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 40, 45, 50),
        iconTheme: const IconThemeData(color: Colors.white),
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
                  markers: Set<Marker>.of(markers), // Set markers on the map
                  /*markers: <Marker>{
                    Marker(
                      markerId: const MarkerId("user_location"),
                      position: LatLng(
                        currentPosition!.latitude,
                        currentPosition!.longitude,
                      ),
                      infoWindow: const InfoWindow(title: "Your Location"),
                    ),
                  },*/
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
              child: CircularProgressIndicator(),
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
