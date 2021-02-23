import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  static const _url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAJUadPDU5Y7wgqGY3h8p6HGVh7jCxTMS8';

  Future<void> singup(String email, String password) async {
    final response = await http.post(
      // encode manda informações
      // decode rece informações
      _url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    print(json.decode(response.body));
    return Future.value(); // garantindo que vai retornar alguma coisa
  }
}
