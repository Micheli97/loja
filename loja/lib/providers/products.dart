// O objetivo da classe e encapsular a lista de produtos

import 'package:flutter/cupertino.dart';
import 'package:loja/data/dummy_data.dart';
import '../providers/product.dart';

class Products with ChangeNotifier {
  // quando uma mudança aconte ele notifica aos "interessasdos"
  // quando um determinado valor for modificado

  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];
  // Aqui eu estou retornando uma cópida da lista
  // Mesmo que a lista seja modificada não irá alterar a lista original
  // Se alguem quiser alterar o valor será pela classe Products e nao a partir
  // do valor que e retornando por get items
  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
    // aqui esta retornando apenas os itens favoritos da lista
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners(); //é ele que vai notificar todos os envolvidos
    // que a lista foi modificada
  }
}
