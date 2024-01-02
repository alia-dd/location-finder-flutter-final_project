// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MaterialApp(home: MyApp()));
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   StreamSubscription<Position>? _locationSubscription;

//   @override
//   void initState() {
//     super.initState();
//     _requestPermission();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Live Location Tracker'),
//       ),
//       body: Column(
//         children: [
//           TextButton(
//             onPressed: () {
//               _getLocation();
//             },
//             child: Text('Add My Location'),
//           ),
//           TextButton(
//             onPressed: () {
//               _listenLocation();
//             },
//             child: Text('Enable Live Location'),
//           ),
//           TextButton(
//             onPressed: () {
//               _stopListening();
//             },
//             child: Text('Stop Live Location'),
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream:
//                   FirebaseFirestore.instance.collection('location').snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 return ListView.builder(
//                   itemCount: snapshot.data?.docs.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title:
//                           Text(snapshot.data!.docs[index]['name'].toString()),
//                       subtitle: Row(
//                         children: [
//                           Text(snapshot.data!.docs[index]['latitude']
//                               .toString()),
//                           SizedBox(
//                             width: 20,
//                           ),
//                           Text(snapshot.data!.docs[index]['longitude']
//                               .toString()),
//                         ],
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(Icons.directions),
//                         onPressed: () {
//                           // Navigator.of(context).push(MaterialPageRoute(
//                           //     builder: (context) =>
//                           //         MyMap(snapshot.data!.docs[index].id)));
//                         },
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   _getLocation() async {
//     try {
//       Position _position = await Geolocator.getCurrentPosition();
//       await FirebaseFirestore.instance.collection('location').doc('user1').set({
//         'latitude': _position.latitude,
//         'longitude': _position.longitude,
//         'name': 'john',
//       }, SetOptions(merge: true));
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _listenLocation() async {
//     _locationSubscription = Geolocator.getPositionStream(
//       desiredAccuracy: LocationAccuracy.best,
//       distanceFilter: 10, // in meters
//     ).handleError((onError) {
//       print(onError);
//       _locationSubscription?.cancel();
//       setState(() {
//         _locationSubscription = null;
//       });
//     }).listen((Position currentLocation) async {
//       await FirebaseFirestore.instance.collection('location').doc('user1').set({
//         'latitude': currentLocation.latitude,
//         'longitude': currentLocation.longitude,
//         'name': 'john',
//       }, SetOptions(merge: true));
//     });
//   }

//   _stopListening() {
//     _locationSubscription?.cancel();
//     setState(() {
//       _locationSubscription = null;
//     });
//   }

//   _requestPermission() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       print('Permission granted');
//     } else if (status.isDenied) {
//       _requestPermission();
//     } else if (status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }
// }




// getCurrentLiveLocationOfUser() async {
//     Position positionOfUser = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.bestForNavigation);
//     currentPostionOfUser = positionOfUser;
//     LatLng positionOfUserInLatLng =
//         LatLng(currentPostionOfUser!.latitude, currentPostionOfUser!.longitude);

//     CameraPosition cameraPosition =
//         CameraPosition(target: positionOfUserInLatLng, zoom: 15);
//     controllerGoogleMap!
//         .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
//   }
  // _getLocation() async {
  //   try {
  //     final loc.LocationData _locationResult = await location.getLocation();
  //     User? user = FirebaseAuth.instance.currentUser;
  //     String? uid = user?.uid;
  //     useId = uid!;
  //     print("......................./....///,");
  //     await FirebaseFirestore.instance.collection('location').doc(uid).set({
  //       'latitude': _locationResult.latitude,
  //       'longitude': _locationResult.longitude,
  //     }, SetOptions(merge: true));
  //   } catch (e) {
  //     print(e);
  //   }
  // }


  //   marker() {
  //   List<String> groupsToRemove = [];
  //   if (mygroup.isNotEmpty) {
  //     for (String groupKey in mygroup) {
  //       FirebaseFirestore.instance
  //           .collection('location')
  //           .doc(groupKey)
  //           .get()
  //           .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
  //         if (snapshot.exists) {
  //           double latitude = snapshot.data()?['latitude'] ?? 0.0;
  //           double longitude = snapshot.data()?['longitude'] ?? 0.0;

  //           _marker.add(
  //             Marker(
  //               markerId: MarkerId(groupKey), // Using the groupKey directly
  //               position: LatLng(latitude, longitude),
  //             ),
  //           );
  //           groupsToRemove.add(groupKey);
  //         } else {
  //           print("Document does not exist for $groupKey");
  //         }
  //       }).catchError((error) {
  //         print("Error getting document: $error");
  //       });
  //     }
  //     for (String groupKeyToRemove in groupsToRemove) {
  //       mygroup.remove(groupKeyToRemove);
  //     }
  //   }
  // }


  // registerNewUser() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) =>
  //         loadingDialiog(messageText: "Registering your account......"),
  //   );
  //   final User? userFirebase = (await FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(
  //     email: emailIdTextEditingController.text.trim(),
  //     password: passwordTextEditingController.text.trim(),
  //   )
  //           .catchError((errmsg) {
  //     Navigator.pop(context);
  //     cMethods.displaySnackBar(errmsg.toString(), context);
  //   }))
  //       .user;
  //   if (!context.mounted) return;
  //   Navigator.pop(context);
  //   String email = emailIdTextEditingController.text.trim();
  //   String pass = passwordTextEditingController.text.trim();
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => registerUser(
  //                 user: userFirebase,
  //                 email: email,
  //                 password: pass,
  //               )));
  // }



  // signInUser() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) =>
  //         loadingDialiog(messageText: "Loggin In......"),
  //   );
  //   try {
  //     final UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailIdTextEditingController.text.trim(),
  //       password: passwordTextEditingController.text.trim(),
  //     );

  //     if (userCredential.user != null) {
  //       print('----------------------.....................------');
  //       DatabaseReference userRef = FirebaseDatabase.instance
  //           .ref()
  //           .child("users")
  //           .child(userCredential.user!.uid);
  //       userRef.once().then((snap) {
  //         print('---------------------->>>>>>>>>>>>>>>>>>>>>-----');
  //         if (snap.snapshot.value != null) {
  //           print('----------------------<<<<<<<<<<<<<<<<<<<<<<<-----');
  //           userName = (snap.snapshot.value as Map)["userName"];
  //           mapstyle = (snap.snapshot.value as Map)["mapTheme"];
  //           useId = (snap.snapshot.value as Map)["id"];
  //           print('----------------------------');
  //           Navigator.push(
  //               context, MaterialPageRoute(builder: (context) => home()));
  //         } else {
  //           FirebaseAuth.instance.signOut();
  //           cMethods.displaySnackBar(
  //               "This User Doesn't Exist Go Sign Up to Continue", context);
  //         }
  //       });
  //     }
  //   } catch (error) {
  //     // Handle the error here, you can display a proper error message
  //     Navigator.pop(context);
  //     cMethods.displaySnackBar(
  //         "This Email Doesn't Exist Go Sign Up to Continue", context);
  //   }
  // }


     // DataSnapshot snapshot = (await userRef.once()) as DataSnapshot;
      // Map<dynamic, dynamic>? userData = snapshot.value as Map?;
      // print("UserData: $userData");
      // if (userData != null) {
      //   bool currentShareLocation = userData["sharelocaiton"];
      //   /////////////////problem here
      //   print("???????????????????/");
      //   print(currentShareLocation);
      //   // Check that the sharelocation is currently false
      //   if (!currentShareLocation) {
      //     print("saved to the real time database==========================");
      //     Map<String, dynamic> updateData = {
      //       "sharelocation": true,
      //       "locationString": mylocationkey,
      //     };

      //     await userRef.update(updateData);

      //     print("User data updated successfully");
      //   } else if (currentShareLocation && mylocationkey == "location key") {
      //     Map<String, dynamic> updateData = {
      //       "sharelocation": false,
      //       "locationString": "",
      //     };

      //     await userRef.update(updateData);
      //   }
      // }


      // User? currentUser = FirebaseAuth.instance.currentUser;
      // FirebaseFirestore.instance
      //     .collection('location')
      //     .doc(currentUser!.uid)
      //     .collection('mygroupkey')
      //     .get()
      //     .then(
      //   (QuerySnapshot<Map<String, dynamic>> snapshot) {
      //     for (QueryDocumentSnapshot<Map<String, dynamic>> doc
      //         in snapshot.docs) {
      //       doc.reference.delete();
      //     }
      //     print("drl mark----------------ll");
      //   },
      // );



    //   return showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('Enter Shared Key'),
    //       content: Container(
    //         height: 200,
    //         child: Column(
    //           children: [
    //             Image(
    //                 image: AssetImage('lib/images/vec4.png'),
    //                 height: 400,
    //                 width: double.infinity),
    //             SizedBox(height: 7),
    //             TextField(
    //               onChanged: (value) {
    //                 enteredString = value;
    //               },
    //             ),
    //           ],
    //         ),
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: Text('Cancel'),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             mygroup.add(enteredString);

    //             saveSetToFirestore(mygroup);

    //             Navigator.of(context).pop();
    //           },
    //           child: Text('OK'),
    //         ),
    //       ],
    //     );
    //   },
    // );