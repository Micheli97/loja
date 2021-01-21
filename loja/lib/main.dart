import 'package:flutter/material.dart';
import 'package:loja/utils/app_routes.dart';
import 'package:loja/views/product_detail_screen.dart';
import 'package:loja/views/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      home: ProductOverviewScreen(),
      routes: {AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen()},
    );
  }
}
