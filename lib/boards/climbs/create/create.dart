import 'package:digitaltrainingboards/data/mongo.dart';
import 'package:digitaltrainingboards/components/board_content.dart';
import 'package:digitaltrainingboards/objects/board_details.dart';
import 'package:digitaltrainingboards/objects/holds.dart';
import 'package:flutter/material.dart';

final grades = [
  {'value': '5', 'label': '5'},
  {'value': '5+', 'label': '5+'},
  {'value': '6a', 'label': '6a'},
  {'value': '6a+', 'label': '6a+'},
  {'value': '6b', 'label': '6b'},
  {'value': '6b+', 'label': '6b+'},
  {'value': '6c', 'label': '6c'},
  {'value': '6c+', 'label': '6c+'},
  {'value': '7a', 'label': '7a'},
  {'value': '7a+', 'label': '7a+'},
  {'value': '7b', 'label': '7b'},
  {'value': '7b+', 'label': '7b+'},
  {'value': '7c', 'label': '7c'},
  {'value': '7c+', 'label': '7c+'},
  {'value': '8a', 'label': '8a'},
  {'value': '8a+', 'label': '8a+'},
  {'value': '8b', 'label': '8b'},
];

class Create extends StatefulWidget {
  final BoardDetails board;

  const Create({super.key, required this.board});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {
  var holds = <Hold>[];
  double? imageAspectRatio;
  var name = '';
  var grade = '';
  var matchingAllowed = false;
  var feet = {'red': false, 'orange': false, 'green': false};
  bool isLoadingHolds = true; // Track loading state

  @override
  void initState() {
    super.initState();
    loadHolds(); // Load holds when the widget is initialized
  }

  Future<void> loadHolds() async {
    await widget.board.loadHoldsFromJsonFile();
    setState(() {
      holds = widget.board.holds ?? [];
      isLoadingHolds = false; // Update loading state
    });
  }

  void handleSubmit() {
    if (name.isEmpty || grade.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final selectedHolds = holds
        .where((hold) => hold.type != HoldType.hidden)
        .map((hold) => hold.toMap())
        .toList();
    if (selectedHolds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one hold')),
      );
      return;
    }

    final climbData = {
      'name': name,
      'grade': grade,
      'matchingAllowed': matchingAllowed,
      'feet': feet,
      'holds': selectedHolds,
      'board': widget.board.name,
    };

    Mongo.connect().then((db) async {
      final collection = db.collection('climbs');
      await collection.insertOne(climbData);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Climb "$name" created with grade $grade')),
    );

    setState(() {
      name = '';
      grade = '';
      matchingAllowed = false;
      feet = {'red': false, 'orange': false, 'green': false};
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Create a new climb for ${board.name}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Climb Name',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => setState(() {
                          name = value;
                        }),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownMenu(
                            label: const Text('Grade'),
                            menuHeight: 200,
                            dropdownMenuEntries: [
                              for (var grade in grades)
                                DropdownMenuEntry<String>(
                                  value: grade['value']!,
                                  label: grade['label']!,
                                ),
                            ],
                            onSelected: (value) => setState(() {
                              grade = value ?? '';
                            }),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              padding: const EdgeInsets.only(
                                top: 4.0,
                                bottom: 4.0,
                                left: 8.0,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Matching Allowed?",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge,
                                  ),
                                  Checkbox(
                                    onChanged: (value) => setState(() {
                                      matchingAllowed = value ?? false;
                                    }),
                                    value: matchingAllowed,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: const EdgeInsets.only(
                          top: 4.0,
                          bottom: 4.0,
                          left: 8.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Feet:",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: feet['red'],
                                  onChanged: (value) => setState(() {
                                    feet['red'] = value ?? false;
                                  }),
                                  fillColor: WidgetStateProperty.resolveWith((
                                    states,
                                  ) {
                                    return Colors.red;
                                  }),
                                ),
                                Checkbox(
                                  value: feet['orange'],
                                  onChanged: (value) => setState(() {
                                    feet['orange'] = value ?? false;
                                  }),
                                  fillColor: WidgetStateProperty.resolveWith((
                                    states,
                                  ) {
                                    return Colors.orange;
                                  }),
                                ),
                                Checkbox(
                                  value: feet['green'],
                                  onChanged: (value) => setState(() {
                                    feet['green'] = value ?? false;
                                  }),
                                  fillColor: WidgetStateProperty.resolveWith((
                                    states,
                                  ) {
                                    return Colors.green;
                                  }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => handleSubmit(),
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
              isLoadingHolds
                  ? const CircularProgressIndicator() // Show loading indicator
                  : BoardContent(
                      board: board,
                    ), // Render BoardContent when holds are loaded
            ],
          ),
        ),
      ),
    );
  }
}
