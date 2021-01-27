import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:loja/providers/product.dart';

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
    final _formDdata = Map<String, Object>();
    // criando um objeto a partir do map

    void _updateImage() {
      setState(() {});
    }

    @override
    void initState() {
      // inicializando o estado
      super.initState();
      _imageUrlFocusNode.addListener(_updateImage);
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
      _form.currentState.save();
      final newProduct = Product(
        id: Random().nextDouble().toString(),
        title: _formDdata['title'],
        price: _formDdata['price'],
        description: _formDdata['description'],
        imageUrl: _formDdata['imageUrl'],
        // acessando os valorers do formulario
      );
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
                decoration: InputDecoration(labelText: 'Título'),
                textInputAction: TextInputAction.next, // para pular para o
                // textform
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) => _formDdata['title'] = value,
              ),
              TextFormField(
                  decoration: InputDecoration(labelText: 'Preço'),
                  textInputAction: TextInputAction.next, // para pular para o
                  // textform
                  focusNode: _priceFocusNode,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) =>
                      _formDdata['prive'] = double.parse(value)),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) => _formDdata['description'] = value,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                // Quando não se tem a largura definida a row não é mostrada na tela
                children: [
                  Expanded(
                    // ao usar o expandede ele corrige esse problema
                    child: TextFormField(
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
                      onSaved: (value) => _formDdata['imageUrl'] = value,
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
