import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> transactionsData = [
  {
    'icon': FontAwesomeIcons.burger,
    'color': Colors.yellow.shade700,
    'name': 'Food',
    'amount': '-\$45.00',
    'date': 'Today'
  },
  {
    'icon': FontAwesomeIcons.bagShopping,
    'color': Colors.purpleAccent,
    'name': 'Shopping',
    'amount': '-\$280.60',
    'date': 'Today'
  },
  {
    'icon': FontAwesomeIcons.heartCircleCheck,
    'color': Colors.greenAccent,
    'name': 'Health & Wellness',
    'amount': '-\$100.45',
    'date': 'Yesterday'
  },
  {
    'icon': FontAwesomeIcons.plane,
    'color': Colors.blueAccent,
    'name': 'Travel',
    'amount': '-\$560.95',
    'date': 'Yesterday'
  },
  {
    'icon': FontAwesomeIcons.ticket,
    'color': Colors.redAccent,
    'name': 'Entertainment',
    'amount': '-\$35.99',
    'date': 'Wednesday'
  },
];
