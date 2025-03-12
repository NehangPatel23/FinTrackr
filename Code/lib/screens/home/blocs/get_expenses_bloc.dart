import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_expenses_event.dart';
part 'get_expenses_state.dart';

class GetExpensesBloc extends Bloc<GetExpensesEvent, GetExpensesState> {
  final TransactionRepository transactionRepository;

  GetExpensesBloc(this.transactionRepository) : super(GetExpensesInitial()) {
    on<GetExpenses>((event, emit) async {
      emit(GetExpensesLoading());
      try {
        await emit.forEach<List<FinancialTransaction>>(
          transactionRepository
              .getTransactions(),
          onData: (transactions) => GetExpensesSuccess(transactions),
          onError: (_, __) => GetExpensesFailure(),
        );
      } catch (e) {
        emit(GetExpensesFailure());
      }
    });
  }
}
