import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:ghazi_pos/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:ghazi_pos/blocs/transaction_bloc/transaction_event.dart';
import 'package:ghazi_pos/blocs/transaction_bloc/transaction_state.dart';
import 'package:ghazi_pos/models/transactions.dart';
import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransactionsState();
  }
}

class _TransactionsState extends State<Transactions> {

  TransactionBloc _transactionBloc;

  @override
  void initState() {
    super.initState();

    _transactionBloc = new TransactionBloc();
    _transactionBloc..add(GetTransactionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocProvider<TransactionBloc>(
          create: (context) => _transactionBloc,
          child: BlocListener<TransactionBloc, TransactionState>(
            listener: (context, state) {
              
            },
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionUninitializedState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TransactionInitiliazedState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(Duration(seconds: 1), () {
                          _transactionBloc..add(GetTransactionEvent());
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
    );
  }

  Widget itemContainer(TransactionModel data) {
    var dateFormat = new DateFormat('yyyy-MM-dd hh:mm');
    var date = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(data.transactionDate));

    return GestureDetector(
      onLongPress: () {
        _showDeleteDialog(data);
      },
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color(0xffe8e8e8),
            borderRadius: BorderRadius.circular(5.0)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("ID Transaksi: ${data.id}"),
              Text("Tanggal Transaksi: $date"),
              SizedBox(height: 10.0,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    style: BorderStyle.solid,
                    width: 0.5
                  )
                ),
              ),
              SizedBox(height: 10.0,),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.transactionsDetails.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10.0,);
                }, 
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "${index+1}. ${data.transactionsDetails[index].itemName}"
                            ),
                          ),
                          Text(
                            "${data.transactionsDetails[index].quantity} @ ${itemPrice(data.transactionsDetails[index].itemPrice)}",
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      Text(
                        "${itemPrice(data.transactionsDetails[index].total)}"
                      ),
                    ],
                  );
                }, 
              ),
              SizedBox(height: 10.0,),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    style: BorderStyle.solid,
                    width: 0.5
                  )
                ),
              ),
              SizedBox(height: 10.0,),
              Row(
                children: <Widget>[
                  Expanded(child: Text("Total")),
                  Text(
                    "${grandTotal(data.transactionsDetails)}"
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String grandTotal(List<TransactionsDetail> trx) {
    int total = 0;

    trx.forEach((element) { 
      total += element.total;
    });

    return itemPrice(total);
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

  void _showDeleteDialog(TransactionModel data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("ID Transaksi: ${data.id}"),
          content: Text("Apakah anda yakin ingin menghapus transaksi ini?"),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: Text("Tidak")
            ),
            new FlatButton(
              onPressed: () {
                _transactionBloc..add(DeleteTransactionEvent(transactionId: data.id));
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