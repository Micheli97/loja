import 'package:flutter/material.dart';
import 'package:loja/providers/products.dart';
import 'package:loja/utils/app_routes.dart';
import 'package:loja/views/product_detail_screen.dart';
import 'package:loja/views/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // esta envolvendo a aplicacao em um ponto que etara disponivel para
      // toda a aplicacao
      // o  ChangeNotifierProvider é especializado no tipo de classe ChangeNotifier

      create: (_) => Products(), // aqui ele cria o produto o changeNotifier
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          // fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen()},
      ),
    );
  }
}
