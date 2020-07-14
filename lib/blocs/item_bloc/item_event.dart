import 'package:flutter/material.dart';

import '../../models/items.dart';

abstract class ItemEvent {}

class GetItemEvent extends ItemEvent {}

class AddItemQtyEvent extends ItemEvent {
  final int itemId;
  AddItemQtyEvent({
    @required this.itemId
  });
}

class RemoveItemQtyEvent extends ItemEvent {
  final int itemId;
  RemoveItemQtyEvent({
    @required this.itemId
  });
}

class PostItemEvent extends ItemEvent {
  final int itemId;
  final String itemName;
  final int itemPrice;
  final String photoUrl;
  final bool create;

  PostItemEvent({
    @required this.itemId,
    @required this.itemName,
    @required this.itemPrice,
    @required this.photoUrl,
    @required this.create,
  });
}

class DeleteItemEvent extends ItemEvent {
  final int itemId;
  DeleteItemEvent({
    @required this.itemId
  });
}

class PostTransactionEvent extends ItemEvent {}