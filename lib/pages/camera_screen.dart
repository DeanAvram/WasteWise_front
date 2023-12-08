// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:map_app/pages/image_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';



class CameraScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const CameraScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  File? _image;
  final ImagePicker _picker = ImagePicker();

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

  Future getImage() async {
    //choose image from device
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(image!.path);
    });
  }

  /*void uploadImage(String imagePath) async {
    try{
      String email = 'user@gmail.com';
      String password = 'Aabcd1234!';
      Uri url = Uri.parse('${dotenv.env['BASE_URL']}/predict?email=$email&password=$password');
      var request = http.MultipartRequest("POST", url);
      Uri path = Uri.parse(imagePath);
      File f = await toFile
      print("fgg");
      request.files.add(http.MultipartFile.fromBytes('file', await File.fromUri(path).readAsBytes(), contentType: MediaType('image', 'jpeg')));
      request.send().then((response) {
        if (response.statusCode == 200) print("Uploaded!");
      });
    }catch(e){
      print(e);
    }
}*/
  


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
                  onPressed: ()async{
                    try {
                      // Ensure that the camera is initialized.
                        await _initializeControllerFuture;

                        // Attempt to take a picture and then get the location
                        // where the image file is saved.
                        final image = await _cameraController.takePicture();
                        print(image.path);
                        if (mounted){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ImageScreen(imagePath: image.path)));
                        }  
                        //uploadImage(image.path);
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
