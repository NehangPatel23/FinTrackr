import 'package:fintrackr/screens/ui_elements/header.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class TaxResultsPage extends StatelessWidget {
  final double federalTax;
  final double stateTax;
  final double taxTreatyBenefit;
  final double totalTax;
  final double taxesPaid;
  final double taxesOwedOrRefund;
  final double dependentRelief;

  const TaxResultsPage({
    super.key,
    required this.federalTax,
    required this.stateTax,
    required this.taxTreatyBenefit,
    required this.totalTax,
    required this.taxesPaid,
    required this.taxesOwedOrRefund,
    required this.dependentRelief,
  });

  @override
  Widget build(BuildContext context) {
    final formattedFederalTax = NumberFormat('#,###.##').format(federalTax);
    final formattedStateTax = NumberFormat('#,###.##').format(stateTax);
    final formattedTotalTax = NumberFormat('#,###.##').format(totalTax);
    final formattedTaxesPaid = NumberFormat('#,###.##').format(taxesPaid);
    final formattedTaxesOwedOrRefund =
        NumberFormat('#,###.##').format(taxesOwedOrRefund.abs());

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/tax_calculation.png',
              height: 200,
              width: 200,
            ),
            Header(text: "Tax Calculation Breakdown"),
            _buildTaxCard("Federal Tax", "\$$formattedFederalTax", Colors.blue),
            _buildTaxCard("State Tax", "\$$formattedStateTax", Colors.red),
            if (dependentRelief > 0)
              _buildTaxCard(
                  "Dependent Relief", "\$$dependentRelief", Colors.teal),
            if (taxTreatyBenefit > 0)
              _buildTaxCard(
                  "Tax Treaty Benefit", "\$$taxTreatyBenefit", Colors.green),
            _buildTaxCard(
                "Total Estimated Tax", "\$$formattedTotalTax", Colors.orange),
            _buildTaxCard("Taxes Paid", "\$$formattedTaxesPaid", Colors.cyan),
            _buildTaxResultCard(taxesOwedOrRefund, formattedTaxesOwedOrRefund),
            const SizedBox(height: 20),
            _buildPieChart(),
            const SizedBox(height: 10),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  // Tax Breakdown Card
  Widget _buildTaxCard(String title, String amount, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          // ignore: deprecated_member_use
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.attach_money, color: color),
        ),
        title: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        trailing: Text(
          amount,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }

  // Tax Result Card
  Widget _buildTaxResultCard(double amount, String formattedAmount) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: amount < 0 ? Colors.red[100] : Colors.green[100],
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: amount < 0 ? Colors.red : Colors.green,
          child: Icon(
            amount < 0 ? Icons.warning : Icons.check_circle,
            color: Colors.white,
          ),
        ),
        title: Text(
          amount < 0 ? "Taxes Owed" : "Tax Refund",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          "\$$formattedAmount",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: amount < 0 ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }

  // Pie Chart Visualization
  Widget _buildPieChart() {
    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: federalTax,
                title: "\$${NumberFormat('#,###.##').format(federalTax)}",
                color: Colors.blue,
                radius: 80,
                titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              PieChartSectionData(
                value: stateTax,
                title: "\$${NumberFormat('#,###.##').format(stateTax)}",
                color: Colors.red,
                radius: 80,
                titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              PieChartSectionData(
                value: taxTreatyBenefit,
                title: "\$${NumberFormat('#,###.##').format(taxTreatyBenefit)}",
                color: Colors.green,
                radius: 80,
                titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
            sectionsSpace: 2,
            borderData: FlBorderData(show: false),
            centerSpaceRadius: 40,
          ),
        ),
      ),
    );
  }

  // Tax Legend
  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 8,
          children: [
            _legendItem(Colors.blue, "Federal Tax"),
            _legendItem(Colors.red, "State Tax"),
            _legendItem(Colors.green, "Tax Treaty"),
          ],
        ),
      ),
    );
  }

  // Individual Legend Item
  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }
}
