import 'dart:async';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'db.dart';
import 'main.dart';
import 'model.dart';


class AddData extends StatefulWidget {
   AddData({Key? key, required this.latitude, required this.longitude,}) : super(key: key);
  final double longitude;
  final double latitude;

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  DBHelper? dbHelper;
  var title = TextEditingController();
  var age = TextEditingController();
  var description = TextEditingController();
  var email = TextEditingController();

  @override
  void initState() {
    super.initState();
    age.text=widget.latitude.toStringAsFixed(3);
    email.text=widget.longitude.toStringAsFixed(3);
    dbHelper = DBHelper();
  }
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        toolbarHeight: 89,
        title: const Text('Add Data'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                    hintText: 'Title',

                    fillColor: const Color(0xffe9e9e9),
                    filled: true,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  enabled: false,
                  controller: email,
                  decoration: InputDecoration(
                    hintText: 'email',
                    fillColor: const Color(0xffe9e9e9),
                    filled: true,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  enabled: false,
                  controller: age,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Age',
                    fillColor: const Color(0xffe9e9e9),
                    filled: true,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),


                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: description,
                  maxLines: 4,
                  minLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    fillColor: const Color(0xffe9e9e9),
                    filled: true,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Add Data',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    dbHelper
                        ?.insert(NotesModel(
                      title: title.text,
                      age: (age.text.toString()),
                      email: email.text,
                      description: description.text,
                    ))
                        .then((value) {
                      if (kDebugMode) {
                        print('Data Added');
                      }
                    }).onError((error, stackTrace) {
                      if (kDebugMode) {
                        print(error);
                      }
                    });
                    title.clear();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => const MyHomePage()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
