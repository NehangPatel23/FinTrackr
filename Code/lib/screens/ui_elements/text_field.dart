import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;

  const InputTextField({
    super.key,
    required this.controller,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
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
}
