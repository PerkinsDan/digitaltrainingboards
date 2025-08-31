import 'package:digitaltrainingboards/components/board_content.dart';
import 'package:digitaltrainingboards/data/mongo.dart';
import 'package:digitaltrainingboards/objects/board_details.dart';
import 'package:digitaltrainingboards/objects/holds.dart';
import 'package:flutter/material.dart';

class Climb extends StatefulWidget {
  final String name;
  final int index;

  const Climb({super.key, required this.name, required this.index});

  @override
  State<Climb> createState() => _ClimbState();
}

class _ClimbState extends State<Climb> {
  String? grade;
  Map<String, dynamic>? feet;
  bool? matchingAllowed;
  List<String> climbNames = [];
  int currentIndex = 0;
  PageController? _pageController;
  Map<int, Future<BoardDetails?>> _pageCache = {};
  List<Map<String, dynamic>> climbsData = [];

  @override
  void initState() {
    super.initState();
    _loadClimbs();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Future<void> _loadClimbs() async {
    final db = await Mongo.connect();
    final collection = db.collection('climbs');
    final climbs = await collection.find({'board': widget.boardName}).toList();
    setState(() {
      climbsData = climbs;
      climbNames = climbs.map((climb) => climb['name'] as String).toList();
      currentIndex = climbNames.indexOf(widget.name);
      if (currentIndex == -1) currentIndex = 0;
      _pageController = PageController(initialPage: currentIndex);
    });
  }

  Future<BoardDetails?> fetchBoardByName(String boardName) async {
    final db = await Mongo.connect();
    final collection = db.collection(
      'climbs',
    ); // Ensure the collection name matches your MongoDB setup
    final boardData = await collection.findOne({'name': boardName});
    if (boardData == null) return null;

    // Update extra fields in state without setState
    grade = boardData['grade'] as String?;
    feet = Map<String, dynamic>.from(boardData['feet'] ?? {});
    matchingAllowed = boardData['matchingAllowed'] as bool?;

    return BoardDetails(
      name: boardData['board'] as String,
      holds: (boardData['holds'] as List<dynamic>).map((hold) {
        return Hold(
          x: hold['x'] as double,
          y: hold['y'] as double,
          type: HoldType.values.firstWhere(
            (type) => type.toString() == hold['type'],
            orElse: () => HoldType.hidden,
          ),
        );
      }).toList(),
      isChangeable: false,
    );
  }

  void _preloadPages(int currentIndex) {
    for (int i = (currentIndex - 5); i <= (currentIndex + 5); i++) {
      if (i >= 0 && i < climbNames.length && !_pageCache.containsKey(i)) {
        _pageCache[i] = fetchBoardByName(climbNames[i]);
      }
    }
    // Optionally, remove pages far from the current index to save memory
    _pageCache.removeWhere(
      (key, value) => (key < currentIndex - 5) || (key > currentIndex + 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_pageController == null || climbsData.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          climbNames.isNotEmpty ? climbNames[currentIndex] : widget.name,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: climbsData.length,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final climb = climbsData[index];
          // Build BoardDetails from climb data
          final board = BoardDetails(
            name: climb['board'] as String,
            holds: (climb['holds'] as List<dynamic>).map((hold) {
              return Hold(
                x: hold['x'] as double,
                y: hold['y'] as double,
                type: HoldType.values.firstWhere(
                  (type) => type.toString() == hold['type'],
                  orElse: () => HoldType.hidden,
                ),
              );
            }).toList(),
            isChangeable: false,
          );
          // Set extra fields for display
          grade = climb['grade'] as String?;
          feet = Map<String, dynamic>.from(climb['feet'] ?? {});
          matchingAllowed = climb['matchingAllowed'] as bool?;

          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                if (grade != null)
                  Text(
                    'Grade: $grade',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (matchingAllowed != null)
                  Text(
                    'Matching Allowed: ${matchingAllowed! ? "Yes" : "No"}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (feet != null && feet!.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Feet: ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (feet!['red'] == true)
                        const Icon(Icons.circle, color: Colors.red, size: 18),
                      if (feet!['orange'] == true)
                        const Icon(
                          Icons.circle,
                          color: Colors.orange,
                          size: 18,
                        ),
                      if (feet!['green'] == true)
                        const Icon(Icons.circle, color: Colors.green, size: 18),
                    ],
                  ),
                const SizedBox(height: 20),
                BoardContent(board: board),
              ],
            ),
          );
        },
      ),
    );
  }
}
