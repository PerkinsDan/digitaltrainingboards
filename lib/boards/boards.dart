import 'package:digitaltrainingboards/boards/board.dart';
import 'package:digitaltrainingboards/objects/board_details.dart';
import 'package:flutter/material.dart';

class Boards extends StatelessWidget {
  const Boards({super.key});

  static final boards = [
    BoardDetails(name: 'Airton Garage', image: 'assets/board.png'),
    BoardDetails(name: 'Canary 45', image: 'assets/wall.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Boards'),
        leading: Image.asset('assets/logo.jpg'),
      ),
      body: Center(
        child: ListView(
          children: (boards)
              .map(
                (board) => ListTile(
                  title: Text(board.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Board(
                          board: board,
                        ), // Replace with actual board page
                      ),
                    );
                    // Navigate to the selected board
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
