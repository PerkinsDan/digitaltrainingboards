import 'package:digitaltrainingboards/mixins/board_details.dart';
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
  final double size;
  final double x;
  final double y;
  HoldType type = HoldType.start;

  Hold({required this.size, required this.x, required this.y});

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

class Board extends StatefulWidget {
  final BoardDetails board;

  const Board({super.key, required this.board});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var holds = [
    Hold(size: 35, x: 18, y: 58),
    Hold(size: 35, x: 80, y: 49),
    Hold(size: 35, x: 108, y: 20),
    Hold(size: 50, x: 155, y: 22),
    Hold(size: 35, x: 215, y: 57),
    Hold(size: 40, x: 270, y: 54),
    Hold(size: 35, x: 278, y: 24),
    Hold(size: 40, x: 325, y: 40),
  ];

  @override
  Widget build(BuildContext context) {
    final board = widget.board;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(board.name),
      ),
      body: Center(
        child: Stack(
          children: [
            Image.asset(board.image),
            ...holds.map(
              (hold) => Positioned(
                left: hold.x,
                top: hold.y,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      hold.changeType();
                    });
                  },
                  child: Container(
                    width: hold.size,
                    height: hold.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: hold.type.color, width: 2),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
