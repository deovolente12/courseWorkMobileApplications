import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coursework_jongsungkim/models/user_model.dart';

class AuthController {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<UserModel?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'created_at': FieldValue.serverTimestamp(),
          });
        }
        return UserModel(uid: user.uid, email: user.email ?? '');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw 'The email address is badly formatted.';
        case 'user-not-found':
          throw 'No user found with this email. Please sign up.';
        case 'wrong-password':
          throw 'Incorrect password. Please try again.';
        case 'network-request-failed':
          throw 'Network error. Please check your internet connection.';
        default:
          throw 'Login failed: ${e.message}';
      }
    } catch (e) {
      throw 'An unexpected error occurred. Please try again later.';
    }
    return null;
  }

  Future<UserModel?> signup(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'created_at': FieldValue.serverTimestamp(),
        });
        return UserModel(uid: user.uid, email: user.email ?? '');
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw 'The email address is already in use by another account.';
        case 'invalid-email':
          throw 'The email address is badly formatted.';
        case 'weak-password':
          throw 'The password is too weak.';
        default:
          throw 'Signup failed: ${e.message}';
      }
    } catch (e) {
      throw 'An unexpected error occurred. Please try again later.';
    }
    return null;
  }
}