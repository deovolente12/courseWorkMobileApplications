import 'package:flutter/material.dart';
import 'package:coursework_jongsungkim/controllers/auth_controller.dart';
import 'package:coursework_jongsungkim/models/user_model.dart';
import 'package:coursework_jongsungkim/services/connectivity_service.dart';
import 'package:coursework_jongsungkim/screen/homescreen.dart';
import 'package:coursework_jongsungkim/screen/sign_upscreen.dart';



class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for text fields
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Global key for the form
  final _formKey = GlobalKey<FormState>();

  // Login function
  void _login() async {
    // Validate the form before proceeding
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      // Check internet connectivity
      if (!await ConnectivityService.isConnected()) {
        // No internet connection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No internet connection. Please check your network settings.")),
        );
        return; // Exit the function
      }

      // Attempt to log in using the AuthController
      AuthController.login(email, password).then((user) {
        if (user != null) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => NeurotolgeHomePage()),
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Associating the form key with the Form widget
          child: Column(
            children: [
              // Email Field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }

                  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              // Password Field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),
              // Login Button
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 16.0),
              // Sign Up Redirect
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignupScreen()),
                  );
                },
                child: Text('Don’t have an account? Sign up here'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}