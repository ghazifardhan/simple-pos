import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghazi_pos/api/api.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_event.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_state.dart';
import 'package:ghazi_pos/models/items.dart';

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
print("asdasds ddddd");
      ItemsModel data = await services.postItems(
        itemName: event.itemName,
        itemPrice: event.itemPrice,
        photoUrl: event.photoUrl
      );

      

      if (data != null) {
        yield ItemPostDoneState();
      }
    }
  }

}