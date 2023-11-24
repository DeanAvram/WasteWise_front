import 'package:flutter/material.dart';
import 'package:map_app/pages/map_screen.dart';

void main() {
  runApp(const MapApp());
}

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapScreen()
    );
  }
}