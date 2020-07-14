// To parse this JSON data, do
//
//     final itemsModel = itemsModelFromJson(jsonString);

import 'dart:convert';

List<ItemsModel> itemsModelFromJson(List<dynamic> str) => List<ItemsModel>.from(str.map((x) => ItemsModel.fromJson(x)));

String itemsModelToJson(List<ItemsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemsModel {
    ItemsModel({
        this.id,
        this.itemName,
        this.itemPrice,
        this.photoUrl,
        this.qty
    });

    int id;
    String itemName;
    int itemPrice;
    String photoUrl;
    int qty;

    factory ItemsModel.fromJson(Map<String, dynamic> json) => ItemsModel(
        id: json["id"] == null ? null : json["id"],
        itemName: json["item_name"] == null ? null : json["item_name"],
        itemPrice: json["item_price"] == null ? null : json["item_price"],
        photoUrl: json["photo_url"] == null ? null : json["photo_url"],
        qty: 0,
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "item_name": itemName == null ? null : itemName,
        "item_price": itemPrice == null ? null : itemPrice,
        "photo_url": photoUrl == null ? null : photoUrl,
        "qty": qty
    };
}
