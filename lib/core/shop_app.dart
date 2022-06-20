import 'package:flutter/material.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = ProductProvider.fetchProducts();
    final children = List<Widget>.generate(
      products.length,
      (int index) => Container(
        color: Colors.amber,
        child: Text(products[index].name),
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Loja Exemplo')),
        body: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          children: children,
        ),
      ),
    );
  }
}
