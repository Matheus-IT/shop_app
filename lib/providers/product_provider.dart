import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  static const apiUrl = 'https://shop-app-bd1d7-default-rtdb.firebaseio.com';

  final List<ProductModel> _products = [];

  List<ProductModel> get items => _products;

  String get _nextProductId => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> loadProduct() async {
    const url = '$apiUrl/product.json';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == HttpStatus.ok) {
      final data = jsonDecode(response.body) as Map;

      _products.clear();

      data.map((key, value) {
        key = key as String;
        value = value as Map;

        _products.add(ProductModel(
          id: key,
          name: value['name'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: value['isFavorite'],
        ));

        return MapEntry(key, value);
      });
      notifyListeners();
    }
  }

  void _addProduct(ProductModel product) async {
    const url = '$apiUrl/product.json';
    final json = {
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite,
    };

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(json),
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      _products.add(
        ProductModel.from(
          product,
          id: body['id'],
        ),
      );
      notifyListeners();
    }
/*
    http.post(
      Uri.parse(
        url,
      ),
      body: jsonEncode(json),
    ).then((response) {
      if (response.statusCode == 200) {
        _products.add(product);
        notifyListeners();
      }
    });
*/
  }

  void _updateProduct(ProductModel product) {
    final index = _products.indexWhere((elem) => elem.id == product.id);
    if (index >= 0) {
      _products.removeAt(index);
      _products.insert(index, product);
      notifyListeners();
    }
  }

  void saveProduct(Map<String, dynamic> data) {
    final hasId = data['id']?.IsNotEmpty == true;
    final product = ProductModel(
      id: hasId ? data['id'] : _nextProductId,
      name: data['name'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['imageUrl'],
    );
    if (hasId) {
      _updateProduct(product);
    } else {
      _addProduct(product);
    }
  }

  void removeProduct(String productId) {
    final index = _products.indexWhere((elem) => elem.id == productId);
    if (index >= 0) {
      _products.removeAt(index);
      notifyListeners();
    }
  }
}
