import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_bloc.dart';
import 'package:ghazi_pos/blocs/item_bloc/item_event.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:toast/toast.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import '../../blocs/item_bloc/item_bloc.dart';
import '../../blocs/item_bloc/item_state.dart';
import '../../models/items.dart';

class CreateEditItems extends StatefulWidget {

  final bool create;
  ItemsModel data;

  CreateEditItems({
    @required this.create,
    this.data
  });

  @override
  State<StatefulWidget> createState() {
    return _CreateEditItemsState();
  }
}

class _CreateEditItemsState extends State<CreateEditItems> {

  String itemName = "", itemPrice = "";
  ItemBloc _itemBloc;
  File _image;
  Directory dir;

  @override
  void initState() {
    super.initState();

    _itemBloc = BlocProvider.of<ItemBloc>(context);
    
    init();

    if (!widget.create) {
      itemName = widget.data.itemName;
      itemPrice = widget.data.itemPrice.toString();
      if (widget.data.photoUrl != "") _image = File(widget.data.photoUrl);
    }
  }

  @override
  void dispose() {
    // _itemBloc.close();
    super.dispose();
  }

  init() async {
    dir = await path_provider.getApplicationDocumentsDirectory();
  }

  Future getImage(ImgSource source) async {
    File image = await ImagePickerGC.pickImage(
        context: context,
        source: source,
        cameraIcon: Icon(
          Icons.camera_alt,
          color: Colors.red,
        ),//cameraIcon and galleryIcon can change. If no icon provided default icon will be present
      cameraText: Text("Dari Kamera",style: TextStyle(color: Colors.red),),
      galleryText: Text("Dari Galeri",style: TextStyle(color: Colors.blue),)
    );

    if (image != null) {
      var result = await FlutterNativeImage.compressImage(
        image.path,
        quality: 50,
        percentage: 50
      );

      setState(() {
        _image = result;
      });
    }
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
                _itemBloc..add(PostItemEvent(
                  itemName: itemName,
                  itemPrice: int.parse(itemPrice),
                  photoUrl: _image != null ? _image.path : "",
                  create: widget.create,
                  itemId: widget.create ? null : widget.data.id
                ));
              }
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color.fromRGBO(0, 0, 0, 0.2)
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: _image != null ? 
                          Image.file(
                            _image,
                            fit: BoxFit.cover
                          ) 
                          : 
                          Image.asset(
                            "lib/assets/images/no_image.png",
                            fit: BoxFit.cover
                          ),
                      ),
                    ),
                    FlatButton(
                      onPressed: () => getImage(ImgSource.Both),
                      child: widget.create ? Text("Tambah Photo") : Text("Ubah Photo")
                    )
                  ],
                ),
                SizedBox(height: 10.0,),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Nama Barang",
                    labelText: "Nama Barang",
                  ),
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  onChanged: (String value) {
                    setState(() {
                      itemName = value;
                    });
                  },
                  initialValue: widget.create ? "" : widget.data.itemName,
                ),
                SizedBox(height: 10.0,),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Harga Barang",
                    labelText: "Harga Barang"
                  ),
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    setState(() {
                      itemPrice = value;
                    });
                  },
                  initialValue: widget.create ? "" : widget.data.itemPrice.toString(),
                ),
              ],
            ),
          ),

          BlocListener<ItemBloc, ItemState>(
            listener: (context, state) {
              if (state is ItemPostDoneState) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
                  Navigator.pop(context);
                });
              }
            },
            child: BlocBuilder<ItemBloc, ItemState>(
              builder: (context, state) {
                if (state is ItemPostLoadingState) {
                  return Container(
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

}