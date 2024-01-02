import 'package:final_project/firebase_options.dart';
import 'package:final_project/login/loginScreen.dart';
import 'package:final_project/login/signin.dart';
import 'package:final_project/map/googlepam.dart';
import 'package:final_project/pages/home.dart';
import 'package:final_project/pages/profile.dart';
import 'package:final_project/pages/share_location.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    print('----------------------------');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }

  await Permission.locationWhenInUse.isDenied.then((valueOfPermssion) {
    if (valueOfPermssion) {
      Permission.locationWhenInUse.request();
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 1.7.10
    return MaterialApp(
      home: sign(),
    );
  }
}
