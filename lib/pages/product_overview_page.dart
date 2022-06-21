import 'package:flutter/material.dart';

import '../providers/product_provider.dart';
import '../widgets/product_tile.dart';

class ProductOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final products = ProductProvider.fetchProducts();

    return Scaffold(
      appBar: AppBar(title: const Text('Loja Exemplo')),
      body: GridView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) => ProductTile(
          products[index],
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
      ),
    );
  }
}
