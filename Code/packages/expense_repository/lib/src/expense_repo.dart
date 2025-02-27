import 'models/models.dart';

abstract class ExpenseRepository {
  Future<bool> createCategory(Category category);

  Stream<List<Category>> getCategories();

  Future<bool> createExpense(Expense expense);

  Stream<List<Expense>> getExpenses();
}
