import 'package:flutter/material.dart';

class ProductModel extends ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  factory ProductModel.from(
    ProductModel product, {
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? product.id,
      name: name ?? product.name,
      description: description ?? product.description,
      price: price ?? product.price,
      imageUrl: imageUrl ?? product.imageUrl,
      isFavorite: isFavorite ?? product.isFavorite,
    );
  }

  bool toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
    return isFavorite;
  }

  @override
  String toString() => 'Product($name)';
}
