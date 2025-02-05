import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class DebtPage extends StatefulWidget {
  @override
  _DebtPageState createState() => _DebtPageState();
}

class _DebtPageState extends State<DebtPage> {
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
      monthlyPayment = (amount * monthlyInterest) / (1 - pow(1 + monthlyInterest, -loanTermMonths));
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Move the image right below the app bar title
              Image.asset(
                'E:/college stuff/senior design project/FinTrackr/Code/assets/expenses-removebg-preview.png',
                height: 200,
                width: 200,
              ),
              const Text('\nDebt Calculator', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
              const Text(
                '\nDebt Amount',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),

              SizedBox(height: 20), // Space between image and inputs
              _buildInputField(
                controller: amountController,
                labelText: "Amount (\$)",
                icon: Icons.monetization_on,
              ),
              const Text(
                '\nInterest Rate',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              _buildInputField(
                controller: interestController,
                labelText: "Interest Rate (%)",
                icon: Icons.percent,
              ),
              SizedBox(height: 20),
              _buildResults(),
              SizedBox(height: 20),
              _buildChart(),
              SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
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

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: () {
        // Submit functionality
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.tertiary,
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).colorScheme.primary,
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Text(
            'Submit',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateChartSections() {
    double principal = double.tryParse(amountController.text) ?? 0.0;
    double interest = totalPayments - principal;

    return [
      PieChartSectionData(
        color: Colors.blue,
        value: principal,
        title: "${principal.toStringAsFixed(2)}",
        radius: 110, // Large radius for full pie effect
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: interest,
        title: "${interest.toStringAsFixed(2)}",
        radius: 110, // Ensure full coverage
        titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ];
  }
}
