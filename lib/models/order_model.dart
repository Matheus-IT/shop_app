import 'cart_item_model.dart';

typedef OrderItemModel = CartItemModel;

class OrderModel {
  final int id;
  final DateTime date;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.date,
    required this.items,
  });

  double get total => items.fold<double>(
        0.00,
        (sum, item) => sum + item.price * item.quantity,
      );
}
