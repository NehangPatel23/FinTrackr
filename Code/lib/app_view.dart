import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/home/blocs/get_expenses_bloc.dart';
import 'screens/home/views/home_screen.dart';
import 'screens/auth/login_screen.dart'; // Create this file later for the login screen

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
            surface: Colors.grey.shade100,
            onSurface: Colors.black,
            primary: const Color(0xFF00B2E7),
            secondary: const Color(0xFFE064F7),
            tertiary: const Color(0xFFFF8D6C),
            outline: Colors.grey.shade600),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;
            if (user == null) {
              return LoginScreen(); // Show login screen if not authenticated
            } else {
              return BlocProvider(
                create: (context) =>
                    GetExpensesBloc(FirebaseExpenseRepo())..add(GetExpenses()),
                child: const HomeScreen(
                    name: 'John Doe'), // Show home screen if authenticated
              );
            }
          }
          return const CircularProgressIndicator(); // Show loading while checking auth state
        },
      ),
    );
  }
}
