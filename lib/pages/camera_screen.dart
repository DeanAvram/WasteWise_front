// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
//import 'dart:io';
//import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  final String name, email, password, role;

  const CameraScreen(
      {Key? key,
      required this.name,
      required this.email,
      required this.password,
      required this.role,
      required this.cameras})
      : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  String status = "";
  String pred = "";

  //final ImagePicker _picker = ImagePicker();

  String get name => widget.name;
  String get email => widget.email;
  String get password => widget.password;
  String get role => widget.role;

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

  /*Future getImageFromDevice() async {
    //choose image from device
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }*/

  void uploadImage() async {
    final XFile imageFile = await _cameraController.takePicture();

    String? baseUrl = dotenv.env['BASE_URL'];
    String url = '$baseUrl/predict?email=$email&password=$password';

    final bytes = await imageFile.readAsBytes();

    final response = await http.post(
      Uri.parse(url),
      body: bytes,
      headers: {'Content-Type': 'image/jpeg'},
    );

    setState(() {
      status = response.statusCode.toString();
      Map<String, dynamic> jsonMap = json.decode(response.body);
      pred = jsonMap['prediction'];
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
                Text("$status  $pred"),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;
                      uploadImage();
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
                  },
                  child: const Icon(Icons.camera),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
