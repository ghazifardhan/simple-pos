import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghazi_pos/api/api.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_event.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_state.dart';
import 'package:ghazi_pos/models/items.dart';
import 'package:ghazi_pos/models/transactions.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  
  final Api services = new Api();
  int _counter = 0;

  ItemBloc() : super(ItemUninitializedState());

  @override
  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is GetItemEvent) {
      List<ItemsModel> data = await services.getItems();

      if (data.length > 0) {
        yield ItemInitiliazedState(
          data: data, 
          counter: _counter++
        );
      } else {
        yield ItemEmptyState();
      }
    } else if (event is PostItemEvent) {
      
      yield ItemPostLoadingState();
      ItemsModel data;

      if (event.create) {
        data = await services.postItems(
          itemName: event.itemName,
          itemPrice: event.itemPrice,
          photoUrl: event.photoUrl
        );
      } else {
        data = await services.putItems(
          itemName: event.itemName,
          itemPrice: event.itemPrice,
          photoUrl: event.photoUrl,
          itemId: event.itemId
        );
      }
      

      if (data != null) {
        yield ItemPostDoneState();
      }
    } else if (event is DeleteItemEvent) {
      yield ItemUninitializedState();
      await services.deleteItems(itemId: event.itemId);
      add(GetItemEvent());
    } else if (event is AddItemQtyEvent) {
      var currentState = (state as ItemInitiliazedState);

      currentState.data.firstWhere(
        (element) => element.id == event.itemId,
        orElse: () => null
      ).qty += 1;

      yield (state as ItemInitiliazedState).copyWith(
        data: currentState.data,
        counter: _counter++
      );
      return;
    } else if (event is RemoveItemQtyEvent) {
      var currentState = (state as ItemInitiliazedState);

      currentState.data.firstWhere(
        (element) => element.id == event.itemId,
        orElse: () => null
      ).qty -= 1;

      yield (state as ItemInitiliazedState).copyWith(
        data: currentState.data,
        counter: _counter++
      );
      return;
    } else if (event is PostTransactionEvent) {
      var currentState = (state as ItemInitiliazedState);

      List<ItemsModel> d = currentState.data.where(
        (element) => element.qty > 0
      ).toList();

      var transactionDate = DateTime.now().millisecondsSinceEpoch;
      TransactionModel tm = new TransactionModel();
      List<TransactionsDetail> td = new List<TransactionsDetail>();

      d.forEach((element) { 
        td.add(TransactionsDetail(
          itemId: element.id,
          itemName: element.itemName,
          itemPrice: element.itemPrice,
          photoUrl: element.photoUrl,
          quantity: element.qty,
          total: element.qty * element.itemPrice
        ));
      });

      tm.id = 0;
      tm.transactionDate = transactionDate;
      tm.transactionsDetails = td;

      yield ItemUninitializedState();
      await services.postTransactions(model: tm);
      add(GetItemEvent());
    }
  }

}