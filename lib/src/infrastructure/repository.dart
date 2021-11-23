import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

abstract class Repository {
  @protected
  int saveDateTime(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }

  @protected
  DateTime readDateTime(int millisecondsSinceEpoch) {
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  @protected
  String saveDecimal(Decimal decimal) {
    return decimal.toString();
  }

  @protected
  Decimal readDecimal(String value) {
    return Decimal.parse(value);
  }
}