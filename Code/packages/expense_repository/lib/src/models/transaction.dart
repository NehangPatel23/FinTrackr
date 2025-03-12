import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/entities.dart';
import 'category.dart';

enum TransactionType { income, expense }

class FinancialTransaction {
  String transactionId;
  Category category;
  Timestamp date;
  int amount;
  TransactionType type;

  FinancialTransaction({
    required this.transactionId,
    required this.category,
    required this.date,
    required this.amount,
    required this.type,
  });

  static final empty = FinancialTransaction(
    transactionId: '',
    category: Category.empty,
    date: Timestamp.now(),
    amount: 0,
    type: TransactionType.expense, // Default type
  );

  TransactionEntity toEntity() {
    return TransactionEntity(
      transactionId: transactionId,
      category: category,
      date: date,
      amount: amount,
      type: type,
    );
  }

  static FinancialTransaction fromEntity(TransactionEntity entity) {
    return FinancialTransaction(
      transactionId: entity.transactionId,
      category: entity.category,
      date: entity.date,
      amount: entity.amount,
      type: entity.type,
    );
  }
}
