import 'package:flutter/material.dart';
import 'package:digitaltrainingboards/objects/holds.dart';
import 'package:digitaltrainingboards/objects/board_details.dart';

class BoardContent extends StatefulWidget {
  final BoardDetails board;

  const BoardContent({super.key, required this.board});

  @override
  State<BoardContent> createState() => _BoardContentState();
}

class _BoardContentState extends State<BoardContent> {
  double imageAspectRatio = 1.0; // Default aspect ratio

  @override
  void initState() {
    super.initState();
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
    if (widget.board.holds == null || widget.board.holds!.isEmpty) {
      return const Center(
        child:
            CircularProgressIndicator(), // Show a loading indicator if holds are not loaded
      );
    }

    return AspectRatio(
      aspectRatio: imageAspectRatio,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          return Container(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage(widget.board.image)),
                ),
                child: Stack(
                  children: widget.board.holds!.map((hold) {
                    return Positioned(
                      left: hold.x / 800 * width - 20,
                      top: hold.y / 750 * height - 20,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.board.isChangeable) {
                              hold.changeType();
                            }
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
              ),
            ),
          );
        },
      ),
    );
  }
}
