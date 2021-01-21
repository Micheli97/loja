import 'package:flutter/material.dart';
import 'package:loja/data/dummy_data.dart';
import 'package:loja/models/product.dart';
import 'package:loja/widgets/productItem.dart';

class ProductOverviewScreen extends StatelessWidget {
  final List<Product> loadedProducts = DUMMY_PRODUCTS;
  @override
  Widget build(BuildContext context) {
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
