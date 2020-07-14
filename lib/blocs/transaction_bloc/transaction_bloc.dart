import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghazi_pos/api/api.dart';
import 'package:ghazi_pos/blocs/transaction_bloc/transaction_event.dart';
import 'package:ghazi_pos/blocs/transaction_bloc/transaction_state.dart';
import 'package:ghazi_pos/models/transactions.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  
  final Api services = new Api();
  int _counter = 0;

  TransactionBloc() : super(TransactionUninitializedState());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is GetTransactionEvent) {
      List<TransactionModel> data = await services.getTransactions();

      if (data.length > 0) {
        yield TransactionInitiliazedState(
          data: data, 
          counter: _counter++
        );
      } else {
        yield TransactionEmptyState();
      }
    } else if (event is DeleteTransactionEvent) {
      yield TransactionUninitializedState();
      await services.deleteTransations(transactionId: event.transactionId);
      add(GetTransactionEvent());
    }
  }

}