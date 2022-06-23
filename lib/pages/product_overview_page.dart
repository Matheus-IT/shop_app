import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

enum FavoriteOption {
  favorite,
  all,
}

class ProductOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja Exemplo'),
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    const PopupMenuItem<FavoriteOption>(
                      value: FavoriteOption.favorite,
                      child: Text('Favoritos'),
                    ),
                    const PopupMenuItem<FavoriteOption>(
                      value: FavoriteOption.all,
                      child: Text('Todos'),
                    ),
                  ]),
        ],
      ),
      body: ProductGrid(),
    );
  }
}
