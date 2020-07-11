import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ghazi_pos/models/items.dart';

class Api {

  final String url = "http://10.0.2.2:3000";

  Future<List<ItemsModel>> getItems() async {
    Response res = await Dio().get(
      "$url/items"
    );
    List<ItemsModel> model = itemsModelFromJson(res.data);
    return model;
  }

  Future<ItemsModel> postItems({
    String itemName,
    int itemPrice,
    String photoUrl
  }) async {

    Map data = {
      "item_name": itemName,
      "item_price": itemPrice,
      "photo_url": photoUrl
    };

    Response res = await Dio().post(
      "$url/items",
      data: data
    );
    ItemsModel datas = ItemsModel.fromJson(res.data);
    return datas;
  }

}