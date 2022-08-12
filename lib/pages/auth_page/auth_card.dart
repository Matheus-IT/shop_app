import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/validate_helpers.dart';
import '../../providers/auth_provider.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  static const passwordMinLen = 5;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthMode _authMode = AuthMode.signIn;

  bool get _isSignIn => _authMode == AuthMode.signIn;
  bool get _isSignUp => _authMode == AuthMode.signUp;

  String? _validateEmail(String? email) {
    email = email ?? '';
    if (email.isEmpty) {
      return 'O e-mail é obrigatório';
    }
    if (!validateEmail(email)) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    password = password ?? '';
    if (password.isEmpty) {
      return 'A senha é obrigatória';
    }
    if (password.length < passwordMinLen) {
      return 'A senha deve possuir no mínimo $passwordMinLen caracteres';
    }
    return null;
  }

  String? _validatePasswordConfirmation(String? passwordConfirmation) {
    passwordConfirmation = passwordConfirmation ?? '';
    if (passwordConfirmation != _passwordController.text) {
      return 'A confirmação de senha não combina';
    }
    return null;
  }

  void _switchAuthMode() {
    setState(() {
      _authMode = _isSignIn ? AuthMode.signUp : AuthMode.signIn;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ocorreu um Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('FECHAR'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    final auth = Provider.of<AuthProvider>(context, listen: false);

    auth.authenticate(
      _emailController.text,
      _passwordController.text,
      _authMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final devSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        margin: const EdgeInsets.all(15.0),
        width: devSize.width * 0.75,
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // E-mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                keyboardType: TextInputType.text,
                validator: _validatePassword,
              ),
              if (_isSignUp)
                // Password  confirmation
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                  ),
                  keyboardType: TextInputType.text,
                  validator: _isSignUp ? _validatePasswordConfirmation : null,
                ),
              const SizedBox(height: 30.0),
              // Action (SignIn or SignUp)
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 8.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(_isSignIn ? 'ENTRAR' : 'REGISTRAR'),
              ),
              //const Spacer(),
              // Change SignIn/SignUp state
              TextButton(
                onPressed: _switchAuthMode,
                child:
                    Text(_isSignIn ? 'DESEJA REGISTRAR?' : 'JÁ POSSUI CONTA?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
