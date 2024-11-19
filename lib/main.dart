import 'package:flutter/material.dart';
import 'package:coursework_jongsungkim/screen/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyB64tN01KdRnHNhJMbOYACSeQDfiBWBP4U",
  authDomain: "translationapplication-e1c30.firebaseapp.com",
  projectId: "translationapplication-e1c30",
  storageBucket: "translationapplication-e1c30.appspot.com",
  messagingSenderId: "22415773245", // Replace with the correct value.
  appId: "1:22415773245:android:24abf48008a5e6cb9f2454",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: firebaseOptions,
    );
    runApp(NeurotolgeApp());
  } catch (e) {
    print("Firebase Initialization Error: $e");
  }
}

class NeurotolgeApp extends StatelessWidget {
  const NeurotolgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neurotolge Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}