// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthenticationNotifier extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Future<void> signIn(String email, String password) async {

        try {
          UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email:email,
              password: password);
              print(User);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
          print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email,
              password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
  
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    print("Log out successfull");
     
  }

  
}