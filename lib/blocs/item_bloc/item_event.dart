import 'package:flutter/material.dart';

abstract class ItemEvent {}

class GetItemEvent extends ItemEvent {}

class PostItemEvent extends ItemEvent {
  final String itemName;
  final int itemPrice;
  final String photoUrl;

  PostItemEvent({
    @required this.itemName,
    @required this.itemPrice,
    @required this.photoUrl
  });
}