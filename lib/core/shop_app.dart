import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/product_detail_page.dart';

import '../pages/cart_page.dart';
import '../pages/product_overview_page.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import 'app_routes.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ProductProvider>(create: (_) => ProductProvider()),
        Provider<CartProvider>(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
        ),
        initialRoute: AppRoutes.productOverview,
        routes: {
          AppRoutes.productOverview: (_) => ProductOverviewPage(),
          AppRoutes.productDetail: (_) => ProductDetailPage(),
          AppRoutes.cart: (_) => const CartPage(),
        },
      ),
    );
  }
}
