import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';

class CartTotalCard extends StatelessWidget {
  const CartTotalCard({
    Key? key,
  }) : super(key: key);

  void _addOrder(BuildContext context, CartProvider cart) {
    final orders = Provider.of<OrderProvider>(context, listen: false);
    orders.addOrder(cart);
    cart.clear();

    Navigator.of(context).pushReplacementNamed(AppRoutes.orders);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        top: 10.0,
        bottom: 15.0,
        left: 15.0,
        right: 15.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total',
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
            const SizedBox(width: 10.0),
            Chip(
              backgroundColor: Theme.of(context).primaryColor,
              label: Consumer<CartProvider>(
                builder: (_, cart, __) => Text(
                  'R\$ ${cart.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white, // Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Consumer<CartProvider>(
              builder: (context, cart, _) => TextButton(
                onPressed: (cart.itemCount > 0)
                    ? () => _addOrder(context, cart)
                    : null,
                child: const Text('COMPRAR'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
