import 'package:flutter/material.dart';

import '../models/product.dart';
import './dummy_products.dart';

class ProductProvider extends ChangeNotifier {
  // final List<Product> _products = List<Product>.from(dummyData);
  final List<Product> _products = [...dummyData];

  List<Product> get products => _products;
}
