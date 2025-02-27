import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final FirebaseFirestore _firestore;

  FirebaseExpenseRepo({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Expense>> getExpenses() {
    return _firestore.collection('expenses').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Expense.fromEntity(ExpenseEntity.fromDocument(doc.data()));
      }).toList();
    });
  }



  @override
  Future<bool> createExpense(Expense expense) async {
    try {
      await _firestore
          .collection('expenses')
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument());
      log("Expense added successfully: ${expense.expenseId}");
      return true;
    } catch (e) {
      log("Error in createExpense: $e", stackTrace: StackTrace.current);
      return false;
    }
  }

  @override
  Future<bool> createCategory(Category category) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.categoryId) // 🔹 Fixed missing property
          .set(category.toEntity().toDocument());
      log("Category added successfully: ${category.categoryId}");
      return true;
    } catch (e) {
      log("Error in createCategory: $e", stackTrace: StackTrace.current);
      return false;
    }
  }

  Stream<List<Category>> getCategories() {
    return _firestore.collection('categories').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Category.fromEntity(CategoryEntity.fromDocument(doc.data()));
      }).toList();
    });
  }



  Future<void> deleteExpense(String expenseId) async {
    try {
      await _firestore.collection('expenses').doc(expenseId).delete();
      log("Expense deleted: $expenseId");
    } catch (e) {
      log("Error in deleteExpense: $e", stackTrace: StackTrace.current);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _firestore
          .collection('expenses')
          .doc(expense.expenseId)
          .update(expense.toEntity().toDocument());
      log("Expense updated: ${expense.expenseId}");
    } catch (e) {
      log("Error in updateExpense: $e", stackTrace: StackTrace.current);
    }
  }
}
