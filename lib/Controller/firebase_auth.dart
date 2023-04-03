import 'package:chat_app/Utilities/toast.dart';
import 'package:chat_app/View/HomeScreen.dart';
import 'package:chat_app/View/Login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void createAccount(
    BuildContext context, String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCrendetial = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    print("Account created Succesfull");

    userCrendetial.user!.updateDisplayName(name);

    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .set({
          "name": name,
          "email": email,
          "status": "Unavailable",
          "uid": _auth.currentUser!.uid,
        })
        .then((value) => {
              UtilsToast().ShowToast('SignUp Successfully'),
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()))
            })
        .onError((error, stackTrace) {
          return UtilsToast().ShowToast('Error Signup');
        });
  } catch (e) {
    UtilsToast().ShowToast(e.toString());
  }
}

void logIn(BuildContext context, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    print("Login Sucessfull");
    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => {
              userCredential.user!.updateDisplayName(value['name']),
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => HomeScreen())),
              UtilsToast().ShowToast('Log in Successfull')
            })
        .onError((error, stackTrace) {
      return UtilsToast().ShowToast(error.toString());
    });
  } catch (e) {
    UtilsToast().ShowToast(e.toString());
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  } catch (e) {
    UtilsToast().ShowToast(e.toString());
  }
}
