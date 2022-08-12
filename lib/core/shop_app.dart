import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/product_detail_page/product_detail_page.dart';

import '../pages/cart_page/cart_page.dart';
import '../pages/main_page/main_page.dart';
import '../pages/order_page/order_page.dart';
import '../pages/product_manager_page/product_manager_page.dart';
import '../pages/product_page/product_page.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/product_provider.dart';
import 'app_routes.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (_) => ProductProvider(),
          update: (_, auth, products) => ProductProvider(
            auth: auth,
            products: products?.items,
          ),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider<OrderProvider>(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          // ignore: deprecated_member_use
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        initialRoute: AppRoutes.home,
        routes: {
          AppRoutes.home: (_) => const MainPage(),
          AppRoutes.productDetail: (_) => ProductDetailPage(),
          AppRoutes.productManager: (_) => ProductManagerPage(),
          AppRoutes.productEdit: (_) => const ProductPage(),
          AppRoutes.cart: (_) => const CartPage(),
          AppRoutes.orders: (_) => const OrderPage(),
        },
      ),
    );
  }
}
