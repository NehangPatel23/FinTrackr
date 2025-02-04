import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TaxesPage extends StatefulWidget {
  const TaxesPage({super.key});

  @override
  State<TaxesPage> createState() => _TaxesPageState();
}

class _TaxesPageState extends State<TaxesPage> {
  TextEditingController incomeController = TextEditingController();
  TextEditingController dependentsController = TextEditingController();
  String? selectedState;
  String? selectedCountry;
  String? maritalStatus;

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

  void _showInfoDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Got it"),
          ),
        ],
      ),
    );
  }

  void _showCalculateTaxesPopup() {
    _showInfoDialog(
        "Calculation", "Tax calculation logic will be implemented here.");
  }

  @override
  Widget build(BuildContext context) {
    // Sort the states and countries alphabetically
    states.sort();
    countries.sort();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
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

                const SizedBox(height: 30),

                _buildQuestionRow(
                    'How many dependents do you have?',
                    "Dependents Information",
                    "Please enter the number of dependents you are financially responsible for."),
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
      ),
    );
  }

  /// Helper method to build marital status radio buttons
  Widget _buildMaritalStatusRadio() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ['Single', 'Married', 'Divorced']
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
