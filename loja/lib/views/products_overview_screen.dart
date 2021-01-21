import 'dart:js';

import 'package:flutter/material.dart';

import 'package:loja/models/product.dart';
import 'package:loja/providers/product.dart';
import 'package:loja/widgets/product_Item.dart';
import 'package:provider/provider.dart';

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Product> loadedProducts = Provider.of<Products>(context).items;
    // estou acessando os produtos a partir de provider products
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha loja'),
      ),
      // O gridview.build mostra os dados de acordo com o que e
      // solicitadod na tela
      body: GridView.builder(
        itemCount: loadedProducts.length,
        itemBuilder: (ctx, i) => ProductItem(
          loadedProducts[i],
        ),
        // Aqui eu estou passando como parametro uma lista de elementos
        // que está sendo acessado pelo indice i
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
