import 'package:flutter/foundation.dart';

class Transaction {
  int id;
  String title;
  double value;
  DateTime date;

  Transaction ({
    @required this.id,
    @required this.title,
    @required this.value,
    @required this.date
  });
}