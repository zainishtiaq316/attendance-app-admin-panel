import 'package:attendeasyadmin/Signup_Signin_Screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Set a delay for the splash screen
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the home screen after the delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child: Column(children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30.0),
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Text(
              "Developed by Zain Ishtiaq",
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          )
        ]),
      ),
    );
  }
}
