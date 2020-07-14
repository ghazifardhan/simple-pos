import 'package:flutter/material.dart';

abstract class TransactionEvent {}

class GetTransactionEvent extends TransactionEvent {}
class DeleteTransactionEvent extends TransactionEvent {
  final int transactionId;
  DeleteTransactionEvent({
    @required this.transactionId
  });
}