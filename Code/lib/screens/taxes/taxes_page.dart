import 'package:fintrackr/screens/ui_elements/header.dart';
import 'package:fintrackr/screens/ui_elements/question_row.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../ui_elements/dropdown.dart';
import '../ui_elements/launch_url.dart';
import '../ui_elements/text_field.dart';
import 'tax_results.dart';

class TaxesPage extends StatefulWidget {
  const TaxesPage({super.key});

  @override
  State<TaxesPage> createState() => _TaxesPageState();
}

class _TaxesPageState extends State<TaxesPage> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController dependentsController = TextEditingController();
  TextEditingController taxesPaidController = TextEditingController();
  String? selectedState;
  String? selectedCountry;
  String? maritalStatus;
  String? filingStatus;

  final List<String> states = [
    "Alabama",
    "Alaska",
    "Arizona",
    "Arkansas",
    "California",
    "Colorado",
    "Connecticut",
    "Delaware",
    "Florida",
    "Georgia",
    "Hawaii",
    "Idaho",
    "Illinois",
    "Indiana",
    "Iowa",
    "Kansas",
    "Kentucky",
    "Louisiana",
    "Maine",
    "Maryland",
    "Massachusetts",
    "Michigan",
    "Minnesota",
    "Mississippi",
    "Missouri",
    "Montana",
    "Nebraska",
    "Nevada",
    "New Hampshire",
    "New Jersey",
    "New Mexico",
    "New York",
    "North Carolina",
    "North Dakota",
    "Ohio",
    "Oklahoma",
    "Oregon",
    "Pennsylvania",
    "Rhode Island",
    "South Carolina",
    "South Dakota",
    "Tennessee",
    "Texas",
    "Utah",
    "Vermont",
    "Virginia",
    "Washington",
    "West Virginia",
    "Wisconsin",
    "Wyoming"
  ];

  final List<String> countries = [
    "United States",
    "Canada",
    "United Kingdom",
    "Germany",
    "France",
    "Australia",
    "India",
    "China",
    "Japan",
    "South Korea",
    "Brazil",
    "Mexico",
    "Italy",
    "Spain",
    "Netherlands",
    "Switzerland",
    "Sweden",
    "Norway",
    "Denmark",
    "Finland",
    "Ireland",
    "New Zealand",
    "Singapore",
    "South Africa"
  ];

  void _showMoreInfoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoPage(),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Helper method to apply random tax treaty benefits for countries
  double _getTaxTreatyBenefit(String country) {
    Map<String, double> taxTreatyBenefits = {
      'United States': 0.0, // No treaty with US
      'Canada': 2000.0,
      'United Kingdom': 2500.0,
      'Germany': 1500.0,
      'France': 1800.0,
      'Australia': 1200.0,
      'India': 1000.0,
      'China': 900.0,
      'Japan': 1400.0,
      'South Korea': 1300.0,
      'Brazil': 1100.0,
      'Mexico': 950.0,
      'Italy': 1600.0,
      'Spain': 1700.0,
      'Netherlands': 2000.0,
      'Switzerland': 2200.0,
      'Sweden': 2100.0,
      'Norway': 2300.0,
      'Denmark': 2400.0,
      'Finland': 2500.0,
      'Ireland': 2600.0,
      'New Zealand': 2700.0,
      'Singapore': 2800.0,
      'South Africa': 2900.0,
    };
    return taxTreatyBenefits[country] ??
        0.0; // Default to 0 if country is not in the list
  }

// Helper method to get random state tax rates (some states with no taxes)
  double _getStateTaxRate(String state) {
    Map<String, double> stateTaxRates = {
      'California': 0.13,
      'Texas': 0.0,
      'Florida': 0.0,
      'New York': 0.088,
      'Nevada': 0.0,
      'Washington': 0.1,
      'Oregon': 0.09,
      'Wyoming': 0.0,
      'Georgia': 0.065,
      'Illinois': 0.0495,
      'Alabama': 0.04,
      'Alaska': 0.0,
      'Arizona': 0.05,
      'Arkansas': 0.065,
      'Colorado': 0.045,
      'Connecticut': 0.06,
      'Delaware': 0.0,
      'District of Columbia': 0.085,
      'Idaho': 0.067,
      'Indiana': 0.032,
      'Iowa': 0.06,
      'Kansas': 0.065,
      'Kentucky': 0.05,
      'Louisiana': 0.05,
      'Maine': 0.085,
      'Maryland': 0.06,
      'Massachusetts': 0.05,
      'Michigan': 0.045,
      'Minnesota': 0.075,
      'Mississippi': 0.05,
      'Missouri': 0.055,
      'Montana': 0.068,
      'Nebraska': 0.067,
      'New Hampshire': 0.0,
      'New Jersey': 0.085,
      'New Mexico': 0.047,
      'North Carolina': 0.05,
      'North Dakota': 0.025,
      'Ohio': 0.05,
      'Oklahoma': 0.05,
      'Pennsylvania': 0.03,
      'Rhode Island': 0.068,
      'South Carolina': 0.07,
      'South Dakota': 0.0,
      'Tennessee': 0.0,
      'Utah': 0.05,
      'Vermont': 0.085,
      'Virginia': 0.05,
      'West Virginia': 0.065,
      'Wisconsin': 0.065,
    };

    return stateTaxRates[state] ?? 0.05; // Default to 5% if state not found
  }

  void _calculateTaxes() {
    if (incomeController.text.isEmpty &&
        dependentsController.text.isEmpty &&
        taxesPaidController.text.isEmpty &&
        selectedState == null &&
        selectedCountry == null &&
        (maritalStatus == null ||
            (maritalStatus == 'Married' && filingStatus == null))) {
      _showError('Please complete all required fields.');
      return;
    }

    final incomeText = incomeController.text.replaceAll(',', '').trim();
    final income = double.tryParse(incomeText);
    final dependentsText = dependentsController.text.trim();
    final dependents = int.tryParse(dependentsText);
    final taxesPaidText = taxesPaidController.text.replaceAll(',', '').trim();
    final taxesPaid = double.tryParse(taxesPaidText);

    if (income == null) {
      _showError('Please enter a valid value for income.');
      return;
    }

    if (maritalStatus == null) {
      _showError('Please select a value for marital status.');
      return;
    }

    if (maritalStatus == 'Married' && filingStatus == null) {
      _showError('Please select your filing status.');
      return;
    }

    if (dependents == null) {
      _showError('Please enter valid number of dependents.');
      return;
    }

    if (selectedState == null) {
      _showError('Please select your state of residence.');
      return;
    }

    if (selectedCountry == null) {
      _showError('Please select your country of origin.');
      return;
    }

    if (taxesPaid == null) {
      _showError('Please enter a valid value for taxes paid.');
      return;
    }

    if (taxesPaid > income) {
      _showError('Taxes paid cannot exceed income.');
      return;
    }

    if (taxesPaid == income) {
      _showError('Taxes paid cannot be equal to income.');
      return;
    }

    double federalTax = 0;
    double stateTax = 0;

    // Determine Federal Tax based on income and marital status
    if (maritalStatus == 'Single') {
      if (income <= 9875) {
        federalTax = income * 0.1;
      } else if (income <= 40125) {
        federalTax = 987.5 + (income - 9875) * 0.12;
      } else if (income <= 85525) {
        federalTax = 4617.5 + (income - 40125) * 0.22;
      } else {
        federalTax = 14605.5 + (income - 85525) * 0.24;
      }
    } else if (maritalStatus == 'Married') {
      if (filingStatus == 'Filing Jointly') {
        if (income <= 19900) {
          federalTax = income * 0.1;
        } else if (income <= 80250) {
          federalTax = 1990 + (income - 19900) * 0.12;
        } else if (income <= 171050) {
          federalTax = 9230 + (income - 80250) * 0.22;
        } else {
          federalTax = 29211 + (income - 171050) * 0.24;
        }
      } else {
        // Filing Separately
        if (income <= 9950) {
          federalTax = income * 0.1;
        } else if (income <= 40125) {
          federalTax = 995 + (income - 9950) * 0.12;
        } else if (income <= 85525) {
          federalTax = 4617.5 + (income - 40125) * 0.22;
        } else {
          federalTax = 14605.5 + (income - 85525) * 0.24;
        }
      }
    }

    // Deduct dependents (assuming $2000 per dependent)
    double dependentRelief = dependents * 2000;
    federalTax -= dependentRelief;
    federalTax = federalTax < 0 ? 0 : federalTax;

    // Get state tax rate from selected state
    stateTax = income * _getStateTaxRate(selectedState!);

    // Apply tax treaty benefit based on selected country
    double taxTreatyBenefit = _getTaxTreatyBenefit(selectedCountry!);

    // Calculate total tax: Federal + State - Tax Treaty Benefit
    double totalTax = federalTax + stateTax - taxTreatyBenefit;

    // Calculate taxes owed or return
    double taxesOwedOrRefund = taxesPaid - totalTax;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaxResultsPage(
          federalTax: federalTax,
          stateTax: stateTax,
          taxTreatyBenefit: taxTreatyBenefit,
          totalTax: totalTax,
          taxesPaid: taxesPaid,
          taxesOwedOrRefund: taxesOwedOrRefund,
          dependentRelief: dependentRelief,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sort the states and countries alphabetically
    states.sort();
    countries.sort();

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
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 10.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/tax.png',
                  height: 150,
                  width: 150,
                ),
                Header(text: 'Calculate Your Taxes'),
                const SizedBox(height: 20),

                QuestionRow(
                    question: 'What is your income?',
                    title: "Income Information",
                    message:
                        "Please input your total annual income before any deductions."),
                InputTextField(
                    controller: incomeController,
                    icon: FontAwesomeIcons.dollarSign),

                const SizedBox(height: 30),

                QuestionRow(
                    question: 'What is your marital status?',
                    title: "Marital Status Information",
                    message: "Please select your marital status."),
                _buildMaritalStatusRadio(),

                // Display filing status only if the user selects 'Married'
                if (maritalStatus == 'Married') ...[
                  const SizedBox(height: 30),
                  QuestionRow(
                      question: 'What is your filing status?',
                      title: "Filing Status Information",
                      message: "Please select your filing status."),
                  _buildFilingStatusSelection(),
                ],

                const SizedBox(height: 30),

                QuestionRow(
                    question: 'How many dependents do you have?',
                    title: "Dependents Information",
                    message:
                        "Please enter the number of dependents you are financially responsible for. \"Dependents\" are your children and elderly parents you are financially responsible for."),
                InputTextField(
                    controller: dependentsController,
                    icon: FontAwesomeIcons.peopleGroup),

                const SizedBox(height: 30),

                QuestionRow(
                    question: 'What state do you currently live in?',
                    title: "State Selection",
                    message:
                        "Please select your state of residence. This is used to calculate your state tax, if applicable for your state of residence."),
                CustomDropdownMenu(
                    items: states,
                    selectedValue: selectedState,
                    onChanged: (value) {
                      setState(() => selectedState = value);
                    }),

                const SizedBox(height: 30),

                QuestionRow(
                    question: 'What country are you from?',
                    title: "Country Selection",
                    message:
                        "Please select your country of citizenship. This is used to check for any Tax Treaties between your home country and the United States that you could potentially use to reduce your taxes."),
                CustomDropdownMenu(
                    items: countries,
                    selectedValue: selectedCountry,
                    onChanged: (value) {
                      setState(() => selectedCountry = value);
                    }),

                const SizedBox(height: 40),

                QuestionRow(
                    question: 'How much did you pay in taxes?',
                    title: "Taxes Paid",
                    message:
                        "Please input the total taxes you've paid out of your paychecks. This information is available in your W-2 Form(s)."),
                InputTextField(
                    controller: taxesPaidController,
                    icon: FontAwesomeIcons.creditCard),

                const SizedBox(height: 40),

                /// Submit Button with Gradient
                GestureDetector(
                  onTap: _calculateTaxes,
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to build marital status radio buttons
  Widget _buildMaritalStatusRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['Single', 'Married']
          .map((status) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Radio<String>(
                      value: status,
                      groupValue: maritalStatus,
                      onChanged: (String? newValue) {
                        setState(() {
                          maritalStatus = newValue;
                          filingStatus =
                              null; // Reset filing status when marital status changes
                        });
                      },
                    ),
                    Text(status, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ))
          .toList(),
    );
  }

  /// Helper method to display filing status selection if married
  Widget _buildFilingStatusSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<String>(
          value: 'Filing Jointly',
          groupValue: filingStatus,
          onChanged: (String? newValue) {
            setState(() {
              filingStatus = newValue;
            });
          },
        ),
        const Text('Filing Jointly', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 20),
        Radio<String>(
          value: 'Filing Separately',
          groupValue: filingStatus,
          onChanged: (String? newValue) {
            setState(() {
              filingStatus = newValue;
            });
          },
        ),
        const Text('Filing Separately', style: TextStyle(fontSize: 16)),
      ],
    );
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
              Image.asset('assets/tax_info_page.png', height: 200, width: 200),
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
                          'The tax values and calculations displayed are based on dummy data and are not representative of actual tax calculations. The numbers provided are for demonstration purposes only.',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              Text('What Are Taxes and Why Do I Need To Pay Taxes?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              Text(
                  'A Tax is a mandatory financial charge or levy imposed on an individual or legal entity by a governmental organization to support government spending and public expenditures collectively or to regulate and reduce negative externalities.\n\nTax Compliance refers to policy actions and individual behavior aimed at ensuring that taxpayers are paying the right amount of tax at the right time and securing the correct tax allowances and tax relief.'),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () =>
                    launchURL('https://www.irs.gov/pub/irs-pdf/p2105.pdf'),
                child: const Text(
                  'Why Do I Have To File Taxes?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(
                  'Want to Learn More About Taxes? Have Questions About Your Taxes?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              InkWell(
                onTap: () =>
                    launchURL('https://www.youtube.com/watch?v=8YeU1gbuR9g'),
                child: const Text(
                  'Basics of Tax Preparation',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.irs.gov/how-to-file-your-taxes-step-by-step'),
                child: const Text(
                  'How to file your taxes - Step by Step Instructions',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.consumerfinance.gov/consumer-tools/guide-to-filing-your-taxes/'),
                child: const Text(
                  'Guide to Filing Your Taxes',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.irs.gov/individuals/tax-withholding-estimator'),
                child: const Text(
                  'Tax Withholding Estimation',
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
                      text:
                          'For more detailed information, refer to the official ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'IRS website',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchURL('https://www.irs.gov/'),
                    ),
                    const TextSpan(
                      text: '.',
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
