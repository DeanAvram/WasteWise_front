import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:map_app/screens/classification_dialog_screen.dart';

class CameraScreen extends StatefulWidget {
  final String name, email, password, role;
  final List<CameraDescription>? cameras;
  final Position? currentLocation;

  const CameraScreen(
      {Key? key,
      required this.name,
      required this.email,
      required this.password,
      required this.role,
      required this.cameras,
      required this.currentLocation})
      : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  String status = "";
  String classify = "";
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _cameraController =
        CameraController(widget.cameras![0], ResolutionPreset.high);
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void takePicture() async {
    setState(() {
      _isTakingPicture = true;
    });

    final XFile imageFile = await _cameraController.takePicture();

    String? baseUrl = dotenv.env['BASE_URL'];
    String url =
        '$baseUrl/classify?email=${widget.email}&password=${widget.password}';

    final bytes = await imageFile.readAsBytes();

    final response = await http.post(
      Uri.parse(url),
      body: bytes,
      headers: {'Content-Type': 'image/jpeg'},
    );

    setState(() {
      _isTakingPicture = false;
      status = response.statusCode.toString();
      Map<String, dynamic> jsonMap = json.decode(response.body);
      classify = jsonMap['classification'];
      showDialog(
        context: context,
        builder: (context) => ClassificationScreen(
            email: widget.email,
            password: widget.password,
            classification: classify,
            currentLocation: widget.currentLocation),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CameraPreview(_cameraController);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isTakingPicture
                      ? null
                      : () async {
                          try {
                            setState(() {
                              _isTakingPicture = true;
                            });
                            await _initializeControllerFuture;
                            takePicture();
                          } catch (e) {
                            setState(() {
                              _isTakingPicture = false;
                            });
                          }
                        },
                  child: _isTakingPicture
                      ? const CircularProgressIndicator() // Show circular progress indicator while taking picture
                      : const Icon(Icons.camera),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
