import 'package:expense_repository/expense_repository.dart';
import 'package:fintrackr/screens/ui_elements/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import '../../ui_elements/text_field.dart';
import '../blocs/create_expense/create_expense_bloc.dart';
import '../blocs/get_categories/get_categories_bloc.dart';
import 'category_creation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String OCRApiKey = 'K84027267088957';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController expenseController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TransactionType _transactionType = TransactionType.expense;
  late FinancialTransaction transaction;
  bool isLoading = false;
  File? selectedImage;

  @override
  void initState() {
    dateController.text = DateFormat('MM/dd/yyyy').format(DateTime.now());
    transaction = FinancialTransaction.empty;
    transaction.transactionId = const Uuid().v1();
    super.initState();
  }

  Future<void> pickAndProcessImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      File imageFile = File(result.files.single.path!);
      setState(() => selectedImage = imageFile);
      await extractTextFromImage(imageFile);
    } else {
      showError('No image selected.');
    }
  }

  Future<void> extractTextFromImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://api.ocr.space/parse/image'));
      request.headers['apikey'] = OCRApiKey;
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));
      request.fields['language'] = 'eng';
      request.fields['isOverlayRequired'] = 'false';

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);

        if (jsonResponse['ParsedResults'] != null &&
            jsonResponse['ParsedResults'].isNotEmpty &&
            jsonResponse['ParsedResults'][0]['ParsedText'] != null) {
          String extractedText =
              jsonResponse['ParsedResults'][0]['ParsedText'].trim();

          if (extractedText.isEmpty) {
            showError('No text detected in the image.');
            return;
          }

          print('Extracted Text:\n$extractedText');
          extractAmountFromText(extractedText);
        } else {
          showError('No text detected in the image.');
        }
      } else {
        showError('OCR API failed: ${response.statusCode}');
      }
    } catch (e) {
      showError('Error during OCR processing: $e');
    }
  }

  void extractAmountFromText(String text) {
    text = text.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
    print('Processed Text:\n$text');

    if (text.contains('total')) {
      int totalIndex = text.indexOf('total');
      String remainingText = text.substring(totalIndex);

      RegExp amountRegex = RegExp(r'[\$]?\s*(\d{1,3}(?:,\d{3})*(?:\.\d{2})?)',
          caseSensitive: false);
      Match? match = amountRegex.firstMatch(remainingText);

      if (match != null) {
        String extractedAmount = match.group(1)!;
        double amount = double.tryParse(
                extractedAmount.replaceAll(',', '').replaceAll('\$', '')) ??
            0.0;

        int roundedAmount = amount.ceil();

        setState(() {
          expenseController.text = roundedAmount.toString();
        });
      }
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          Navigator.pop(context, transaction);
        } else if (state is CreateExpenseLoading) {
          isLoading = true;
        } else {
          const Center(
            child: Text('An Error Occurred!'),
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/expenses-removebg-preview.png',
                        height: 150,
                        width: 200,
                      ),
                      Header(text: 'Add Transaction'),
                      const SizedBox(height: 16),

                      // Transaction Input with OCR Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: InputTextField(
                                  controller: expenseController,
                                  icon: FontAwesomeIcons.dollarSign)),
                          const SizedBox(width: 10),

                          // OCR Button (Processes Asset Image)
                          IconButton(
                            onPressed: () => pickAndProcessImage(),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            icon: Icon(CupertinoIcons.camera),
                            color: Colors.black,
                          ),

                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: categoryController,
                        readOnly: true,
                        onTap: () {},
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: transaction.category == Category.empty
                                ? Colors.white
                                : Color(transaction.category.color),
                            hintText: 'Category',
                            prefixIcon: transaction.category == Category.empty
                                ? const Icon(
                                    FontAwesomeIcons.list,
                                    size: 16,
                                    color: Colors.grey,
                                  )
                                : Image.asset(
                                    'assets/${transaction.category.icon}.png',
                                    scale: 2,
                                  ),
                            suffixIcon: IconButton(
                              icon: const Icon(FontAwesomeIcons.plus),
                              color: Colors.grey.shade500,
                              iconSize: 16,
                              onPressed: () async {
                                var newCategory =
                                    await getCategoryCreation(context);
                                setState(() {
                                  state.categories.insert(0, newCategory);
                                });
                              },
                            ),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(12)),
                                borderSide: BorderSide.none)),
                      ),
                      Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: state.categories.length,
                            itemBuilder: (context, int i) {
                              return Card(
                                  child: ListTile(
                                onTap: () {
                                  setState(() {
                                    transaction.category = state.categories[i];
                                    categoryController.text =
                                        transaction.category.name;
                                  });
                                },
                                leading: Image.asset(
                                    'assets/${state.categories[i].icon}.png',
                                    scale: 2),
                                title: Text(state.categories[i].name),
                                tileColor: Color(state.categories[i].color),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ));
                            },
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Text('Transaction Type: ',
                              style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 10),
                          DropdownButton<TransactionType>(
                            value: _transactionType,
                            onChanged: (TransactionType? newValue) {
                              setState(() {
                                _transactionType = newValue!;
                              });
                            },
                            items: TransactionType.values
                                .map((TransactionType type) {
                              return DropdownMenuItem<TransactionType>(
                                value: type,
                                child: Text(type == TransactionType.expense
                                    ? "Expense"
                                    : "Income"),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: dateController,
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: true,
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(0000, 01, 01),
                            lastDate: DateTime.now(),
                          );

                          if (newDate != null) {
                            setState(() {
                              dateController.text =
                                  DateFormat('MM/dd/yyyy').format(newDate);
                              transaction.date = Timestamp.fromDate(
                                  newDate); // Convert to Firestore Timestamp
                            });
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Date',
                          prefixIcon: Icon(FontAwesomeIcons.clock,
                              size: 18, color: Colors.grey.shade500),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                      SizedBox(
                        width: 200,
                        height: kToolbarHeight,
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : GestureDetector(
                                onTap: () {
                                  setState(() {
                                    transaction.amount = int.parse(
                                        expenseController.text
                                            .replaceAll(',', ''));
                                  });
                                  transaction.category.totalExpenses =
                                      (transaction.category.totalExpenses) +
                                          transaction.amount;

                                  context
                                      .read<CreateExpenseBloc>()
                                      .add(CreateExpense(transaction));
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
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
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
