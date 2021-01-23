import 'package:flutter/material.dart';
import 'package:loja/providers/orders.dart';
import 'package:loja/widgets/app_drawer.dart';
import 'package:loja/widgets/order_widget.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus pedidos'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (ctx, i) => OrderWidget(orders.items[i]),
      ),
    );
  }
}
