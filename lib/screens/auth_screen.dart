import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  Future<void> _submitAuthForm({
    required BuildContext ctx,
    required String email,
    required String username,
    required String password,
    required bool isLogin,
  }) async {
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
    } on FirebaseAuthException catch (e) {
      var message = 'An error occurred, please check your credentials!';

      if (e.code == 'invalid-email') {
        message = 'Please enter a valid email address.';
      } else if (e.code == 'user-disabled') {
        message = 'This account has been disabled.';
      } else if (e.code == 'user-not-found') {
        message = 'User not found, please verify your email address.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password!';
      } else if (e.code == 'email-already-in-use') {
        message = 'This email is already in use.';
      } else if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        onSubmit: _submitAuthForm,
        isLoading: _isLoading,
      ),
    );
  }
}
