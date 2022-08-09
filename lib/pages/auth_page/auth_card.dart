import 'package:flutter/material.dart';

enum AuthMode {
  signIn,
  signUp,
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  AuthMode _authMode = AuthMode.signUp;

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
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
                keyboardType: TextInputType.text,
              ),
              if (_authMode == AuthMode.signUp)
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                  ),
                  keyboardType: TextInputType.text,
                ),
              const SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: () {},
                child: const Text('ENTRAR'),
              ),
              const SizedBox(height: 20.0),
              TextButton(
                onPressed: () {},
                child: const Text('REGISTRAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
