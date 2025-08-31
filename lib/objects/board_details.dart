import 'dart:convert';

import 'package:digitaltrainingboards/objects/holds.dart';
import 'package:flutter/services.dart';

class BoardDetails {
  final String name;
  final bool isChangeable;
  List<Hold>? holds;

  BoardDetails({required this.name, required this.isChangeable, this.holds});

  String get assets => name.replaceAll(' ', '');
  String get image => 'assets/boards/$assets/wall.png';

  Future<void> loadHoldsFromJsonFile() async {
    final String holdsJson = 'assets/boards/$assets/holds.json';
    final String jsonString = await rootBundle.loadString(holdsJson);
    final Map<String, dynamic> data = json.decode(jsonString);

    holds = data.entries.map((entry) {
      final List<dynamic> coords = entry.value;
      return Hold(x: coords[0].toDouble(), y: coords[1].toDouble());
    }).toList();
  }
}
