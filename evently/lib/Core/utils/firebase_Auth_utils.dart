import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class FirebaseAuthUtils {

    static Future<bool>  createUserWithEmailAndPassword({
      required BuildContext context,
      required String email,
      required String password,}) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return Future.value(true);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      const SnackBar(
        content: Text('The password provided is too weak.'),
        duration: Duration(seconds: 1),
      );
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The account already exists for that email.'),
                        
                            duration: Duration(seconds: 2),
                          ),
                        );
    }
  } catch (e) {
    print('Error creating user: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('An error occurred while creating the user.'),
        duration: Duration(seconds: 1),
      ),
    );

  }
  return Future.value(false); // Ensure a return value in all cases
}
    static getCurrentUserid() {
      return FirebaseAuth.instance.currentUser?.uid;
    }

    static Future<bool> signInWithEmailAndPassword({
      required String email,
      required String password,
    }) async {
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return Future.value(true);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          const SnackBar(
            content: Text('No user found for that email.'),
            duration: Duration(seconds: 1),
          );
        } else if (e.code == 'invalid-credential') {
          print('Wrong password provided for that user.');
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
            duration: Duration(seconds: 1),
          );
        }
      } catch (e) {
        print('Error signing in: $e');
        const SnackBar(
          content: Text('An error occurred while signing in.'),
          duration: Duration(seconds: 1),
        );
      }
      return Future.value(false); 
    }
  //--------------------

  static Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return Future.value(false);
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      return Future.value(true);
    } catch (e) {
      print('Error signing in with Google: $e');
      return Future.value(false);
    }
  }
  //--------------------
  

  static Future<bool> signOut() async {
    
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    return Future.value(true);
  }

  static  getUsername() {
    if (FirebaseAuth.instance.currentUser?.displayName == null) {
      return FirebaseAuth.instance.currentUser?.email;
    }
      return FirebaseAuth.instance.currentUser?.displayName;
    }
  static  getEmail() {
      return FirebaseAuth.instance.currentUser?.email;
    }

   static Future<bool> forgetpassword({
  required String email,
  required BuildContext context,
}) async {
  try {
    // Validate email format
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    // Basic email validation
    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Password reset email sent to $email. Please check your inbox.'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
      ),
    );
    
    return true;
  } on FirebaseAuthException catch (e) {
    String message;
    switch (e.code) {
      case 'invalid-email':
        message = 'The email address is not valid.';
        break;
      case 'user-not-found':
        message = 'No user found with this email address.';
        break;
      case 'too-many-requests':
        message = 'Too many requests. Please try again later.';
        break;
      default:
        message = 'An error occurred: ${e.message}';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
    
    return false;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('An unexpected error occurred: $e'),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
      ),
    );
    
    return false;
  }
}

}