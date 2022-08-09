import 'package:flutter/material.dart';

class AuthLabel extends StatelessWidget {
  const AuthLabel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 55.0,
        vertical: 10.0,
      ),
      decoration: BoxDecoration(
        color: Colors.deepOrange.shade900,
        borderRadius: BorderRadius.circular(25.0),
      ),
      transform: Matrix4.rotationZ(-10.0 * 3.1415 / 180.0)..translate(-10.0),
      child: const Text(
        'Minha Loja',
        style: TextStyle(
          fontFamily: 'Anton',
          fontSize: 45.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
