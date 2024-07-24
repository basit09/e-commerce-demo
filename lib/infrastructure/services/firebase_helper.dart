import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

// upload image  to storage
  Future<String> uploadImageToStorage(String fileName, Uint8List file) async {
    Reference ref = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static firebaseOptions() {
    if (Platform.isAndroid) {
      return const FirebaseOptions(
          apiKey: 'AIzaSyAm90sotO2XU-ZB24KGkxUgA2zbYF3-YQs',
          appId: '1:130988735620:android:f9bf5ad6774c7ef54d96d1',
          messagingSenderId: '130988735620',
          projectId: 'e-commerce-f02f7',
          storageBucket: 'gs://e-commerce-f02f7.appspot.com');
    } else {
      // if platform is IOS
      return const FirebaseOptions(
          apiKey: 'AIzaSyCJ4ZYTdo3nHtS4iYAfHtGv_pRmBVIoWjI',
          appId: '1:130988735620:ios:1c2b5a22ad65e16a4d96d1',
          messagingSenderId: '130988735620',
          projectId: 'e-commerce-f02f7',
          storageBucket: 'gs://e-commerce-f02f7.appspot.com');
    }
  }
}
