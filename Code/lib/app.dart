import 'package:flutter/material.dart';

import 'app_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // Hides the keyboard
        },
        child: const MyAppView());
  }
}
