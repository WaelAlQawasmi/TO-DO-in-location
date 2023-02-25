import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqf_lite_flutter/add_data.dart';
import 'package:sqf_lite_flutter/map.dart';
import 'package:sqf_lite_flutter/model.dart';

import 'LocationService.dart';
import 'db.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My SqfLite App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
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
  DBHelper? dbHelper;
  Position? _myLocation;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
    _getMyLocation();
     timer = Timer.periodic(Duration(seconds: 15), (Timer t) => setData());

  }


  Future<void> _getMyLocation() async {
     _myLocation = (await LocationService().determinePosition()) ;
    print(_myLocation);
    setState(() {

    });
  }

  void setData(){
    _getMyLocation();
    setState(() {

    });
  }

  // navigator() {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (context) => const AddData()));
  // }

  loadData() {
    noteList = dbHelper!.getCartListWithUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do on Location'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,

      ),


      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Center(child: Text("${_myLocation?.longitude}"),),

              Container(
                height: 800,
                child: FutureBuilder(
                  future: noteList,
                  builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                    if(snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            direction: DismissDirection.startToEnd,
                            background: Container(
                              margin: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.red,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Icon(Icons.delete,color: Colors.white,size: 50,),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.delete,color: Colors.white,size: 50,),
                                  ],
                                ),
                              ),
                              key: ValueKey<int>(snapshot.data![index].id!),
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  dbHelper?.deleteProduct(snapshot.data![index].id!);
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
                                          title: Text(
                                            snapshot.data![index].title
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
                    }else{
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
      floatingActionButton: FloatingActionButton(
        // onPressed: navigator,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapSample()),
          );
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
