import 'dart:math';

import 'package:expense_repository/expense_repository.dart';
import 'package:fintrackr/screens/debt/views/debt_page.dart';
import 'package:fintrackr/screens/taxes/taxes_page.dart';
import 'package:fintrackr/screens/stocks/stocks_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_expense/blocs/create_category/create_category_bloc.dart';
import '../../add_expense/blocs/create_expense/create_expense_bloc.dart';
import '../../add_expense/blocs/get_categories/get_categories_bloc.dart';
import '../../add_expense/views/add_expense.dart';
import '../blocs/get_expenses_bloc.dart';
import 'main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  const HomeScreen({super.key, avatar, required this.name});

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
                currentIndex: index,
                onTap: (value) {
                  if (value == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StockPage()),
                    );
                  } else {
                    setState(() {
                      index = value;
                    });
                  }
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
                      label: 'Stocks'),
                ]),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading:
                              const Icon(CupertinoIcons.money_dollar_circle),
                          title: const Text("Add Transaction"),
                          onTap: () async {
                            Navigator.pop(context); // Close the bottom sheet
                            var newExpense = await Navigator.push(
                              context,
                              MaterialPageRoute<Expense>(
                                builder: (BuildContext context) =>
                                    MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => CreateCategoryBloc(
                                          FirebaseExpenseRepo()),
                                    ),
                                    BlocProvider(
                                      create: (context) => GetCategoriesBloc(
                                          FirebaseExpenseRepo())
                                        ..add(GetCategories()),
                                    ),
                                    BlocProvider(
                                      create: (context) => CreateExpenseBloc(
                                          FirebaseExpenseRepo()),
                                    ),
                                  ],
                                  child: const AddExpense(),
                                ),
                              ),
                            );
                            if (newExpense != null) {
                              setState(() {
                                state.expenses.insert(0, newExpense);
                              });
                            }
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading:
                              const Icon(CupertinoIcons.chart_bar_alt_fill),
                          title: const Text("Taxes"),
                          onTap: () {
                            Navigator.pop(context); // Close the bottom sheet
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaxesPage()),
                            );
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.attach_money),
                          title: const Text("Debt"),
                          onTap: () {
                            Navigator.pop(context); // Close the bottom sheet
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DebtPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
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
                  Theme.of(context).colorScheme.primary,
                ], transform: const GradientRotation(pi / 4)),
              ),
              child: const Icon(CupertinoIcons.add),
            ),
          ),
          body: index == 0
              ? MainScreen(widget.name, state.expenses)
              : const StockPage(),
        );
      } else {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
    });
  }
}
