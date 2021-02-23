class AuthException implements Exception {
  static const Map<String, String> erros = {
    "EMAIL_EXISTS": "E-mail existe",
    "OPERATION_NOT_ALLOWED": "Operação não permitida! ",
    "TOO_MANY_ATTEMPTS_TRY_LATER": "Tente mais tarde!",
    "EMAIL_NOT_FOUND": "E-mail ou senha não encontrados!",
    "INVALID_PASSWORD": "E-mail ou senha não encontrados!",
    "USER_DISABLED": "Usuário Inválido!"
  };
  final String key;

  const AuthException(this.key);

  @override
  String toString() {
    if (erros.containsKey(key)) {
      return erros[key];
    } else {
      return "Ocorreu um erro na autenticação";
    }
  }
}
