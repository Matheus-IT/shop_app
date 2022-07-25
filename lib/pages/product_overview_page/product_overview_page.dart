import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../widgets/app_drawer.dart';
import 'badge_cart.dart';
import 'product_grid.dart';

class ProductOverviewPage extends StatefulWidget {
  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  bool _favoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    final hint = _favoritesOnly ? 'todos os produtos' : 'os produtos favoritos';

    //debugPrint('_ProductOverviewPageState.build()');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loja Exemplo'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _favoritesOnly = !_favoritesOnly;
              });
            },
            tooltip: 'Clique para exibir $hint',
            icon: Icon(_favoritesOnly ? Icons.favorite : Icons.favorite_border),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              //debugPrint('Consumer<CartProvider>: ${cart.itemCount}');
              return BadgeCart(
                value: cart.itemCount,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.cart);
                  },
                  icon: const Icon(Icons.shopping_cart),
                  tooltip: 'R\$ ${cart.total.toStringAsFixed(2)}',
                ),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductGrid(favoritesOnly: _favoritesOnly),
    );
  }
}



/*
enum FavoriteOption {
  favorite,
  all,
}
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
*/
