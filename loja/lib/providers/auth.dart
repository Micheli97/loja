import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:loja/Exceptions/auth.dart';
import 'package:loja/data/store.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expiryDate;
  Timer _logoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return isAuth ? _userId : null;
  }

  // metodo de autenticação
  // está pegando o token e verificando se esta diferente de nulo, se data de exiração esta diferente de nulo
  // e se a data de expiração e diferente da data atual
  // caso seja verdade ele retorna o token se não retorna null
  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAJUadPDU5Y7wgqGY3h8p6HGVh7jCxTMS8';
    final response = await http.post(
      // encode manda informações
      // decode rece informações
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    // aqui eu estou tratando os erros de autenticação que podem ocorrer durante o login
    // estou armazenando  valor dentro de uma variavel chamda responseBody
    // em seguida estou verificando se a chave de erro que vem com a resposta do backend e diferente de nulo
    // caso a verificação seja verdadeira ele ira acessar a classe AuthException passando como parametro o erro e mensagem vinda do backend
    final responseBody = json.decode(response.body);
    if (responseBody["error"] != null) {
      throw AuthException(responseBody["error"]["message"]);
    } else {
      _token = responseBody["idToken"];
      _expiryDate = DateTime.now()
          // aqui ele está somando o tempo que ele recebeu do back a data atual que vai dar a data de expiração
          .add(Duration(seconds: int.parse(responseBody["expiresIn"])));
    }
    notifyListeners();

    return Future.value(); // garantindo que vai retornar alguma coisa
  }

  Future<void> singup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) {
      return Future.value();
    }

    final userData = await Store.getMap('userData');
    if (userData == null) {
      return Future.value();
    }

    final expiryDate = DateTime.parse(userData["expiryDate"]);

    if (expiryDate.isBefore(DateTime.now())) {
      return Future.value();
    }

    _userId = userData["userId"];
    _token = userData["token"];
    _expiryDate = expiryDate;

    _autoLogout();
    notifyListeners();
    return Future.value();
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
      _logoutTimer = null;
    }
    Store.remove('userData');
    notifyListeners();
  }

  void _autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    final timeToLogout = _expiryDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout), logout);
  }
}
