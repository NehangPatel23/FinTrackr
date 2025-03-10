import 'package:cloud_firestore/cloud_firestore.dart';
import 'entities.dart';
import '../models/models.dart';

class TransactionEntity {
  String transactionId;
  Category category;
  Timestamp date;
  int amount;
  TransactionType type; // New field

  TransactionEntity({
    required this.transactionId,
    required this.category,
    required this.date,
    required this.amount,
    required this.type,
  });

  Map<String, Object?> toDocument() {
    return {
      'transactionId': transactionId,
      'category': category.toEntity().toDocument(),
      'date': date,
      'amount': amount,
      'type': type.toString().split('.').last, // Store as String in Firestore
    };
  }

  static TransactionEntity fromDocument(Map<String, dynamic> doc) {
    return TransactionEntity(
      transactionId: doc['transactionId'],
      category:
          Category.fromEntity(CategoryEntity.fromDocument(doc['category'])),
      date: (doc['date'] as Timestamp),
      amount: doc['amount'],
      type: TransactionType.values.firstWhere(
          (e) => e.toString().split('.').last == doc['type'],
          orElse: () => TransactionType.expense), // Default to expense
    );
  }
}
