import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/color_utils.dart';
import '../../utils/loadingIndicator.dart';
import '../utils/assureDialog.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  bool stopSend = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendEmail();

      timer = Timer.periodic(Duration(seconds: 3), (_) => checkVerification());
    }
  }

  Future checkVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        stopSend = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        stopSend = true;
      });
    } catch (e) {
      await Fluttertoast.showToast(
        msg: 'Something went wrong',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return isEmailVerified
        ? LoginScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: kPColor,
              centerTitle: true,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                "Email Verification",
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.white,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text(
                    "Verification email has been sent to your email",
                    style: GoogleFonts.lato(
                        color: black, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "(if not found check spam folder in Gmail app)",
                  style: GoogleFonts.lato(
                    color: black,
                  ),
                ),
                const SizedBox(height: 20.0),
                InkWell(
                  onTap: () async {
                    loader(context);
                    //  DialogClass.signout();
                    assuranceDialog(context, () async {
                      await FirebaseAuth.instance.signOut().whenComplete(() {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false);
                      });
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: width * 0.1, vertical: height * 0.005),
                    height: height * 0.05,
                    decoration: BoxDecoration(
                        color: kPColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
