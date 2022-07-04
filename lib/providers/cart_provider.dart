import 'package:flutter/material.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _cart = {};

  int get itemCount => _cart.length;

  int get quantityCount {
    int total = 0;
    _cart.forEach((_, item) {
      total += item.quantity;
    });
    return total;
  }

  double get total {
    double sum = 0.0;
    _cart.forEach((_, item) => sum += item.quantity * item.price);
    return sum;
  }

  void addItem(Product product) {
    _cart.update(
      product.id,
      (item) => CartItem.from(item, newQuantity: item.quantity + 1),
      ifAbsent: () => CartItem.fromProduct(product),
    );
    debugPrint('addItem(${product.name})');
    /*
    if (_cart.containsKey(product.id)) {
      _cart.update(product.id,
          (item) => CartItem.from(item, newQuantity: item.quantity + 1));
    } else {
      _cart.putIfAbsent(product.id, () => CartItem.fromProduct(product));
    }
    */
    notifyListeners();
  }
}
