import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_routes.dart';
import '../../providers/product_provider.dart';
import '../widgets/app_drawer.dart';
import 'product_item.dart';

class ProductManagerPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ProductManagerPage({Key? key}) : super(key: key);

  Future<void> _reloadProducts(BuildContext context) {
    final products = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    return products.loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Gerenciamento de Produtos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.productEdit);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _reloadProducts(context),
        child: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: products.items.length,
          itemBuilder: (context, index) {
            return ProductItem(
              scaffoldKey: _scaffoldKey,
              product: products.items[index],
            );
          },
        ),
      ),
    );
  }
}
