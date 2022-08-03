import 'package:shop_app/models/product_model.dart';

class CartItemModel {
  final String itemId;
  final String productId;
  final String name;
  final int quantity;
  final double price;

  static String _nextId() => DateTime.now().millisecondsSinceEpoch.toString();

  CartItemModel({
    required this.itemId,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
  });

  CartItemModel.from(CartItemModel item, {int newQuantity = 1})
      : itemId = item.itemId,
        productId = item.productId,
        name = item.name,
        price = item.price,
        quantity = newQuantity;

  factory CartItemModel.fromProduct(ProductModel product, {int quantity = 1}) {
    return CartItemModel(
      itemId: _nextId(),
      productId: product.id,
      name: product.name,
      quantity: quantity,
      price: product.price,
    );
  }

  double get total => quantity * price;
}
