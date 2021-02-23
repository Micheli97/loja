import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;

  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'email': "",
    "password": "",
  };

  void _submit() {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();
    // aqui ele esta chamando o metodo save para cada textform

    if (_authMode == AuthMode.Login) {
      // implementar o login
    } else {
      // registrar
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      _authMode = AuthMode.Login;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size; // pegando o tamanho da tela

    return SingleChildScrollView(
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: _authMode == AuthMode.Login ? 310 : 390,
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains("@")) {
                      return "Informe um email válido!";
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['email'] = value,
                  // aqui eu estou recebendo um valor, pegando a chave email
                  // e atribuindo o valor recebido a essa chave
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Senha"),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return "Informe uma senha válida!";
                    }
                    return null;
                  },
                  onSaved: (value) => _authData['password'] = value,
                  // aqui eu estou recebendo um valor, pegando a chave email atribuindo o valor recebido a essa chave
                ),
                if (_authMode == AuthMode.Signup)
                  // verificando o modo para mostrar ou nao um campo
                  TextFormField(
                    decoration: InputDecoration(labelText: "Confirmmar senha"),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return "As senhas são diferentes";
                            }
                            return null;
                          }
                        : null,
                  ),
                Spacer(),
                // rederização condicional
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 8.0,
                    ),
                    child: Text(
                      _authMode == AuthMode.Login ? "ENTRAR" : "REGISTRAR",
                    ),
                    onPressed: _submit,
                  ),
                FlatButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                    "ALTERNAR P/ ${_authMode == AuthMode.Login ? 'REGISTRAR' : 'LOGIN'}",
                  ),
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
