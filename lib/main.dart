import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:workmanager/workmanager.dart';

import 'LocationService.dart';
import 'NotificationService.dart';
import 'db.dart';
import 'map.dart';
import 'model.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tasks',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
          colorScheme: ThemeData().colorScheme.copyWith(
            primary:Colors.cyan ,
            secondary: Colors.cyan,
          )
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<NotesModel>> noteList;
  late Future<List<NotesModel>> PostionNotes;
  DBHelper? dbHelper;
  Position? _myLocation;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
    // _getMyLocation();
    loadPostionNotes(_myLocation?.longitude.toStringAsFixed(3));
    print(_myLocation?.longitude.toString());
    timer = Timer.periodic(Duration(minutes: 1), (Timer t) => setData());
  }

  Future<void> _getMyLocation() async {
    _myLocation = (await LocationService().determinePosition());
    print(_myLocation);
  }

  void setData() {
    _getMyLocation();
    loadPostionNotes(_myLocation?.longitude.toStringAsFixed(3));
  }

  // navigator() {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => const AddData()));
  // }

  loadData() {
    noteList = dbHelper!.getCartListWithUserId();
  }

  loadPostionNotes(var long) {
    PostionNotes = dbHelper!.postionNotes(long);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text("Location Tasks"),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Location tasks",
                      style: TextStyle(color: Colors.white),
                    ),
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              Tab(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    " All task",
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    Icons.reviews,
                    color: Colors.white,
                  )
                ],
              )),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            Container(
              child: Container(
                height: 600,
                child: FutureBuilder(
                  future: PostionNotes,
                  builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data! == null) {
                        return SizedBox();
                      }
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.cyan,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ],
                              ),
                            ),
                            key: ValueKey<int>(snapshot.data![index].id!),
                            child: Dismissible(
                              direction: DismissDirection.endToStart,
                              background: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.cyan,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  ],
                                ),
                              ),
                              key: ValueKey<int>(snapshot.data![index].id!),
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  dbHelper
                                      ?.deleteProduct(snapshot.data![index].id!);
                                  noteList = dbHelper!.getCartListWithUserId();
                                  snapshot.data?.remove(snapshot.data![index]);
                                });
                              },
                              child: Card(
                                margin: const EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                shadowColor: Colors.amber,
                                elevation: 4,
                                semanticContainer: true,
                                child: SizedBox(
                                    height: 90,
                                    child: Center(
                                        child: ListTile(
                                          title: Text(snapshot.data![index].title),
                                          subtitle: Text(
                                            snapshot.data![index].description,
                                          ),
                                        ))),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return new Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),

            SingleChildScrollView(
              child: Container(
                height: 800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 800,
                      child: FutureBuilder(
                        future: noteList,
                        builder:
                            (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  direction: DismissDirection.startToEnd,
                                  background: Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.cyan,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 50,
                                        ),
                                      ],
                                    ),
                                  ),
                                  key: ValueKey<int>(snapshot.data![index].id!),
                                  child: Dismissible(
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Colors.red,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: const [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        ],
                                      ),
                                    ),
                                    key: ValueKey<int>(snapshot.data![index].id!),
                                    onDismissed: (DismissDirection direction) {
                                      setState(() {
                                        dbHelper?.deleteProduct(
                                            snapshot.data![index].id!);
                                        noteList =
                                            dbHelper!.getCartListWithUserId();
                                        snapshot.data
                                            ?.remove(snapshot.data![index]);
                                      });
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.all(8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(15)),
                                      shadowColor: Colors.amber,
                                      elevation: 4,
                                      semanticContainer: true,
                                      child: SizedBox(
                                          height: 90,
                                          child: Center(
                                              child: ListTile(
                                                title: Text(
                                                  snapshot.data![index].title,
                                                  style: TextStyle(
                                                      color: Colors.redAccent),
                                                ),
                                                subtitle: Text(
                                                  snapshot.data![index].description,
                                                ),
                                              ))),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),

        floatingActionButton: FloatingActionButton(
          // onPressed: navigator,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MapSample()),
            );
          },
          foregroundColor: Colors.white,
          backgroundColor: Colors.cyan,
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
