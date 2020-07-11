import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ghazi_pos/models/items.dart';

abstract class ItemState extends Equatable {
  const ItemState();

  @override
  List<Object> get props => [];
}

class ItemUninitializedState extends ItemState {}
class ItemEmptyState extends ItemState {}

class ItemInitiliazedState extends ItemState {
  final List<ItemsModel> data;
  final int counter;
  
  ItemInitiliazedState({
    @required this.data,
    @required this.counter
  });

  ItemInitiliazedState copyWith({
    List<ItemsModel> data,
    int counter,
  }) {
    return ItemInitiliazedState(
      data: data ?? this.data,
      counter: counter ?? this.counter
    );
  }

  @override
  List<Object> get props => [
    data,
    counter
  ];
}

class ItemPostLoadingState extends ItemState {}
class ItemPostDoneState extends ItemState {}