import 'dart:io' as io;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL,age TEXT NOT NULL, description TEXT NOT NULL, email TEXT)",
    );
  }

  Future<NotesModel> insert(NotesModel notesModel) async {
    var dbClient = await db;
    await dbClient!.insert('notes', notesModel.toMap());
    return notesModel;
  }

  Future<List<NotesModel>> getCartListWithUserId() async {
    var dbClient = await db;

    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('notes');
    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  Future<List<NotesModel>> postionNotes(var long, var lat) async {
    // get a reference to the database
    var dbClient = await db;


    // raw query
    List<Map<String, Object?>>? queryResult = await dbClient?.rawQuery(
        'SELECT * FROM notes WHERE email=? and age=?', [long, lat]);
    if(queryResult?.length==0){


    }
    if (queryResult?.length==0 || queryResult ==null) {
      final List<Map<String, Object?>> queryResult2 =
      await dbClient!.query('note');
      return queryResult2.map((e) => NotesModel.fromMap(e)).toList();
    }
    else {
      showNotification  (title: 'اعمال في هذا الموقع', body: 'لديك العديد من المهمات التي يجب ان تنجزها في هذا الموقع !!!', payload: 'To-Do');

      return queryResult.map((e) => NotesModel.fromMap(e)).toList();
      // {_id: 2, name: Mary, age: 32}
    }
  }

  Future deleteTableContent() async {
    var dbClient = await db;
    return await dbClient!.delete(
      'notes',
    );
  }

  Future<int> updateQuantity(NotesModel notesModel) async {
    var dbClient = await db;
    return await dbClient!.update(
      'notes',
      notesModel.toMap(),
      where: 'id = ?',
      whereArgs: [notesModel.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    var dbClient = await db;
    return await dbClient!.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    var dbClient = await db;
    dbClient!.close();
  }




  static final _notifications = FlutterLocalNotificationsPlugin();
  static Future _notificationDetails() async {
    return const NotificationDetails(
      android:  AndroidNotificationDetails(
          ' channel id',
          ' channel name',
          ' channel description',
          importance: Importance.max,
          priority: Priority.high,
          icon: "@mipmap/ic_launcher"

    ),
      //iOS: IOSNotificationDetails(),
    );
  }
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );


}
