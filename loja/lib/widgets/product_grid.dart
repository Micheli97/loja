import 'package:flutter/material.dart';
import 'package:loja/providers/products.dart';
import 'package:loja/widgets/product_grid_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;
  ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final product = showFavoriteOnly
        ? productsProvider.favoriteItems
        : productsProvider.items;
    // estou acessando os produtos a partir de provider products
    // O gridview.build mostra os dados de acordo com o que e
    // solicitado na tela
    return GridView.builder(
      itemCount: product.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: product[i],
        child: ProductItem(),
      ),
      // Aqui eu estou passando como parametro uma lista de elementos
      // que está sendo acessado pelo indice i
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
