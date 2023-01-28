

import 'package:demo_app/screens/home_screen.dart';
import 'package:demo_app/services/firebaseFunctions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


// import 'package:flutterapp/services/functions/firebaseFunctions.dart';
// int res=0;
class AuthServices {
  static signupUser(
      String email,
      String password,
      String name,
      PhoneAuthCredential mobile,
      // String college,
      // String year,
      BuildContext context) async {
    try {
      
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
      await FirebaseAuth.instance.currentUser!.updateEmail(email);
      // await FirebaseAuth.instance.currentUser!.updatePhoneNumber(mobile);
      // await FirebaseAuth.instance.currentUser!.update(mobile);

      //await FirestoreServices.saveUser(name, email, userCredential.user!.uid);
      
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Registration Successful')));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: ((context) => Home())));
      
      // res=1;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password Provided is too weak')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Email Provided already Exists')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  static signinUser(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('You are Logged in')));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: ((context) => Home())));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user Found with this Email')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Password did not match')));
      }
    }
  }
}
