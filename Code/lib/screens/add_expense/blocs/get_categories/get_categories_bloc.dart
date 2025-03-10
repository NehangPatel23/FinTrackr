import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  final TransactionRepository transactionRepository;

  GetCategoriesBloc(this.transactionRepository) : super(GetCategoriesInitial()) {
    on<GetCategories>((event, emit) async {
      emit(GetCategoriesLoading());
      try {
        await emit.forEach<List<Category>>(
          transactionRepository.getCategories(), // Now listening to the stream
          onData: (categories) => GetCategoriesSuccess(categories),
          onError: (_, __) => GetCategoriesFailure(),
        );
      } catch (e) {
        emit(GetCategoriesFailure());
      }
    });
  }
}
