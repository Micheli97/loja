// O objetivo da classe e encapsular a lista de produtos

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loja/Exceptions/http_execptions.dart';
import 'package:loja/utils/constants.dart';
import '../providers/product.dart';

class Products with ChangeNotifier {
  // quando uma mudança aconte ele notifica aos "interessasdos"
  // quando um determinado valor for modificado
  final String _baseUrl = '${Constants.BASE_API_URL}/products';
  List<Product> _items = [];

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

  Future<void> loadProducts() async {
    final response = await http.get("$_baseUrl.json");
    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();
    if (data != null) {
      data.forEach((productId, productData) {
        _items.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      "$_baseUrl.json",
      body: jsonEncode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
    );

    _items.add(Product(
      id: json.decode(response.body)['name'],
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      imageUrl: newProduct.imageUrl,
    ));
    notifyListeners();
  }

  // print('na sequencia');
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

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      await http.post(
        "$_baseUrl/${product.id}.json",
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete("$_baseUrl/${product.id}.json");

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do produto.');
      }
    }
  }
}
