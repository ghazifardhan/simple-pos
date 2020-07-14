import 'package:dio/dio.dart';
import 'package:ghazi_pos/models/items.dart';
import 'package:ghazi_pos/models/transactions.dart';

class Api {

  final String url = "https://simplepos.ghazifadil.online";

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

  Future<ItemsModel> putItems({
    String itemName,
    int itemPrice,
    String photoUrl,
    int itemId
  }) async {

    Map data = {
      "item_name": itemName,
      "item_price": itemPrice,
      "photo_url": photoUrl
    };

    Response res = await Dio().put(
      "$url/items/$itemId",
      data: data
    );
    ItemsModel datas = ItemsModel.fromJson(res.data);
    return datas;
  }

  Future<Response> deleteItems({
    int itemId
  }) async {
    Response res = await Dio().delete(
      "$url/items/$itemId",
    );
    return res;
  }

  Future<TransactionModel> postTransactions({
    TransactionModel model
  }) async {

    Response res = await Dio().post(
      "$url/transactions",
      data: model.toJson()
    );
    TransactionModel datas = TransactionModel.fromJson(res.data);
    return datas;
  }

  Future<List<TransactionModel>> getTransactions() async {
    Response res = await Dio().get(
      "$url/transactions?_sort=id&_order=desc",
    );
    List<TransactionModel> datas = transactionModelFromJson(res.data);
    return datas;
  }

  Future<Response> deleteTransations({
    int transactionId
  }) async {
    Response res = await Dio().delete(
      "$url/transactions/$transactionId",
    );
    return res;
  }

}