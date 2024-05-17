// ignore_for_file: deprecated_member_use

import 'package:attendeasyadmin/Admin/widget/admin-drawer.dart';
import 'package:attendeasyadmin/Signup_Signin_Screen/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/color_utils.dart';

class DeveloperContactDrawer extends StatefulWidget {
  const DeveloperContactDrawer({Key? key}) : super(key: key);

  @override
  State<DeveloperContactDrawer> createState() => _DeveloperContactDrawerState();

   static Future<void> sendMessageOnWhatsApp()async{


    final number = "+923028163676";
    final message = "Hello Zain Ishtiaq ";

    final url = 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';

    // ignore: deprecated_member_use
    if(await canLaunch(url)){
      
      // ignore: deprecated_member_use
      await launch(url);
    }else{

      throw 'Could not launch $url';
    }
   }
}

class _DeveloperContactDrawerState extends State<DeveloperContactDrawer> {
  late FocusNode myFocusNode;

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() async {
    // myFocusNode.unfocus();
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press back again to exit');
      setState(() {
        myFocusNode.unfocus();
      });
      return Future.value(false);
    }
     await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreen()));

    return Future.value(true);
  }
   @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        
       appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.blue),
            title: Text(
              "Contact",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: kPColor,
              ),
              
            ),
            centerTitle: true,
          ),
          drawer: AdminDrawerWidget(),
          
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: Zain Ishtiaq',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Email: zainishtiaq.7866@gmail.com',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Phone: +92 3028163676',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: () async {
                final Uri params = Uri(
                  scheme: 'mailto',
                  path: 'zainishtiaq.7866@gmail.com',
                  query: 'subject=Subject&body=Enter your message',
                );
                String url = params.toString();
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Could not launch email app'),
                  ));
                }
              },
             child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.05,
                decoration: BoxDecoration(color: kPColor, borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mail, color: Colors.white, size: 23,),
                      SizedBox(width: 5,),
                      Text("Email", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                )),
            
            ),
            SizedBox(height: 10.0),
          GestureDetector(
              onTap: () async {
                String phoneNumber = '+923028163676';
                String url = 'tel:$phoneNumber';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Could not launch phone app'),
                  ));
                }
              },
             
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.05,
                decoration: BoxDecoration(color: kPColor, borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: Colors.white, size: 23,),
                      SizedBox(width: 5,),
                      Text("Call", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                )),
            ),
      
              SizedBox(height: 10.0),
          
              GestureDetector(
              onTap: () async {
               await DeveloperContactDrawer.sendMessageOnWhatsApp();
              },
             child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.05,
                decoration: BoxDecoration(color: kPColor, borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mail, color: Colors.white, size: 23,),
                      SizedBox(width: 5,),
                      Text("WhatsApp", style: TextStyle(color: Colors.white),),
                    ],
                  ),
                )),
            
            ),
            
          ]),
        ),
      ),
    );
  }
}