import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';

import '../../core/app_routes.dart';
import '../../models/product_model.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;

  const ProductItem(this.product, {Key? key}) : super(key: key);

  void _removeProduct(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exclusão de Produto'),
        content: const Text('Confirma a exclusão do produto?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('NÃO'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('SIM'),
          ),
        ],
      ),
    ).then((removeProduct) {
      if (removeProduct == true) {
        Provider.of<ProductProvider>(
          context,
          listen: false,
        ).removeProduct(product.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100.0,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.productEdit,
                  arguments: product,
                );
              },
              color: Theme.of(context).primaryColor,
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () => _removeProduct(context),
              color: Theme.of(context).errorColor,
              icon: const Icon(Icons.delete_outline_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
