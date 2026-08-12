import 'package:flutter/material.dart';

 enum OrderType {
  dineIn,
  takeaway,
}

extension OrderTypeX on OrderType {
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
