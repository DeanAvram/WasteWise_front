import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:map_app/pages/map_screen.dart';
import 'package:map_app/pages/register_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = 'user@gmail.com';
  String password = 'Abcd1234!';
  late bool _isWrongEmail;
  late bool _isWrongPassword;
  //initail values for testing
  late Future<Map<String, dynamic>> userDataFuture;

  @override
  void initState() {
    super.initState();
    _isWrongEmail = false;
    _isWrongPassword = false;
  }

  Future<Response> getUserData(String email, String password) async {
    try {
      await dotenv.load(fileName: ".env");
      String? baseUrl = dotenv.env['BASE_URL'];
      String url =
          '$baseUrl/users/user@gmail.com?email=$email&password=$password';
      return await get(Uri.parse(url));
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 45, 50),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Theme(
              data: ThemeData.dark(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logos/logo-black.png'),
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 22)),
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
                    decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 22)),
                    obscureText: true,
                    initialValue: password,
                  ),
                  const SizedBox(height: 32.0),
                  Visibility(
                      visible: _isWrongEmail,
                      child: const Text(
                        "Wrong Email",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                  Visibility(
                      visible: _isWrongPassword,
                      child: const Text(
                        "Wrong Pasword",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(height: 16.0),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Implement login logic
                          Response response =
                              await getUserData(email, password);
                          if (response.statusCode == 200) {
                            if (mounted) {
                              Map<String, dynamic> data =
                                  json.decode(response.body);

                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapScreen(
                                            name: data['name'],
                                            email: data['email'],
                                            password: password,
                                            role: data['role'],
                                          )));
                            }
                          } else if (response.statusCode == 404) {
                            //trying to log in with email that doesn't exist
                            setState(() {
                              _isWrongEmail = true;
                              _isWrongPassword = false;
                            });
                          } else if (response.statusCode == 401) {
                            //wrong password
                            setState(() {
                              _isWrongEmail = false;
                              _isWrongPassword = true;
                            });
                          }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Don\'t have an account? ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to the Register page
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen()));
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
