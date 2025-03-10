import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';

class FirebaseTransactionRepo implements TransactionRepository {
  final FirebaseFirestore _firestore;

  FirebaseTransactionRepo({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<FinancialTransaction>> getTransactions() {
    return _firestore
        .collection('transactions')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return FinancialTransaction.fromEntity(
            TransactionEntity.fromDocument(doc.data()));
      }).toList();
    });
  }

  @override
  Future<bool> createTransaction(FinancialTransaction transaction) async {
    try {
      await _firestore
          .collection('transactions')
          .doc(transaction.transactionId)
          .set(transaction.toEntity().toDocument());
      log("Transaction added successfully: ${transaction.transactionId}");
      return true;
    } catch (e) {
      log("Error in createTransaction: $e", stackTrace: StackTrace.current);
      return false;
    }
  }

  @override
  Future<bool> createCategory(Category category) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
      log("Category added successfully: ${category.categoryId}");
      return true;
    } catch (e) {
      log("Error in createCategory: $e", stackTrace: StackTrace.current);
      return false;
    }
  }

  @override
  Stream<List<Category>> getCategories() {
    return _firestore.collection('categories').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Category.fromEntity(CategoryEntity.fromDocument(doc.data()));
      }).toList();
    });
  }

  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).delete();
      log("Transaction deleted: $transactionId");
    } catch (e) {
      log("Error in deleteTransaction: $e", stackTrace: StackTrace.current);
    }
  }

  Future<void> updateTransaction(FinancialTransaction transaction) async {
    try {
      await _firestore
          .collection('transactions')
          .doc(transaction.transactionId)
          .update(transaction.toEntity().toDocument());
      log("Transaction updated: ${transaction.transactionId}");
    } catch (e) {
      log("Error in updateTransaction: $e", stackTrace: StackTrace.current);
    }
  }
}
