import 'package:flutter/material.dart';

import 'package:loja/views/auth_screen.dart';
import 'package:loja/views/products_overview_screen.dart';

import 'package:loja/providers/auth.dart';
import 'package:provider/provider.dart';

class AuthOrHomeScreen extends StatelessWidget {
  // essa tela ira direcionar para o componente de autenticação ou para o componente principal da aplicação
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return auth.isAuth ? ProductOverviewScreen() : AuthScreen();
        }
      },
    );
  }
}
