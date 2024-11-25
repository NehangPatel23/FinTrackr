import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/add_expense/blocs/create_category/create_category_bloc.dart';
import 'package:expense_tracker/screens/add_expense/blocs/create_expense/create_expense_bloc.dart';
import 'package:expense_tracker/screens/home/blocs/get_expenses/get_expenses_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_expense/blocs/get_categories/get_categories_bloc.dart';
import '../../add_expense/views/add_expense.dart';
import 'main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../stats/stat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = Theme.of(context).colorScheme.primary;
  Color unselectedItem = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
        builder: (context, state) {
      if (state is GetExpensesSuccess) {
        return Scaffold(
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: BottomNavigationBar(
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 3.0,
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.home,
                          color: index == 0 ? selectedItem : unselectedItem),
                      label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.graph_square,
                          color: index == 1 ? selectedItem : unselectedItem),
                      label: 'Stats'),
                ]),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              var newExpense = await Navigator.push(
                  context,
                  MaterialPageRoute<Expense>(
                    builder: (BuildContext context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              CreateCategoryBloc(FirebaseExpenseRepo()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              GetCategoriesBloc(FirebaseExpenseRepo())
                                ..add(GetCategories()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              CreateExpenseBloc(FirebaseExpenseRepo()),
                        ),
                      ],
                      child: const AddExpense(),
                    ),
                  ));

              if (newExpense != null) {
                setState(() {
                  state.expenses.insert(0, newExpense);
                });
              }
            },
            shape: const CircleBorder(),
            child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary
                    ], transform: const GradientRotation(pi / 4))),
                child: const Icon(CupertinoIcons.add)),
          ),
          body: index == 0 ? MainScreen(state.expenses) : const StatScreen(),
        );
      } else {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
    });
  }
}
