import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../settings/settings_page.dart';

class MainScreen extends StatefulWidget {
  final List<Expense> expenses;
  final String name;
  const MainScreen(
    this.name,
    this.expenses, {
    super.key,
  });

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  List<Expense> sortedExpenses = [];
  double totalExpenses = 0.0;
  final double initialBalance = 1000000.00;
  double income = 2500.00;

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateExpenses();
  }

  @override
  void initState() {
    super.initState();
    _updateExpenses();
    _calculateTotalExpenses();
  }

  void _updateExpenses() {
    setState(() {
      sortedExpenses = [...widget.expenses];
      sortedExpenses.sort((a, b) => b.date.compareTo(a.date));
      _calculateTotalExpenses();
    });
  }

  void _calculateTotalExpenses() {
    setState(() {
      totalExpenses =
          widget.expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.13,
                          height: screenWidth * 0.13,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow.shade700),
                        ),
                        Icon(
                          CupertinoIcons.person_fill,
                          color: Colors.yellow.shade900,
                        )
                      ],
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome!',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.03,
                              color: Theme.of(context).colorScheme.outline),
                        ),
                        Text(
                          '${widget.name}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                              color: Theme.of(context).colorScheme.onSurface),
                        )
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
                    );
                  },
                  icon: const Icon(CupertinoIcons.settings),
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              flex: 0,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.25,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.tertiary,
                    ], transform: const GradientRotation(pi / 4)),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          color: Colors.grey.shade400,
                          offset: const Offset(5, 5))
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      'Total Balance',
                      style: TextStyle(
                          fontSize: screenWidth * 0.042,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '\$${NumberFormat('#,###.00').format(initialBalance + income - totalExpenses)}',
                      style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: screenWidth * 0.07,
                                width: screenWidth * 0.07,
                                decoration: const BoxDecoration(
                                    color: Colors.white30,
                                    shape: BoxShape.circle),
                                child: const Center(
                                    child: Icon(
                                  CupertinoIcons.arrow_down,
                                  color: Colors.greenAccent,
                                  size: 12,
                                )),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Income',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    '\$${NumberFormat('#,###.00').format(income)}',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                height: screenWidth * 0.07,
                                width: screenWidth * 0.07,
                                decoration: const BoxDecoration(
                                    color: Colors.white30,
                                    shape: BoxShape.circle),
                                child: const Center(
                                    child: Icon(
                                  CupertinoIcons.arrow_up,
                                  color: Colors.redAccent,
                                  size: 12,
                                )),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Expenses',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    '\$${NumberFormat('#,###.00').format(totalExpenses)}',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transactions',
                  style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async => _updateExpenses(),
                child: ListView.builder(
                  itemCount: sortedExpenses.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: screenWidth * 0.13,
                                        width: screenWidth * 0.13,
                                        decoration: BoxDecoration(
                                          color: Color(sortedExpenses[index]
                                              .category
                                              .color),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      Image.asset(
                                        'assets/${sortedExpenses[index].category.icon}.png',
                                        scale: 2,
                                        color: Colors.black54,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(Icons.error,
                                              color: Colors.red);
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: screenWidth * 0.03),
                                  Text(
                                    sortedExpenses[index].category.name,
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '-\$${NumberFormat('#,###').format(sortedExpenses[index].amount)}.00',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.035,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MM/dd/yyyy').format(
                                        (sortedExpenses[index].date).toDate()),
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.03,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
