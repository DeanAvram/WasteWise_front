// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:map_app/pages/login_screen.dart';
import 'package:http/http.dart' as http;


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  late bool _isSuccessfullyRegistered;
  late bool _isErrorInData;
  late bool _isPasswordVisible;
  late bool _isFieldMissing;
  late String _errMsg;
  

  @override
  void initState() {
    super.initState();
    _isSuccessfullyRegistered = false;
    _isErrorInData = false;
    _isPasswordVisible = false;
    _isFieldMissing = false;
    _errMsg = '';
  }

  Future<void> registerUser() async {
    const String url = 'http://127.0.0.1:5000/wastewise/users'; // Replace with your actual API endpoint

    Map<String, dynamic> data = {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
      'role': 'USER'
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201){
        //user created
        //Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _isSuccessfullyRegistered = false;
        });
        
      }
      else if (response.statusCode == 400){
        //bad request
        Map<String, dynamic> err = json.decode(response.body);
        String msg = err['message'];
        setState(() {
          _isErrorInData = true;
          _errMsg = msg;
        });
      }
      
    } catch (error) {
      print('Error during registration: $error');
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name *')
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email *')
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password *',
                suffixIcon: IconButton(
                    icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark, 
                      ),
                      onPressed: (){
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                  ),
                ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty){
                    setState(() {
                       _isFieldMissing = true;
                      if (nameController.text.isEmpty){
                        _errMsg = 'Name is missing';
                      }
                      else if (emailController.text.isEmpty){
                        _errMsg = 'Email is missing';
                      }
                      else if (passwordController.text.isEmpty){
                        _errMsg = 'Password is missing';
                      }
                    });
                  }
                  else{
                    setState(() {
                      _isFieldMissing = false;
                    });
                    registerUser();
                  }
                },
                child: const Text('Register',
                              style: TextStyle(
                                      color: Colors.blue
                                    )
                          ),
                        ),
              const SizedBox(height: 16.0),
              Visibility(
                visible: _isSuccessfullyRegistered,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                  const Text(
                    "Successfully registered. Go to",
                    style: TextStyle(fontSize: 16)
                  ),
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text("Login", style: TextStyle(fontSize: 16.0))
                    )
                  ]
                ),
              ),
              Visibility(
                //error message
                visible: _isErrorInData || _isFieldMissing,
                child: Text(
                    _errMsg,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold
                      )
                  )
              )
              ],
            ),
            Row(
              children: [
                const Text('Alreday have an account? Go to'),
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    child: const Text("Login")
                    )
              ],
            )
          ],
        ),
      ),
    );
  }
}
