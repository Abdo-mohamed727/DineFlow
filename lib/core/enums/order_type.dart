import 'package:flutter/material.dart';

 enum OrderType {
  dineIn,
  takeaway,
}

extension OrderTypeX on OrderType {
  String get apiValue {
    switch (this) {
      case OrderType.dineIn:
        return 'DINE_IN';
      case OrderType.takeaway:
        return 'TAKEAWAY';
    }
  }

  static OrderType fromApi(String? value) {
    switch (value?.toUpperCase()) {
      case 'DINE_IN':
      case 'DINEIN':
        return OrderType.dineIn;
      case 'TAKEAWAY':
      default:
        return OrderType.takeaway;
    }
  }

  String get label {
    switch (this) {
      case OrderType.dineIn:
        return 'Dine-in';
      case OrderType.takeaway:
        return 'Takeaway';
    }
  }

  IconData get iconData {
    switch (this) {
      case OrderType.dineIn:
        return Icons.table_restaurant_outlined;
      case OrderType.takeaway:
        return Icons.shopping_bag_outlined;
    }
  }
}
