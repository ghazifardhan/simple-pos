import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghazi_pos/widgets/item.dart';

import '../../blocs/item_bloc/item_bloc.dart';
import '../../blocs/item_bloc/item_event.dart';
import '../../blocs/item_bloc/item_state.dart';
import '../../blocs/item_bloc/item_state.dart';
import '../../models/items.dart';
import '../items/create_edit_items.dart';

class Sales extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SalesState();
  }
}

class _SalesState extends State<Sales> {

  ItemBloc _itemBloc;
  bool cart = false;

  @override
  void initState() {
    super.initState();

    _itemBloc = new ItemBloc();
    _itemBloc..add(GetItemEvent());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocProvider<ItemBloc>(
          create: (context) => _itemBloc,
          child: BlocListener<ItemBloc, ItemState>(
            listener: (context, state) {
              if (state is ItemPostDoneState) {
                _itemBloc..add(GetItemEvent());
              } else if (state is ItemInitiliazedState) {
                var data = state.data.firstWhere(
                  (element) => element.qty > 0,
                  orElse: () => null
                );
                if (data != null) {
                  setState(() {
                    cart = true;
                  });
                } else {
                  setState(() {
                    cart = false;
                  });
                }
              }
            },
            child: BlocBuilder<ItemBloc, ItemState>(
              builder: (context, state) {
                if (state is ItemUninitializedState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ItemInitiliazedState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(Duration(seconds: 1), () {
                          _itemBloc..add(GetItemEvent());
                        });
                      },
                      child: Stack(
                        children: <Widget>[
                          ListView(
                            children: <Widget>[
                              Text("")
                            ],
                          ),

                          ListView(
                            physics: AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: <Widget>[
                              SizedBox(height: 20.0),
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: state.data.length, 
                                separatorBuilder: (BuildContext context, int index) { 
                                  return SizedBox(height: 10.0);
                                },
                                itemBuilder: (BuildContext context, int index) {  
                                  return itemContainer(state.data[index]);
                                }, 
                              ),
                              SizedBox(height: 20.0),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return Text("Kosong");
              },
            ),
          ),
        ),
      ),
      floatingActionButton: cart ? FloatingActionButton(
        onPressed: () {
          _itemBloc..add(PostTransactionEvent());
        },
        tooltip: 'Selesai',
        child: Icon(Icons.done_all),
      ) : Container()
    );
  }

  Widget itemContainer(ItemsModel data) {
    return Column(
      children: <Widget>[
        Item(data: data),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
              onPressed: () {
                if (data.qty > 0) {
                  _itemBloc..add(RemoveItemQtyEvent(itemId: data.id));
                }
              },
            ),
            SizedBox(width: 10.0,),
            Text(data.qty.toString()),
            SizedBox(width: 10.0,),
            IconButton(
              icon: Icon(
                Icons.add_circle,
                color: Colors.green,
              ),
              onPressed: () {
                _itemBloc..add(AddItemQtyEvent(itemId: data.id));
              },
            ),
          ],
        ),
      ],
    );
  }
}