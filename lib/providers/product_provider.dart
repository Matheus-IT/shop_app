import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../exceptions/api_exception.dart';
import '../models/product_model.dart';
import 'auth_provider.dart';

class ProductProvider extends ChangeNotifier {
  static const apiUrl = 'https://shop-app-bd1d7-default-rtdb.firebaseio.com';
  static const productCollection = 'product';
  static const userFavoriteCollection = 'userFavorite';

  final String _token;
  final String _uid;
  final List<ProductModel> _products;

  ProductProvider({
    AuthProvider? auth,
    List<ProductModel>? products,
  })  : _token = (auth != null) ? auth.token ?? '' : '',
        _uid = (auth != null) ? auth.uid ?? '' : '',
        _products = (products != null) ? [...products] : [];

  List<ProductModel> get items => _products;

  Uri _apiUri(String collection, [String? attr]) {
    attr = (attr != null) ? '/$attr' : '';
    return Uri.parse('$apiUrl/$collection$attr.json?auth=$_token');
  }

  Future<void> loadProducts() async {
    final userFavorites = <String, dynamic>{};

    final favoriteResponse = await http.get(
      _apiUri(userFavoriteCollection, _uid),
    );
    if (favoriteResponse.statusCode == HttpStatus.ok) {
      if (favoriteResponse.body != 'null') {
        userFavorites.addAll(jsonDecode(favoriteResponse.body));
      }
    }

    final productResponse = await http.get(
      _apiUri(productCollection),
    );

    if (productResponse.statusCode == HttpStatus.ok) {
      final data = jsonDecode(productResponse.body) as Map<String, dynamic>;

      _products.clear();

      data.forEach((key, value) {
        final isFavorite = userFavorites.containsKey(key);
        _products.add(
          ProductModel(
            id: key,
            name: value['name'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: isFavorite,
          ),
        );
      });

      notifyListeners();
    }
  }

  Future<void> _addProduct(ProductModel product) async {
    final json = {
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
    };

    final response = await http.post(
      _apiUri(productCollection),
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
  }

  Future<void> _updateProduct(ProductModel product) async {
    final index = _products.indexWhere((elem) => elem.id == product.id);
    if (index < 0) {
      return;
    }
    final productData = {
      'name': product.name,
      'description': product.description,
      'price': product.price,
      'imageUrl': product.imageUrl,
    };
    final response = await http.patch(
      _apiUri(productCollection, product.id),
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
      _apiUri(productCollection, productId),
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
    final attr = '$_uid/${product.id}';

    http.Response response;

    if (favoriteState) {
      response = await http.put(
        _apiUri(userFavoriteCollection, attr),
        body: jsonEncode(favoriteState),
      );
    } else {
      response = await http.delete(
        _apiUri(userFavoriteCollection, attr),
      );
    }
    if (response.statusCode >= 400) {
      product.isFavorite = !favoriteState;

      throw ApiException(
        statusCode: response.statusCode,
        message: 'Error updating product favorite state',
      );
    }
  }
}
