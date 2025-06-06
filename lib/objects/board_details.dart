class BoardDetails {
  final String name;
  final String assets;

  BoardDetails({required this.name, required this.assets});

  String get image => 'assets/boards/$assets/wall.png';
  String get holdsJson => 'assets/boards/$assets/holds.json';
}
