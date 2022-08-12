class AuthException implements Exception {
  static const apiErrors = {
    // SignUp Errors
    'EMAIL_EXISTS': 'The email address is already in use by another account.',
    'OPERATION_NOT_ALLOWED': 'Password sign-in is disabled for this project.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'We have blocked all requests from this device due to unusual activity. Try again later.',
    // SignIn Errors
    'EMAIL_NOT_FOUND':
        'There is no user record corresponding to this identifier. The user may have been deleted.',
    'INVALID_PASSWORD':
        'The password is invalid or the user does not have a password.',
    'USER_DISABLED': 'The user account has been disabled by an administrator.',
  };
  static const userErrors = {
    // SignUp Errors
    'EMAIL_EXISTS': 'E-mail já registrado.',
    'OPERATION_NOT_ALLOWED': 'Registro de novos usuários desativado.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente. Tente novamente mais tarde.',
    // SignIn Errors
    'EMAIL_NOT_FOUND': 'E-mail ou senha inválidos.',
    'INVALID_PASSWORD': 'E-mail ou senha inválidos.',
    'USER_DISABLED': 'Conta desabilitada.',
    // API Errors
    'API_ERROR': 'Erro desconhecido.',
  };

  final int statusCode;
  final String error;

  AuthException({
    required this.statusCode,
    required this.error,
  });

  @override
  String toString() => apiErrors[error] ?? 'API Error $statusCode';

  String userMessage() => userErrors[error] ?? userErrors['API_ERROR']!;
}
