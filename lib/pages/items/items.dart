import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_bloc.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_event.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_state.dart';
import 'package:ghazi_pos/pages/items/create_edit_items.dart';

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
          child: BlocBuilder<ItemBloc, ItemState>(
            builder: (context, state) {
              if (state is ItemUninitializedState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ItemInitiliazedState) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.separated(
                    itemCount: state.data.length, 
                    separatorBuilder: (BuildContext context, int index) { 
                      return SizedBox(height: 10.0);
                    },
                    itemBuilder: (BuildContext context, int index) {  
                      return Material(
                        elevation: 1.0,
                        borderRadius: BorderRadius.circular(5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffe8e8e8),
                            borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  topLeft: Radius.circular(5.0)
                                ),
                                child: Image.network(
                                  "https://cdns.klimg.com/merdeka.com/i/w/news/2019/03/01/1056184/540x270/cara-sederhana-menanam-bawang-merah-di-rumah.jpg",
                                  width: 75,
                                  height: 75,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                ),
                              ),
                              SizedBox(width: 5.0,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        state.data[index].itemName,
                                      ),
                                      Text(
                                        "${itemPrice(state.data[index].itemPrice)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }, 
                  ),
                );
              }
              return Text("Kosong");
            },
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

  String itemPrice(int itemPrice) {
    FlutterMoneyFormatter fmf = FlutterMoneyFormatter(
        amount: itemPrice.toDouble(),
        settings: MoneyFormatterSettings(
          symbol: 'Rp',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: ' ',
          fractionDigits: 0,
        )
    );

    return fmf.output.symbolOnLeft.toString();
  }
}