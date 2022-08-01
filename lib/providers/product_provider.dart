import 'package:flutter/material.dart';

import '../models/product_model.dart';
import './dummy_products.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _products = [...dummyData];

  List<ProductModel> get items => _products;

  int get maxProductId => _products.fold<int>(
        0,
        (maxId, product) => product.id > maxId ? product.id : maxId,
      );

  void _addProduct(ProductModel product) {
    _products.add(product);
    notifyListeners();
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
    final hasId = (data['id'] ?? 0) > 0;
    final product = ProductModel(
      id: hasId ? data['id'] : maxProductId + 1,
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

  void removeProduct(int productId) {
    final index = _products.indexWhere((elem) => elem.id == productId);
    if (index >= 0) {
      _products.removeAt(index);
      notifyListeners();
    }
  }
}
