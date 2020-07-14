import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

import '../models/items.dart';

class Item extends StatelessWidget {

  final ItemsModel data;

  Item({
    @required this.data
  });

  @override
  Widget build(BuildContext context) {
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
              child: data.photoUrl == "" ? Image.asset(
                "lib/assets/images/no_image.png",
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
              ) : Image.file(
                File(data.photoUrl),
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
                      data.itemName,
                    ),
                    Text(
                      "${itemPrice(data.itemPrice)}",
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