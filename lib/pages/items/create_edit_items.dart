import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_bloc.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_event.dart';
import 'package:toast/toast.dart';

class CreateEditItems extends StatefulWidget {

  final bool create;

  CreateEditItems({
    @required this.create
  });

  @override
  State<StatefulWidget> createState() {
    return _CreateEditItemsState();
  }
}

class _CreateEditItemsState extends State<CreateEditItems> {

  String itemName = "", itemPrice = "";
  ItemBloc _itemBloc;

  @override
  void initState() {
    super.initState();

    _itemBloc = BlocProvider.of<ItemBloc>(context);
  }

  @override
  void dispose() {
    // _itemBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.create ? "Tambah Barang" : "Ubah Barang"
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check
            ),
            onPressed: () {
              if (itemName == "") {
                Toast.show("Mohon isi Nama Barang", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                return;
              } else if (itemPrice == "") {
                Toast.show("Mohon isi Harga Barang", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                return;
              } else {
                print("asdasd");
                _itemBloc..add(PostItemEvent(
                  itemName: itemName,
                  itemPrice: int.parse(itemPrice),
                  photoUrl: ""
                ));
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0,),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Nama Barang",
                labelText: "Nama Barang"
              ),
              onChanged: (String value) {
                setState(() {
                  itemName = value;
                });
              },
            ),
            SizedBox(height: 10.0,),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Harga Barang",
                labelText: "Harga Barang"
              ),
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                setState(() {
                  itemPrice = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

}