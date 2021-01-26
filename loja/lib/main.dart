import 'package:flutter/material.dart';
import 'package:loja/providers/cart.dart';
import 'package:loja/providers/orders.dart';
import 'package:loja/providers/products.dart';
import 'package:loja/utils/app_routes.dart';
import 'package:loja/views/cart_screen.dart';
import 'package:loja/views/orders_screen.dart';
import 'package:loja/views/product_detail_screen.dart';
import 'package:loja/views/products_overview_screen.dart';
import 'package:loja/views/products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // add multiplos providers
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              new Products(), // aqui ele cria o produto o changeNotifier
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Orders(),
        ),
      ],

      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          // fontFamily: 'Lato',
        ),
        // home: ProductOverviewScreen(),
        routes: {
          AppRoutes.HOME: (ctx) => ProductOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
        },
      ),
    );
  }
}
