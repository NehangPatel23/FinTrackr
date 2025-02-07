import 'package:fintrackr/screens/ui_elements/header.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/faq.png', height: 250, width: 250),
              Header(text: "Frequently Asked Questions"),
              const SizedBox(height: 20),

              // FAQ 1
              _buildFAQItem('What is FinTrackr?',
                  'FinTrackr is a financial tracking app that helps you manage and track your finances with ease. It offers stock recommendations, expense tracking, and budgeting tools.'),

              // FAQ 2
              _buildFAQItem('What operating system does the app work on?',
                  'Our app works cross-platform! You can use the app both on iOS & Android!'),

              // FAQ 3
              _buildFAQItem('How does the app recommend stocks?',
                  'Stock recommendations are based on a mix of user preferences, market trends, and real-time stock data analysis.'),

              // FAQ 4
              _buildFAQItem('Is my data secure in the app?',
                  'Yes, the app follows industry-standard encryption and security protocols to protect your personal and financial data.'),

              // FAQ 5
              _buildFAQItem(
                  'Can I integrate my bank account for automatic transaction tracking?',
                  'The current version does not support bank account integration, but future updates may include this feature.'),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
