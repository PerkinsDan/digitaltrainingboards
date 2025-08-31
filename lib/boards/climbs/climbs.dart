import 'package:digitaltrainingboards/boards/climbs/climb/climb.dart';
import 'package:digitaltrainingboards/boards/climbs/create/create.dart';
import 'package:digitaltrainingboards/data/mongo.dart';
import 'package:digitaltrainingboards/objects/board_details.dart';
import 'package:flutter/material.dart';

class Climbs extends StatelessWidget {
  final BoardDetails board;
  const Climbs({super.key, required this.board});

  Future<List<String>> fetchClimbNames() async {
    final db = await Mongo.connect();
    final collection = db.collection('climbs');
    final climbs = await collection.find({'board': board.name}).toList();
    return climbs.map((climb) => climb['name'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Climbs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Create(board: board)),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: fetchClimbNames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No climbs found.'));
          } else {
            final climbNames = snapshot.data!;
            return ListView(
              children: climbNames.map((name) {
                return ListTile(
                  title: Text(name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Climb(name: name, index: climbNames.indexOf(name)),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
