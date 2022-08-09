import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/api_exception.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  static const apiUrl =
      'https://shop-app-bd1d7-default-rtdb.firebaseio.com/product';

  final List<ProductModel> _products = [];

  List<ProductModel> get items => _products;

  Future<void> loadProducts() async {
    const url = '$apiUrl.json';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == HttpStatus.ok) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      _products.clear();

      data.forEach((key, value) {
        _products.add(
          ProductModel(
            id: key,
            name: value['name'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: value['isFavorite'],
          ),
        );
      });

      notifyListeners();
    }
  }

  Future<void> _addProduct(ProductModel product) async {
    const url = '$apiUrl.json';
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

  Future<void> _updateProduct(ProductModel product) async {
    final index = _products.indexWhere((elem) => elem.id == product.id);
    if (index < 0) {
      return;
    }
    final url = '$apiUrl/${product.id}.json';
    final productData = {
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
    };
    final response = await http.patch(
      Uri.parse(url),
      body: jsonEncode(productData),
    );
    if (response.statusCode == HttpStatus.ok) {
      _products[index] = product;
      /*
      _products.removeAt(index);
      _products.insert(index, product);
      */
      notifyListeners();
    }
  }

  Future<void> removeProduct(String productId) async {
    final index = _products.indexWhere((elem) => elem.id == productId);
    if (index < 0) {
      return;
    }

    final product = _products[index];
    _products.removeAt(index);
    notifyListeners();

    final response = await http.delete(
      Uri.parse('$apiUrl/$productId.json'),
    );
    if (response.statusCode >= 400) {
      _products.insert(index, product);
      notifyListeners();

      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error removing product',
      );
    }
  }

  Future<void> saveProduct(Map<String, dynamic> data) {
    final product = ProductModel(
      id: data['id'] ?? '',
      name: data['name'],
      description: data['description'],
      price: data['price'],
      imageUrl: data['imageUrl'],
    );
    if (data['id'] != null) {
      return _updateProduct(product);
    } else {
      return _addProduct(product);
    }
  }

  Future<void> toogleProductFavoriteState(ProductModel product) async {
    final favoriteState = product.toggleFavorite();

    final response = await http.patch(
      Uri.parse('$apiUrl/${product.id}.json'),
      body: jsonEncode({
        'isFavorite': favoriteState,
      }),
    );
    if (response.statusCode >= 400) {
      product.isFavorite = !favoriteState;

      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error updating product favorite state',
      );
    }
  }
}
