import 'package:flutter/material.dart';

enum HoldType { start, hand, end, hidden }

extension HoldTypeColor on HoldType {
  Color get color {
    switch (this) {
      case HoldType.start:
        return Colors.green;
      case HoldType.hand:
        return Colors.blue;
      case HoldType.end:
        return Colors.red;
      case HoldType.hidden:
        return Colors.transparent;
    }
  }
}

class Hold {
  final double size = 35;
  final double x;
  final double y;
  HoldType type = HoldType.hidden;

  Hold({required this.x, required this.y});

  changeType() {
    switch (type) {
      case HoldType.start:
        type = HoldType.hand;
        break;
      case HoldType.hand:
        type = HoldType.end;
        break;
      case HoldType.end:
        type = HoldType.hidden;
        break;
      case HoldType.hidden:
        type = HoldType.start;
        break;
    }
  }
}
