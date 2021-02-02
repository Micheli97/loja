// O objetivo da classe e encapsular a lista de produtos

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  int get itemsCount {
    return _items.length;
  }

  void addProduct(Product newproduct) {
    const url =
        "https://flutter-loja-a8a23-default-rtdb.firebaseio.com/products.json";
    // tem que add uma variavel apos a barra para que sej criada uma coleção no database
    // o protocolo http é baseado em requisiçao e respota
    // aqui e o corpo da coleção de dados que será armazenado
    // aqui eu estou fazendo uma requisição para o servidor e mandando os dados do produto pra la
    // jsonEncode transforma o map em arquivo json
    http
        .post(
          url,
          body: jsonEncode({
            'title': newproduct.title,
            'description': newproduct.description,
            'price': newproduct.price,
            'imageUrl': newproduct.imageUrl,
            'isFavorite': newproduct.isFavorite,
          }),
        )
        .then((response) => {
              // quando chegar a respota ele vai entrar nesse metodo e add o produto
              // agora o produto so vai ser add depois que tiver a resposta do seridor
              //  o json.decode transforma o arquivo json em um map
              print('resposta'),
              print(jsonDecode(response.body)),
              _items.add(
                Product(
                  id: jsonDecode(response.body)[
                      'name'], // aqui eu estou pegando o id do produto gerado pelo servidor
                  title: newproduct.title,
                  price: newproduct.price,
                  description: newproduct.description,
                  imageUrl: newproduct.imageUrl,
                ),
              ),
              // _items.add(product);
              notifyListeners() //é ele que vai notificar todos os envolvidos
              // que a lista foi modificada
            });

    print('na sequencia');
    // da forma que está ele segue e add o produto independete do servidor
    // _items.add(
    //   Product(
    //     id: Random().nextDouble().toString(),
    //     title: newproduct.title,
    //     price: newproduct.price,
    //     description: newproduct.description,
    //     imageUrl: newproduct.imageUrl,
    //   ),
    // );
    // // _items.add(product);
    // notifyListeners(); //é ele que vai notificar todos os envolvidos
    // // que a lista foi modificada
  }

  void updateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _items.retainWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }
}
