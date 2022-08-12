import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/exceptions/api_exception.dart';
import 'package:shop_app/exceptions/auth_exception.dart';

enum AuthMode {
  signIn,
  signUp,
}

class AuthProvider extends ChangeNotifier {
  static const appKey = 'AIzaSyD-gNvmf3xLoi-Qa_NSNC2cirx4ksu2pGU';
  static const authBaseUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:';
  static const authSignUp = 'signUp';
  static const authSignIn = 'signInWithPassword';

  static String _authUrl(AuthMode authMode) {
    final mode = authMode == AuthMode.signIn ? authSignIn : authSignUp;
    return '$authBaseUrl$mode?key=$appKey';
  }

  String? _token;
  String? _uid;
  String? _email;
  DateTime? _expireDate;

  bool get isAuthenticated {
    final isTokenValid = _expireDate?.isAfter(DateTime.now()) ?? false;
    return isTokenValid && (_token != null);
  }

  String? get token => isAuthenticated ? _token : null;
  String? get uid => isAuthenticated ? _uid : null;
  String? get email => isAuthenticated ? _email : null;

  Future<void> authenticate(
    String email,
    String password,
    AuthMode authMode,
  ) async {
    final response = await http.post(
      Uri.parse(_authUrl(authMode)),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    // debugPrint('STATUS: ${response.statusCode}');
    // debugPrint(response.body);

    if (response.statusCode == HttpStatus.ok) {
      final body = jsonDecode(response.body);

      _token = body['idToken'];
      _uid = body['localId'];
      _email = body['email'];
      _expireDate = DateTime.now().add(
        Duration(seconds: int.parse(body['expiresIn'])),
      );

      notifyListeners();
    } else {
      if (response.statusCode != HttpStatus.notFound) {
        final error = jsonDecode(response.body)['error'];

        if (error != null) {
          throw AuthException(
            statusCode: response.statusCode,
            error: error['message'],
          );
        } else {
          throw ApiException(
            statusCode: response.statusCode,
            message: 'Unexpected error',
          );
        }
      } else {
        throw ApiException(
          statusCode: response.statusCode,
          message: 'Invalid API URL',
        );
      }
    }
  }
}
