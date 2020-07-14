import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_bloc.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_event.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_state.dart';
import 'package:ghazi_pos/pages/items/create_edit_items.dart';
import 'package:ghazi_pos/widgets/item.dart';

import '../../models/items.dart';
import '../../models/items.dart';

class Items extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ItemsState();
  }
}

class _ItemsState extends State<Items> {

  ItemBloc _itemBloc;

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (BuildContext context) => BlocProvider.value(
                value: _itemBloc,
                child: CreateEditItems(
                  create: true
                ),
              )
            )
          );
        },
        tooltip: 'Tambah Item',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget itemContainer(ItemsModel data) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) => BlocProvider.value(
              value: _itemBloc,
              child: CreateEditItems(
                create: false,
                data: data,
              ),
            )
          )
        );
      },
      onLongPress: () {
        _showDeleteDialog(data);
      },
      child: Item(data: data)
    );
  }

  void _showDeleteDialog(ItemsModel data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(data.itemName),
          content: Text("Apakah anda yakin ingin menghapus barang ini?"),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: Text("Tidak")
            ),
            new FlatButton(
              onPressed: () {
                _itemBloc..add(DeleteItemEvent(itemId: data.id));
                Navigator.pop(context);
              }, 
              child: Text("Ya")
            ),
          ],
        );
      },
    );
  }
} 