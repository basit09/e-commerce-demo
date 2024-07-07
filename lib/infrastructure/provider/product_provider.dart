import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_task/infrastructure/models/product_model_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  List<ProductModel>? get productList => _productList;
  List<ProductModel>? _productList;

  List<int>? get favProductList => _favProductList;
  List<int>? _favProductList;

  setFavouriteList(List<int> value){
    _favProductList = value;
  }

  addFavourite(int favProductID) async {
    User? user = _auth.currentUser;
    try {
      if (user != null) {
        _favProductList ??= [];
        if (!_favProductList!.contains(favProductID)) {
          _favProductList?.add(favProductID);
          print(_favProductList?.first);
          notifyListeners();
        }else{
          _favProductList?.remove(favProductID);
          notifyListeners();
        }
      }
      await _firestore
          .collection("users")
          .doc(user?.uid)
          .update({'favourite_products_list': _favProductList});
      notifyListeners();
      print('updated favourite list : ${_favProductList?.first}');
    } catch (e) {
      print(e.toString());
    }
  }

  // Future<List<int>> getFavouriteList() async {
  //   final DatabaseReference ref = _database.ref().child('users').child('favourite_products_list');
  //   final DataSnapshot snapshot = await ref.get();
  //   final List<int> intList = snapshot.value?.map((e) => e as int).toList();
  //   return intList;
  // }

  Future<List<int>> getFavouriteList() async {
    List<int> favouriteProducts = [];
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      if (userDoc.exists) {
        List<dynamic> favouriteProductsDynamic =
            userDoc['favourite_products_list'];
        favouriteProducts =  favouriteProductsDynamic.cast<int>();
        setFavouriteList(favouriteProductsDynamic.cast<int>());
        notifyListeners();
      }
    } catch (e) {
      print('Error Fetching favourite data');
    }
    return favouriteProducts;
  }

  Future getProductDataList(
    BuildContext context,
  ) async {
    String url = "https://api.escuelajs.co/api/v1/products";
    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        final List body = json.decode(response.body);
        _productList = body.map((e) => ProductModel.fromJson(e)).toList();
        return _productList;
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Server not found')));
      } else {
        throw Exception('Cant fetch data from api');
      }
    } catch (e) {
      print(e.toString());
    }
  }

}