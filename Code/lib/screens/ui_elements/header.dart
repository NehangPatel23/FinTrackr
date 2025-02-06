import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String text;

  const Header({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey.shade800,
        ),
      ),
    );
  }
}
