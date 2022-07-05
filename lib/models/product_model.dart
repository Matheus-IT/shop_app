import 'package:flutter/material.dart';

class ProductModel extends ChangeNotifier {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite = false;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  bool toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
    return isFavorite;
  }

  @override
  String toString() => 'Product($name)';
}
