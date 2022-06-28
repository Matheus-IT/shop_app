import 'package:flutter/material.dart';

import '../widgets/product_grid.dart';

enum FavoriteOption {
  favorite,
  all,
}

class ProductOverviewPage extends StatefulWidget {
  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  bool _favoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja Exemplo'),
        actions: [
          PopupMenuButton<FavoriteOption>(
            itemBuilder: (context) => [
              const PopupMenuItem<FavoriteOption>(
                value: FavoriteOption.favorite,
                child: Text('Favoritos'),
              ),
              const PopupMenuItem<FavoriteOption>(
                value: FavoriteOption.all,
                child: Text('Todos'),
              ),
            ],
            onSelected: (option) {
              setState(() {
                _favoritesOnly = option == FavoriteOption.favorite;
              });
              debugPrint('favorites=$_favoritesOnly');
            },
          ),
        ],
      ),
      body: ProductGrid(favoritesOnly: _favoritesOnly),
    );
  }
}
