// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

List<TransactionModel> transactionModelFromJson(List<dynamic>  str) => List<TransactionModel>.from(str.map((x) => TransactionModel.fromJson(x)));

String transactionModelToJson(List<TransactionModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransactionModel {
    TransactionModel({
        this.id,
        this.transactionDate,
        this.transactionsDetails,
    });

    int id;
    int transactionDate;
    List<TransactionsDetail> transactionsDetails;

    factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json["id"] == null ? null : json["id"],
        transactionDate: json["transaction_date"] == null ? null : json["transaction_date"],
        transactionsDetails: json["transactions_details"] == null ? null : List<TransactionsDetail>.from(json["transactions_details"].map((x) => TransactionsDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "transaction_date": transactionDate == null ? null : transactionDate,
        "transactions_details": transactionsDetails == null ? null : List<dynamic>.from(transactionsDetails.map((x) => x.toJson())),
    };
}

class TransactionsDetail {
    TransactionsDetail({
        this.itemId,
        this.itemName,
        this.itemPrice,
        this.photoUrl,
        this.quantity,
        this.total,
    });

    int itemId;
    String itemName;
    int itemPrice;
    String photoUrl;
    int quantity;
    int total;

    factory TransactionsDetail.fromJson(Map<String, dynamic> json) => TransactionsDetail(
        itemId: json["item_id"] == null ? null : json["item_id"],
        itemName: json["item_name"] == null ? null : json["item_name"],
        itemPrice: json["item_price"] == null ? null : json["item_price"],
        photoUrl: json["photo_url"] == null ? null : json["photo_url"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        total: json["total"] == null ? null : json["total"],
    );

    Map<String, dynamic> toJson() => {
        "item_id": itemId == null ? null : itemId,
        "item_name": itemName == null ? null : itemName,
        "item_price": itemPrice == null ? null : itemPrice,
        "photo_url": photoUrl == null ? null : photoUrl,
        "quantity": quantity == null ? null : quantity,
        "total": total == null ? null : total,
    };
}
