// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:map_app/pages/map_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String email = 'user@gmail.com';
  String password = 'Aabcd1234!';
  bool isWrongEmail = false;
  bool isWrongPassword = false;
  //initail values for testing
  late Future<Map<String, dynamic>> userDataFuture;
  
  @override
  void initState() {
    super.initState();
  }

  Future<int> getUserData(String email, String password) async {
    try{
      String url = 'http://127.0.0.1:5000/wastewise/users/user@gmail.com?email=$email&password=$password';
      final response = await get(Uri.parse(url));
      return response.statusCode;
      //print(response.body);
      //return response.statusCode;
    }
    catch(e){
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logos/logo-black.png'
              ),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                initialValue: email,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                initialValue: password,
              ),
              const SizedBox(height: 32.0),
              Visibility(
                visible: isWrongEmail,
                child: const Text(
                  "Wrong Email",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),
              Visibility(
                visible: isWrongPassword,
                child: const Text(
                  "Wrong Pasword",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                )
              ),  
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  // Implement login logic 
                  int statusCode = await getUserData(email, password);
                  if (statusCode == 200){
                      if (mounted){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const MapScreen()));
                      }    
                  }
                  else if (statusCode == 404){
                    //trying to log in with email that doesn't exist
                    setState(() {
                      isWrongEmail = true;
                      isWrongPassword = false;
                    });
                  }
                  else if (statusCode == 401){
                    //wrong password
                    setState(() {
                      isWrongEmail = false;
                      isWrongPassword = true;
                    });
                  }
                  
                  //print('Email: $email');
                  //print('Password: $password');
                },
                child: const Text('Login'),
              ),
              
            ],
          ),
        ),
      ),
      
    );
  }
}