import 'package:flutter/material.dart';

class BadgeCart extends StatelessWidget {
  final int value;
  final Color? color;
  final Widget child;

  const BadgeCart({
    Key? key,
    required this.value,
    this.color,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        child,
        Positioned(
          top: 8.0,
          right: 8.0,
          child: Container(
            decoration: BoxDecoration(
              color: color ?? Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10.0),
            ),
            constraints: const BoxConstraints(
              minWidth: 16.0,
              minHeight: 16.0,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
