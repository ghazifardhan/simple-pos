import 'package:flutter/material.dart';
import 'package:ghazi_pos/pages/items/items.dart';
import 'package:ghazi_pos/pages/sales/sales.dart';
import 'package:ghazi_pos/pages/transactions/transactions.dart';

class Home extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

}

class _HomeState extends State<Home> {

  int currentIndex = 0;
  final List<Widget> _children = [
    Sales(),
    Items(),
    Transactions()
  ];

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Dagangin"),
      ),
      body: _children[currentIndex],
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.attach_money),
            title: new Text('Jual'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.view_list),
            title: new Text('Barang'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.watch_later),
            title: Text('Transaksi')
          )
        ],
      ),
    );
  }

}