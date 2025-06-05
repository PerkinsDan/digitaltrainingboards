import 'dart:convert';

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
    loadHoldsFromJsonFile().then((loadedHolds) {
      setState(() {
        holds = loadedHolds;
      });
    });

    // Get the aspect ratio of the image
    _getImageAspectRatio(widget.board.image);
  }

  Future<void> _getImageAspectRatio(String imagePath) async {
    final Image image = Image.asset(imagePath);
    final ImageStream stream = image.image.resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        final int width = info.image.width;
        final int height = info.image.height;
        setState(() {
          imageAspectRatio = width / height;
        });
      }),
    );
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
        child: imageAspectRatio == null
            ? const CircularProgressIndicator() // Show a loader until the aspect ratio is calculated
            : AspectRatio(
                aspectRatio: imageAspectRatio!,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final height = constraints.maxHeight;
                    return Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(board.image)),
                      ),
                      child: Stack(
                        children: holds.map((hold) {
                          return Positioned(
                            left: hold.x / 800 * width - 20,
                            top: hold.y / 750 * height - 20,
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
                                  border: Border.all(
                                    color: hold.type.color,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

Future<List<Hold>> loadHoldsFromJsonFile() async {
  final String jsonString = await rootBundle.loadString('assets/holds.json');
  final Map<String, dynamic> data = json.decode(jsonString);

  return data.entries.map((entry) {
    final List<dynamic> coords = entry.value;
    return Hold(x: coords[0].toDouble(), y: coords[1].toDouble());
  }).toList();
}
