import 'info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class QuestionRow extends StatelessWidget {
  final String question;
  final String title;
  final String message;

  const QuestionRow(
      {super.key,
      required this.question,
      required this.title,
      required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(question,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        IconButton(
          icon: Icon(FontAwesomeIcons.circleInfo,
              size: 15, color: Colors.blue.shade700),
          onPressed: () => showDialog(
              context: context,
              builder: (context) => InfoDialog(title: title, message: message)),
        ),
      ],
    );
  }
}
