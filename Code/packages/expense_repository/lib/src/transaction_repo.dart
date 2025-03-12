import 'models/models.dart';

abstract class TransactionRepository {
  Future<bool> createCategory(Category category);
  Stream<List<Category>> getCategories();
  Future<bool> createTransaction(FinancialTransaction transaction);
  Stream<List<FinancialTransaction>> getTransactions();
}
