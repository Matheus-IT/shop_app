import 'package:flutter/material.dart';

import '../models/product_model.dart';
import './dummy_products.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> _products = [...dummyData];

  List<ProductModel> get items => _products;

  void addProduct(Map<String, dynamic> data) {}
}
