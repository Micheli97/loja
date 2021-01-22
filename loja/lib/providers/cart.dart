import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:loja/providers/product.dart';

class CartItem {
  // Classe dos itens do carrinho
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}
// classe que representa o carrinho

class Cart with ChangeNotifier {
  Map<String, CartItem> _items =
      {}; // dessa forma ele está nulo, a add {} ele se torna vazio
  // A string aqui será o id do produto (chave), e o valor será o item do
  // carrinhoss

  Map<String, CartItem> get items {
    return {..._items};
    // Aqui eu estou clonando os itens para que as modificações feitas
    // não afetem o original
  }

  int get itemCount {
    // aqui eu estou pegando o tamanho da lista, se eu pegasse a partir da logica
    // acima nao daria certo pq eu precisaria clonar a lista toda vez que quisesse
    // fazer isso
    return _items.length;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      // se o id do produto está contido na chave dos itens significa que já
      // existe um item associado a esse produto, logo aqui eu vou atualizar o
      // produto queja existe
      _items.update(
        product.id,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
        // a unica coisa que será atualizada aqui será o valor da quantidade
      );
    } else {
      // caso contrario significa que o item nao esta presente dentro do map
      _items.putIfAbsent(
        // O put server para incluir o se nao estiver presente no map
        product.id,
        () => CartItem(
            id: Random().nextDouble().toString(),
            // esse id e diferente do id do produto
            title: product.title,
            quantity: 1,
            price: product.price),
      );
    }
    notifyListeners();
  }
}
