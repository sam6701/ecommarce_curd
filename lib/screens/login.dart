import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_api/screens/home_screen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
//?email=$email
/*Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ECommercePage(),
            ),
          );*/
  // Function to handle login
  Future<void> login() async {
    // Retrieve user input from text controllers
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Make HTTP request to fetch user data by email
    final response = await http.get(
      Uri.parse('https://fakestoreapi.com/users'),
    );

    if (response.statusCode == 200) {
      // Parse the response JSON
      List<dynamic> users = jsonDecode(response.body);
      if (users.isNotEmpty) {
        // If user with given email is found, check password
        //Map<String, dynamic> user = users.first;
        var user = users.firstWhere((user) => user['email'] == email,
            orElse: () => null);
        if (user != null) {
          String storedPassword = user['password'];
          if (password == storedPassword) {
            // Password matches, navigate to home screen or dashboard
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ECommercePage(),
              ),
            );
          } else {
            // Password does not match, show error message
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Login Failed'),
                  content: Text('Invalid password. Please try again.'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else {
          // User with given email not found, show error message
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Login Failed'),
                content: Text('Email not found. Please register.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // HTTP request failed, show error message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to fetch user data. Please try again.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the login function when the login button is pressed
                login();
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
