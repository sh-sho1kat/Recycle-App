import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return {
        'user': cred.user,
        'error': null,
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email is already registered';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        default:
          errorMessage = 'An error occurred during registration';
      }
      log("Error: ${e.code}");
      return {
        'user': null,
        'error': errorMessage,
      };
    } catch (e) {
      log("Error: $e");
      return {
        'user': null,
        'error': 'An unexpected error occurred',
      };
    }
  }

  Future<Map<String, dynamic>> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return {
        'user': cred.user,
        'error': null,
      };
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        default:
          errorMessage = 'An error occurred during login';
      }
      log("Error: ${e.code}");
      return {
        'user': null,
        'error': errorMessage,
      };
    } catch (e) {
      log("Error: $e");
      return {
        'user': null,
        'error': 'An unexpected error occurred',
      };
    }
  }

  Future<String?> signout() async {
    try {
      await _auth.signOut();
      return null;
    } catch (e) {
      log("Error during signout: $e");
      return 'Error signing out';
    }
  }
}