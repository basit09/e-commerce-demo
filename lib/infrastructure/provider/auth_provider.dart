import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  isUserLoggedIn() async {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _isLoggedIn = true;
      } else {
        _isLoggedIn = false;
      }
    });
  }

  getName() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get();

    nameController.text = userDoc['name'].toString();
    emailController.text = userDoc['email'].toString();
    notifyListeners();
  }

  updateNameAndEmail(String? name, String? email) async {
    if (name != null) {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser?.uid)
          .update({'name': nameController.text});
      nameController.text = name;
    }
    if (email != null) {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser?.uid)
          .update({'name': nameController.text});
      emailController.text = email;
    }


    notifyListeners();
  }

  /// SignUp User
  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        // register user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // add user to your  firestore database
        print(cred.user!.uid);
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
        });

        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // logIn user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // for signout

  signOut() async {
    await _auth.signOut();
  }
}
