import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItemModel> _cart = {};

  int get itemCount => _cart.length;
  Map<String, CartItemModel> get items => _cart;

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

  void clear() {
    _cart.clear();
    notifyListeners();
  }

  void addItem(ProductModel product) {
    _cart.update(
      product.id,
      (item) => CartItemModel.from(item, newQuantity: item.quantity + 1),
      ifAbsent: () => CartItemModel.fromProduct(product),
    );
    notifyListeners();
  }

  void removeItem(String key) {
    _cart.remove(key);
    notifyListeners();
  }

  void removeSingleItem(String key) {
    if (!_cart.containsKey(key)) {
      return;
    }
    if (_cart[key]!.quantity > 1) {
      _cart.update(
        key,
        (cartItem) => CartItemModel(
          itemId: cartItem.itemId,
          productId: cartItem.productId,
          name: cartItem.name,
          quantity: cartItem.quantity - 1,
          price: cartItem.price,
        ),
      );
      notifyListeners();
    } else {
      removeItem(key);
    }
  }
}
