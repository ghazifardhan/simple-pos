import 'package:flutter/material.dart';

class Transactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransactionsState();
  }
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Transactions"),
    );
  }
}