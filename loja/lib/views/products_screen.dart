import 'package:flutter/material.dart';

import 'package:loja/providers/products.dart';
import 'package:loja/widgets/app_drawer.dart';
import 'package:loja/widgets/product_Item.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Produtos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: productsData.itemsCount,
            itemBuilder: (ctx, i) => Column(
                  children: [
                    ProductItem(products[i]),
                    Divider(),
                  ],
                )),
      ),
    );
  }
}
