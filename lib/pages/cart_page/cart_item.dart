import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/cart_item_model.dart';
import '../../providers/cart_provider.dart';

class CartItem extends StatelessWidget {
  final CartItemModel cartItem;

  const CartItem({Key? key, required this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.itemId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        final cart = Provider.of<CartProvider>(context, listen: false);
        cart.removeItem(cartItem.productId);
      },
      confirmDismiss: (_) {
        debugPrint('** showDialog: ANTES');
        final result = showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmação de remoção'),
            content: const Text(
                'Tem certeza que deseja remover o item do carrinho?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('NÃO'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('SIM'),
              ),
            ],
          ),
        );
        debugPrint('** showDialog: DEPOIS');
        return result;
      },
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 35.0,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 5.0,
        ),
        child: ListTile(
          title: Text(cartItem.name),
          subtitle: Text('Total: R\$ ${cartItem.total.toStringAsFixed(2)}'),
          trailing: Text('${cartItem.quantity}x'),
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: FittedBox(
                child: Text(
                  cartItem.price.toStringAsFixed(2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
