import 'package:fintrackr/screens/ui_elements/header.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';

import '../../ui_elements/launch_url.dart';
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

  void _showMoreInfoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.circleInfo),
            onPressed: _showMoreInfoPage,
          ),
        ],
      ),
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

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset('assets/debt-info-page.png', height: 200, width: 200),
              Header(text: 'Helpful Links & Information'),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Disclaimer: ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const TextSpan(
                      text:
                          'The debt values and calculations displayed are based on dummy data and are not representative of actual calculations. The numbers provided are for demonstration purposes only.',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Text('What Is Debt?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              Text(
                  'Debt is an obligation that requires one party, the debtor, to pay money borrowed or otherwise withheld from another party, the creditor. \n\nDebt may be owed by a sovereign state or country, local government, company, or an individual. \n\nCommercial debt is generally subject to contractual terms regarding the amount and timing of repayments of principal and interest. \n\nLoans, bonds, notes, and mortgages are all types of debt.'),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => launchURL(
                    'https://usaaef.org/credit-debt/debt/managing-debt/what-is-debt/'),
                child: const Text(
                  'What is Debt?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () =>
                    launchURL('https://www.investopedia.com/terms/d/debt.asp'),
                child: const Text(
                  'What Is Debt, How It Works & How To Pay It Back?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () =>
                    launchURL('https://consumer.gov/debt/debt-explained'),
                child: const Text(
                  'Debt Explained',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () => launchURL(
                    'https://consumer.ftc.gov/articles/how-get-out-debt'),
                child: const Text(
                  'How to Get Out of Debt?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text('Want to Learn More About Debt?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL('https://usaaef.org/credit-debt/debt/'),
                child: const Text(
                  'Understanding Credit & Managing Debt',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://debtreductionservices.org/financial-education/'),
                child: const Text(
                  'Free Financial Education - Debt Reduction Services',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.youtube.com/watch?v=2wHLd7S6iTc&ab_channel=PracticalWisdom-InterestingIdeas'),
                child: const Text(
                  'Free Course on Financial Education',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.nationaldebtrelief.com/resources/personal-finance-debt-relief/financial-literacy/'),
                child: const Text(
                  'Financial Literacy',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://about.bankofamerica.com/en/making-an-impact/financial-education-resources-advice'),
                child: const Text(
                  'Building Financial Know-How',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.consumerfinance.gov/consumer-tools/educator-tools/adult-financial-education/tools-and-resources/'),
                child: const Text(
                  'Financial Education for Adults',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text('How to Pay Off Debt Faster?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.wellsfargo.com/goals-credit/smarter-credit/manage-your-debt/pay-off-debt-faster/'),
                child: const Text(
                  'How to Pay Off Debt Faster',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.wellsfargo.com/goals-credit/smarter-credit/manage-your-debt/snowball-vs-avalanche-paydown/'),
                child: const Text(
                  'The Debt Snowball vs. Avalanche Methods',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.ramseysolutions.com/debt/debt-calculator?srsltid=AfmBOop3aN91oYGZQhZmr2pDXasmsjZUIQVSAp-MUwfPRz0A_wZVQcUV'),
                child: const Text(
                  'Debt Snowball Calculator',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.militaryonesource.mil/resources/millife-guides/paying-off-debt/'),
                child: const Text(
                  'Controlling & Paying Off Debt',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 50),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'More information is just a simple ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Google Search',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchURL(
                            'https://www.google.com/search?q=pay+off+debt&sca_esv=cd731438e95bc999&biw=1728&bih=992&sxsrf=AHTn8zo-3Tnf78ZpCORP7ISvngEwOw7oGg%3A1743539284684&ei=VEzsZ-K7KYuW5OMPtYS2uAs&ved=0ahUKEwjitdz91beMAxULC3kGHTWCDbc4ChDh1QMIEA&uact=5&oq=pay+off+debt&gs_lp=Egxnd3Mtd2l6LXNlcnAiDHBheSBvZmYgZGVidDIKECMYgAQYJxiKBTIKEAAYgAQYFBiHAjIKEAAYgAQYFBiHAjIFEAAYgAQyBRAAGIAEMgUQABiABDIFEAAYgAQyChAAGIAEGEMYigUyBRAAGIAEMgUQABiABEjzDlCsClisCnABeAGQAQCYAWKgAWKqAQExuAEDyAEA-AEBmAICoAJrwgIKEAAYsAMY1gQYR5gDAIgGAZAGCJIHAzEuMaAHwwY&sclient=gws-wiz-serp'),
                    ),
                    const TextSpan(
                      text: ' a simple Google Search away!',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
