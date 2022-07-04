import 'dart:math';

import 'package:shop_app/models/product.dart';

class CartItem {
  final int itemId;
  final int productId;
  final String name;
  final int quantity;
  final double price;

  static int _nextId() => Random().nextInt(1000) + 1000;

  CartItem({
    required this.itemId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  CartItem.from(CartItem item, {int newQuantity = 1})
      : itemId = item.itemId,
        productId = item.productId,
        name = item.name,
        price = item.price,
        quantity = newQuantity;

  factory CartItem.fromProduct(Product product, {int quantity = 1}) {
    return CartItem(
      itemId: _nextId(),
      productId: product.id,
      name: product.name,
      quantity: quantity,
      price: product.price,
    );
  }
}
