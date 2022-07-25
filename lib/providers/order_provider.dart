import 'package:flutter/material.dart';

import '../models/order_model.dart';
import 'cart_provider.dart';

class OrderProvider extends ChangeNotifier {
  static int _lastId = 1000;

  final List<OrderModel> _orders = [];

  int get itemsCount => _orders.length;
  List<OrderModel> get items => _orders;

  static int _nextId() => ++_lastId;

  void addOrder(CartProvider cart) {
    _orders.insert(
      0,
      OrderModel(
        id: OrderProvider._nextId(),
        date: DateTime.now(),
        items: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}
