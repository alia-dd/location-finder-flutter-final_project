import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/global/global_var.dart';
import 'package:final_project/utility/buttonWidget.dart';
import 'package:final_project/utility/custom_scaffold.dart';
import 'package:final_project/utility/mytext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/services.dart';

class sharelocation extends StatefulWidget {
  const sharelocation({super.key});

  @override
  State<sharelocation> createState() => _sharelocationState();
}

class _sharelocationState extends State<sharelocation> {
  final Timestamp timestamp = Timestamp.now();

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      User? user = FirebaseAuth.instance.currentUser;
      String? uid = user?.uid;
      print("......................./....///,");
      if (mylocationkey.isNotEmpty &&
          mylocationkey != "location key" &&
          mylocationkey != "") {
        await FirebaseFirestore.instance
            .collection('location')
            .doc(mylocationkey)
            .set({
          'latitude': _locationResult.latitude,
          'longitude': _locationResult.longitude,
        }, SetOptions(merge: true));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    if (mylocationkey != "" &&
        mylocationkey != "location key" &&
        mylocationkey.isNotEmpty) {
      _locationSubscription = location.onLocationChanged.handleError((onError) {
        print(onError);
        _locationSubscription?.cancel();
        setState(() {
          _locationSubscription = null;
        });
      }).listen((loc.LocationData currentlocation) async {
        await FirebaseFirestore.instance
            .collection('location')
            .doc(mylocationkey)
            .set({
          'latitude': currentlocation.latitude,
          'longitude': currentlocation.longitude,
        }, SetOptions(merge: true));
      });
    }
  }

  void initState() {
    super.initState();
    if (mylocationkey != "") {
      _listenLocation();
    }
  }

  Widget datastream() {
    if (mylocationkey != "" &&
        mylocationkey != "location key" &&
        mylocationkey.isNotEmpty) {
      return Container(
        height: 90,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('location')
              .doc(mylocationkey)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: Text("No data available....."));
            }
            var documentData = snapshot.data?.data();
            if (documentData != null) {
              return ListTile(
                title: Text("location"),
                subtitle: Row(
                  children: [
                    Text(documentData['latitude'].toString()),
                    SizedBox(width: 20),
                    Text(documentData['longitude'].toString()),
                  ],
                ),
              );
            } else {
              return Center(child: Text("No data available"));
            }
          },
        ),
      );
    } else {
      return Container(
        height: 50,
        child: Center(
            child: MyText(
          MylableText: "Press Get Location Key To Get Shared Key",
          FontSize: 12,
          color: Colors.black,
        )),
      );
    }
  }

  _setsharedkey() async {
    print("in _setsharedkey ==========================?");
    User? currentUser = FirebaseAuth.instance.currentUser;
    // DatabaseReference userRef =
    //     FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);
    // print(currentUser!.uid);
    try {
      // Read the current data to check the current value of "sharelocation"
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(currentUser!.uid);
      userRef.once().then((snap) async {
        if (snap.snapshot.value != null) {
          bool currentShareLocation =
              (snap.snapshot.value as Map)["sharelocaiton"];
          print("???????????????????/");
          print(currentShareLocation);
          if (!currentShareLocation) {
            print("saved to the real time database==========================");
            Map<String, dynamic> updateData = {
              "sharelocaiton": true,
              "locationString": mylocationkey,
            };

            await userRef.update(updateData);

            print("User data updated successfully");
          } else if (currentShareLocation &&
              mylocationkey.isNotEmpty &&
              mylocationkey != "location key" &&
              mylocationkey != "") {
            Map<String, dynamic> updateData = {
              "locationString": mylocationkey,
            };

            await userRef.update(updateData);
          } else if (currentShareLocation && mylocationkey == "location key") {
            Map<String, dynamic> updateData = {
              "sharelocaiton": false,
              "locationString": "",
            };

            await userRef.update(updateData);
          }
        }
      });
    } catch (error) {
      print("Error: $error");
    }
  }

  void showChangeLocationKeyDialog(
      BuildContext context, String title, String messege) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(messege),
          actions: [
            TextButton(
              onPressed: () {
                if (title == "Delete Sharedkey?") {
                  setState(() {
                    FirebaseFirestore.instance
                        .collection('location')
                        .doc(mylocationkey)
                        .delete();
                    mylocationkey = "location key";
                  });
                  _setsharedkey();
                  Navigator.of(context).pop();
                } else {
                  setState(() {
                    print('is it working.....>>>>>>>>>>>.');
                    FirebaseFirestore.instance
                        .collection('location')
                        .doc(mylocationkey)
                        .delete()
                        .then((value) {
                      mylocationkey = generateRandomText(9);
                      _listenLocation();
                      _setsharedkey();
                      print('Document successfully deleted');
                    }).catchError((error) {
                      print('Error deleting document: $error');
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text("OK"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the alert
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  String generateRandomText(int length) {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    Random random = Random();
    return String.fromCharCodes(
      List.generate(length,
          (index) => characters.codeUnitAt(random.nextInt(characters.length))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
        child: ListView(
          children: [
            SizedBox(height: 5),
            Image(
                image: AssetImage('lib/images/vec1.jpg'),
                height: 400,
                width: double.infinity),
            SizedBox(height: 7),
            Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Container(
                    child: mylocationkey.isNotEmpty &&
                            mylocationkey != "location key" &&
                            mylocationkey != ""
                        ? GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: mylocationkey));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Text copied to clipboard')),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyText(
                                  MylableText: mylocationkey,
                                  FontSize: 30,
                                  color: Color.fromRGBO(0, 226, 193, 1),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.copy),
                              ],
                            ),
                          )
                        : MyText(
                            MylableText: mylocationkey,
                            FontSize: 30,
                            color: Color.fromRGBO(0, 226, 193, 1),
                          ),
                  ),
                  SizedBox(height: 28),
                  // SizedBox(height: 200),
                  datastream(),
                  GestureDetector(
                    onTap: () {
                      if (mylocationkey.isNotEmpty &&
                          mylocationkey != "" &&
                          mylocationkey != "location key") {
                        print("dddddddddddddddddddddddddd");
                        showChangeLocationKeyDialog(
                            context,
                            "Change Sharedkey?",
                            "Do you want to change the Sharedkey?");
                      } else {
                        print(mylocationkey);
                        setState(() {
                          mylocationkey = generateRandomText(9);
                        });
                        _setsharedkey();
                        print("ffffffffffffffffffffffffffff");
                        _getLocation();
                      }
                      print(mylocationkey);
                    },
                    child: const MyButton(
                      btnText: "Get Location Key",
                      backcolor: Color.fromRGBO(0, 226, 193, 1),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    child: mylocationkey.isNotEmpty &&
                            mylocationkey != "location key" &&
                            mylocationkey != ""
                        ? GestureDetector(
                            onTap: () {
                              showChangeLocationKeyDialog(
                                  context,
                                  "Delete Sharedkey?",
                                  "Do you want to Delete the Sharedkey?");
                            },
                            child: const MyButton(
                              btnText: "Delete Shared Location Key",
                              backcolor: Color.fromRGBO(192, 61, 0, 1),
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          )
                        : Text(""),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
