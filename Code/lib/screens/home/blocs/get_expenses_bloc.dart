import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_expenses_event.dart';
part 'get_expenses_state.dart';

class GetExpensesBloc extends Bloc<GetExpensesEvent, GetExpensesState> {
  final ExpenseRepository expenseRepository;

  GetExpensesBloc(this.expenseRepository) : super(GetExpensesInitial()) {
    on<GetExpenses>((event, emit) async {
      emit(GetExpensesLoading());
      try {
        await emit.forEach<List<Expense>>(
          expenseRepository.getExpenses(), // Now listening to the stream
          onData: (expenses) => GetExpensesSuccess(expenses),
          onError: (_, __) => GetExpensesFailure(),
        );
      } catch (e) {
        emit(GetExpensesFailure());
      }
    });
  }
}
