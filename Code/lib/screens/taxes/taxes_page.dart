import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

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

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      'Got it!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCalculateTaxesPopup() {
    final income =
        double.tryParse(incomeController.text.replaceAll(',', '')) ?? 0.0;
    final dependents = int.tryParse(dependentsController.text) ?? 0;
    final taxesPaid =
        double.tryParse(taxesPaidController.text.replaceAll(',', '')) ?? 0.0;

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

    // Formatting for better clarity
    final formattedFederalTax = NumberFormat('#,###').format(federalTax);
    final formattedStateTax = NumberFormat('#,###').format(stateTax);
    final formattedTotalTax = NumberFormat('#,###').format(totalTax);
    final formattedTaxesPaid = NumberFormat('#,###').format(taxesPaid);
    final formattedTaxesOwedOrRefund =
        NumberFormat('#,###').format(taxesOwedOrRefund.abs());

    // Create the tax details message
    String taxDetails = "Your estimated federal tax is \$$formattedFederalTax\n"
        "Your estimated state tax is \$$formattedStateTax\n";

    // Add tax relief details if applicable
    if (dependentRelief > 0) {
      taxDetails +=
          "\nTax relief from dependents: \$${NumberFormat('#,###').format(dependentRelief)}";
    }
    if (taxTreatyBenefit > 0) {
      taxDetails +=
          "\nTax relief from tax treaty: \$${NumberFormat('#,###').format(taxTreatyBenefit)}";
    }

    taxDetails += "\n\nYour total estimated tax is \$$formattedTotalTax";

    taxDetails += "\n\nYou have already paid \$$formattedTaxesPaid";

    // Add information about taxes owed or refund
    if (taxesOwedOrRefund < 0) {
      taxDetails += "\n\nYou owe \$$formattedTaxesOwedOrRefund in taxes.";
    } else if (taxesOwedOrRefund > 0) {
      taxDetails +=
          "\n\nYou are due a refund of \$$formattedTaxesOwedOrRefund.";
    } else {
      taxDetails += "\n\nYour taxes are perfectly balanced!";
    }

    // Show the dialog with the tax details and pie chart
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tax Calculation Breakdown",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                taxDetails,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      'Got it!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/tax.png',
                  height: 150,
                  width: 150,
                ),
                const Text(
                  'Calculate Your Taxes',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 32),

                _buildQuestionRow('What is your income?', "Income Information",
                    "Please input your total annual income before any deductions."),
                _buildTextField(incomeController, FontAwesomeIcons.dollarSign),

                const SizedBox(height: 30),

                _buildQuestionRow(
                    'What is your marital status?',
                    "Marital Status Information",
                    "Please select your marital status."),
                _buildMaritalStatusRadio(),

                // Display filing status only if the user selects 'Married'
                if (maritalStatus == 'Married') ...[
                  const SizedBox(height: 30),
                  _buildQuestionRow(
                      'What is your filing status?',
                      "Filing Status Information",
                      "Please select your filing status."),
                  _buildFilingStatusSelection(),
                ],

                const SizedBox(height: 30),

                _buildQuestionRow(
                    'How many dependents do you have?',
                    "Dependents Information",
                    "Please enter the number of dependents you are financially responsible for. \"Dependents\" are your children and elderly parents you are financially responsible for."),
                _buildTextField(
                    dependentsController, FontAwesomeIcons.peopleGroup),

                const SizedBox(height: 30),

                _buildQuestionRow('What state are you from?', "State Selection",
                    "Please select your state of residence."),
                _buildDropdown(states, selectedState, (value) {
                  setState(() => selectedState = value);
                }),

                const SizedBox(height: 30),

                _buildQuestionRow(
                    'What country are you from?',
                    "Country Selection",
                    "Please select your country of residence."),
                _buildDropdown(countries, selectedCountry, (value) {
                  setState(() => selectedCountry = value);
                }),

                const SizedBox(height: 40),

                _buildQuestionRow(
                    'How much did you pay in taxes?',
                    "Taxes Paid",
                    "Please input the total taxes you've paid out of your paychecks. This information is available in your W-2 Form(s)."),
                _buildTextField(
                    taxesPaidController, FontAwesomeIcons.creditCard),

                const SizedBox(height: 40),

                /// Submit Button with Gradient
                GestureDetector(
                  onTap: _showCalculateTaxesPopup,
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

  /// Helper method to build text fields
  Widget _buildTextField(TextEditingController controller, IconData icon) {
    return SizedBox(
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
        onChanged: (value) {
          final number = double.tryParse(value.replaceAll(',', ''));
          if (number != null) {
            controller.text = NumberFormat('#,###').format(number);
            controller.selection =
                TextSelection.collapsed(offset: controller.text.length);
          }
        },
      ),
    );
  }

  /// Helper method to build dropdowns
  Widget _buildDropdown(List<String> items, String? selectedValue,
      ValueChanged<String?> onChanged) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          hint: const Text("Select an option"),
          isDense: true,
          menuMaxHeight: 250,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, textAlign: TextAlign.center),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  /// Helper method to build question rows with icons
  Widget _buildQuestionRow(String question, String title, String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        IconButton(
          icon: Icon(FontAwesomeIcons.circleInfo,
              size: 15, color: Colors.blue.shade700),
          onPressed: () => _showInfoDialog(title, message),
        ),
      ],
    );
  }
}

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tax Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Disclaimer: The tax values and calculations are based on dummy data and are not representative of actual tax calculations. The numbers provided are for demonstration purposes only.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
