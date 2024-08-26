
import 'package:firebase/Screens/VideoCall/VideoCallPage.dart';
import 'package:firebase/Screens/YourLocation.dart';
import 'package:firebase/firebase_options.dart';
import 'package:firebase/Screens/SignUpPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Firebase App',
      debugShowCheckedModeBanner: false,
      home: SignupPage(),
    );
  }
}
