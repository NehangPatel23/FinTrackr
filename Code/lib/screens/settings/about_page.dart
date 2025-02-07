import 'package:fintrackr/screens/ui_elements/header.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child:
                      Image.asset('assets/info.png', height: 150, width: 150)),
              Center(child: Header(text: 'About')),
              Center(
                child: const Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'FinTrackr is a comprehensive personal finance application designed to empower users in managing their financial well-being. The application offers a user-friendly Expense Tracker Landing Page as the main interface, allowing users to efficiently manage and review their expenses.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Expense Management'),
              _buildBulletPoint(
                  'Easily add new expenses via a form or OCR technology for scanning receipts.'),
              _buildBulletPoint(
                  'View Expenses feature to track spending and identify patterns.'),
              const SizedBox(height: 16),
              _buildSectionTitle('Stock Management'),
              _buildBulletPoint(
                  'Educational content to understand investment strategies.'),
              _buildBulletPoint('Save favorite stocks for quick access.'),
              _buildBulletPoint(
                  'Tools to view stock trends and make informed decisions.'),
              const SizedBox(height: 16),
              _buildSectionTitle('Debt Tracking'),
              _buildBulletPoint(
                  'Insights into outstanding debt and interest calculations.'),
              _buildBulletPoint(
                  'Visual representation of monthly payments using pie charts.'),
              const SizedBox(height: 16),
              _buildSectionTitle('Tax Calculation'),
              _buildBulletPoint('Tax Calculator to assist with tax planning.'),
              _buildBulletPoint(
                  'Input fields for dependents, annual income, and state of residence.'),
              _buildBulletPoint(
                  'Insights into tax treaties and regulations for compliance.'),
              _buildBulletPoint(
                  'Tentative state and federal tax calculations.'),
              const SizedBox(height: 16),
              const Text(
                'By combining these features, the app offers a holistic personal finance tool that blends daily expense management with long-term financial planning. The seamless integration of expense tracking, stock investment insights, debt monitoring, and tax planning equips users with the tools they need for a secure financial future.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
