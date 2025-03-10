part of 'create_expense_bloc.dart';

sealed class CreateExpenseEvent extends Equatable {
  const CreateExpenseEvent();

  @override
  List<Object> get props => [];
}

class CreateExpense extends CreateExpenseEvent {
  final FinancialTransaction transaction;

  const CreateExpense(this.transaction);

  @override
  List<Object> get props => [transaction];
}
