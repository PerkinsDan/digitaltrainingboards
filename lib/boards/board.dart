import 'dart:convert';

import 'package:digitaltrainingboards/components/board_content.dart';
import 'package:digitaltrainingboards/objects/board_details.dart';
import 'package:digitaltrainingboards/objects/holds.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Board extends StatefulWidget {
  final BoardDetails board;

  const Board({super.key, required this.board});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var holds = <Hold>[];
  double? imageAspectRatio;

  @override
  void initState() {
    super.initState();

    // Load holds from JSON
    loadHoldsFromJsonFile(widget.board).then((loadedHolds) {
      setState(() {
        holds = loadedHolds;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final board = widget.board;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(board.name),
      ),
      body: Center(
        child: BoardContent(board: board, holds: holds),
      ),
    );
  }
}

Future<List<Hold>> loadHoldsFromJsonFile(BoardDetails board) async {
  final String jsonString = await rootBundle.loadString(board.holdsJson);
  final Map<String, dynamic> data = json.decode(jsonString);

  return data.entries.map((entry) {
    final List<dynamic> coords = entry.value;
    return Hold(x: coords[0].toDouble(), y: coords[1].toDouble());
  }).toList();
}
