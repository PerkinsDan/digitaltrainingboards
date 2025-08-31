import 'package:mongo_dart/mongo_dart.dart';

class Mongo {

  static Future<Db> connect() async {
      final db = await Db.create("mongodb+srv://danjonperkins:d9ibHqW063sL6fHm@cluster0.xeavyrm.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0");
      await db.open();
      return db;
  }
}