import 'package:digitaltrainingboards/mixins/board_details.dart';
import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  final BoardDetails board;

  const Board({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(board.name),
      ),
      body: Center(child: Image.asset(board.image)),
    );
  }
}
