import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  void initState() {
    super.initState();
  }


  Future< Map<String, dynamic>> getUserDataTest() async {
    try{
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/wastewise/users/user@gmail.com?email=user@gmail.com&password=Aabcd1234!'), );
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        Map<String, dynamic> jsonMap = json.decode(response.body);
        return jsonMap;
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load data');
    }
    }
    catch(e){
      throw Exception('Failed to load data');
    }
  }

  Future<String> getUserData(String key) async {
    try{
      final response = await http.get(Uri.parse('http://127.0.0.1:5000/wastewise/users/user@gmail.com?email=user@gmail.com&password=Aabcd1234!'), );
      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON
        Map<String, dynamic> jsonMap = json.decode(response.body);
        return jsonMap[key];
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to load data');
    }
    }
    catch(e){
      throw Exception('Failed to load data');
    }
  }

  

  FutureBuilder buildFutureBuilder(String key){
  return FutureBuilder(
            future: getUserData(key),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text(
                  '${snapshot.data}',
                  style: const TextStyle(
                    fontSize: 16
                  ),
                );
              }
            },
          );
}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Name',
            style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
          ),
          buildFutureBuilder('name'),
          const SizedBox(height: 10),
          const Text(
            'Mail',
            style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold),
          ),
          buildFutureBuilder('email')
        ],
      ),
    );
  }
}
