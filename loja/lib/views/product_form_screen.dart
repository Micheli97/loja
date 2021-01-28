import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loja/providers/product.dart';
import 'package:loja/providers/products.dart';
import 'package:provider/provider.dart';

class ProductFormScreen extends StatefulWidget {
  @override
  _ProductFormScreenState createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  @override
  Widget build(BuildContext context) {
    final _priceFocusNode = FocusNode();
    final _descriptionFocusNode = FocusNode();
    final _imageUrlFocusNode = FocusNode();
    final _imageUrlController = TextEditingController();
    final _form = GlobalKey<FormState>();
    // essa global key e para acessar o formulário
    final _formData = Map<String, Object>();
    // criando um objeto a partir do map

    bool isValidImageUrl(String url) {
      bool startWidthHttp = url.toLowerCase().startsWith('http://');
      bool startWtihHttps = url.toLowerCase().startsWith('https://');
      bool endsWithPng = url.toLowerCase().startsWith('.png');
      bool endsWithJpg = url.toLowerCase().startsWith('.jpg');
      bool endsWithJpeg = url.toLowerCase().startsWith('.jpeg');

      return (startWidthHttp || startWtihHttps) &&
          (endsWithPng || endsWithJpg || endsWithJpeg);
    }

    void _updateImage() {
      if (isValidImageUrl(_imageUrlController.text)) {
        setState(() {});
      }
    }

    @override
    void initState() {
      // inicializando o estado
      super.initState();
      _imageUrlFocusNode.addListener(_updateImage);
    }

    @override
    void didChageDependencies() {
      super.didChangeDependencies();

      if (_formData.isEmpty) {
        // aqui ele vai iniciar o formData apenas quando ele estiver vazio

        final product = ModalRoute.of(context).settings.arguments as Product;
        _formData['id'] = product.id;
        _formData['title'] = product.title;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = _formData['imageUrl'];
      }
    }

    @override
    void disposed() {
      super.dispose();
      _priceFocusNode.dispose();
      _descriptionFocusNode.dispose();
      _imageUrlFocusNode.removeListener(_updateImage);
      _imageUrlFocusNode.dispose();
    }

    void _saveForm() {
      var isValid = _form.currentState.validate();
      // chamando a validação
      if (!isValid) {
        // se o formulário nao for valido ele sai e nao executa as linhas abaixo
        return;
      }

      _form.currentState.save();
      final newProduct = Product(
        id: Random().nextDouble().toString(),
        title: _formData['title'],
        price: _formData['price'],
        description: _formData['description'],
        imageUrl: _formData['imageUrl'],
        // acessando os valorers do formulario
      );

      Provider.of<Products>(context, listen: false).addProduct(newProduct);
      // É possivel utilizar o metodo provider fora do builder desde que use o
      // listners como false
      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário Produto'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formData['title'],
                decoration: InputDecoration(labelText: 'Título'),
                textInputAction: TextInputAction.next, // para pular para o
                // textform
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => _formData['title'] = value,
                validator: (value) {
                  bool isEmpty = value.trim().isEmpty;
                  bool isInvalid = value.trim().length < 3;
                  if (isEmpty || isInvalid) {
                    return 'Informe um Título válido!';
                  }

                  return null;
                },
              ),
              TextFormField(
                  initialValue: _formData['price'].toString(),
                  decoration: InputDecoration(labelText: 'Preço'),
                  textInputAction: TextInputAction.next, // para pular para o
                  // textform
                  focusNode: _priceFocusNode,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) => _formData['prive'] = double.parse(value)),
              TextFormField(
                initialValue: _formData['description'],
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) => _formData['description'] = value,
                validator: (value) {
                  bool emptyUrl = value.trim().isEmpty;
                  var newPrice = double.tryParse(value);
                  bool invalidUrl = newPrice == null || newPrice <= 0;

                  if (emptyUrl || invalidUrl) {
                    return 'Informe um Preço válido!';
                  }
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                // Quando não se tem a largura definida a row não é mostrada na tela
                children: [
                  Expanded(
                    // ao usar o expandede ele corrige esse problema
                    child: TextFormField(
                      initialValue: _formData['imageUrl'],
                      // O controller so esta sendo usasdo porque precisa do prevew
                      // da imagem antes de submeter o formulário
                      decoration: InputDecoration(
                        labelText: 'URL da Imagem',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) => _formData['imageUrl'] = value,
                      validator: (value) {
                        bool emptyUrl = value.trim().isEmpty;
                        bool invalidUrl = isValidImageUrl(value);

                        if (emptyUrl || invalidUrl) {
                          return 'Informe uma url válida!';
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1, // espessura da borda
                      ),
                    ),
                    alignment: Alignment.center,
                    child: _imageUrlController.text.isEmpty
                        ? Text('Informe a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
