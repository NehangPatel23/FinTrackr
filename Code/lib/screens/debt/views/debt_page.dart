import 'package:fintrackr/screens/ui_elements/header.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

import '../../ui_elements/question_row.dart';

class DebtPage extends StatefulWidget {
  const DebtPage({super.key});

  @override
  DebtPageState createState() => DebtPageState();
}

class DebtPageState extends State<DebtPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  double monthlyPayment = 0.0;
  double totalPayments = 0.0;

  void calculatePayments() {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    double interestRate = double.tryParse(interestController.text) ?? 0.0;
    double monthlyInterest = (interestRate / 100) / 12;
    int loanTermMonths = 60; // Assume a 5-year loan term

    if (amount > 0 && interestRate > 0) {
      monthlyPayment = (amount * monthlyInterest) /
          (1 - pow(1 + monthlyInterest, -loanTermMonths));
      totalPayments = monthlyPayment * loanTermMonths;
    } else {
      monthlyPayment = 0.0;
      totalPayments = 0.0;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/debt.png',
                  height: 150,
                  width: 250,
                ),
                Header(text: 'Debt Calculator'),
                SizedBox(height: 20),
                QuestionRow(
                    question: 'Debt Amount',
                    title: "How much debt do you currently owe?",
                    message: "Please input your TOTAL debt amount."),
                _buildInputField(
                  controller: amountController,
                  icon: Icons.monetization_on,
                ),
                SizedBox(height: 25),
                QuestionRow(
                    question: 'Interest Rate',
                    title: "What interest do you pay on your debt?",
                    message:
                        "Please input the interest rate on your debt amount."),
                _buildInputField(
                  controller: interestController,
                  icon: Icons.percent,
                ),
                SizedBox(height: 20),
                _buildResults(),
                SizedBox(height: 20),
                _buildChart(),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (_) => calculatePayments(),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Monthly Payment: \$${monthlyPayment.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          "Estimated Total Payments: \$${totalPayments.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildChart() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1.5, // Adjust aspect ratio for a better fit
                child: PieChart(
                  PieChartData(sections: _generateChartSections()),
                ),
              ),
              SizedBox(height: 10),
              _buildLegend(), // Add legend below the chart
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(Colors.blue, "Principal"),
        SizedBox(width: 20),
        _buildLegendItem(Colors.red, "Interest"),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<PieChartSectionData> _generateChartSections() {
    double principal = double.tryParse(amountController.text) ?? 0.0;
    double interest = totalPayments - principal;

    return [
      PieChartSectionData(
        color: Colors.blue,
        value: principal,
        title: '\$${principal.toStringAsFixed(2)}',
        radius: 110, // Large radius for full pie effect
        titleStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: interest,
        title: '\$${interest.toStringAsFixed(2)}',
        radius: 110, // Ensure full coverage
        titleStyle: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ];
  }
}
