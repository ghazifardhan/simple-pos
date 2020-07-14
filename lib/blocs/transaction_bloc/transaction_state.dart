import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ghazi_pos/models/items.dart';
import 'package:ghazi_pos/models/transactions.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionUninitializedState extends TransactionState {}
class TransactionEmptyState extends TransactionState {}

class TransactionInitiliazedState extends TransactionState {
  final List<TransactionModel> data;
  final int counter;
  
  TransactionInitiliazedState({
    @required this.data,
    @required this.counter
  });

  TransactionInitiliazedState copyWith({
    List<TransactionModel> data,
    int counter,
  }) {
    return TransactionInitiliazedState(
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