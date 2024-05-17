//import 'package:attendeasyadmin/Signup_Signin_Screen/login_screen.dart';
import 'package:attendeasyadmin/Signup_Signin_Screen/splash.dart';
import 'package:attendeasyadmin/utils/color_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
  // await checkInternetConnectivity();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendence App ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      
      ),
      home: SplashScreen(),
    );
  }
}
