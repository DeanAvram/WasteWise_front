import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RecycleHistoryScreen extends StatefulWidget {
  final String name, email, password, role;
  const RecycleHistoryScreen({super.key, required this.name, required this.email, required this.password, required this.role});


   @override
  State<RecycleHistoryScreen> createState() => _RecycleHistoryScreenState();
}

class _RecycleHistoryScreenState extends State<RecycleHistoryScreen> {
  List<dynamic> _dataList = [];

  String get name => widget.name;
  String get email => widget.email;
  String get password => widget.password;
  String get role => widget.role;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/wastewise/commands?email=$email&password=$password'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'type': 'HISTORY',
        'data':{
          'period': 'WEEK'
        }
      }),
    );
    
    if (response.statusCode == 201){
      setState(() {
        _dataList = json.decode(response.body);
      });
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: _dataList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _dataList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _dataList[index]['data']['prediction'],
                    style: const TextStyle(fontSize: 18.0,
                                          fontWeight: FontWeight.bold)
                   ),
                  subtitle: Text(_dataList[index]['data']['prediction_time'])
                );
              },
            ),
    );
  }
}
