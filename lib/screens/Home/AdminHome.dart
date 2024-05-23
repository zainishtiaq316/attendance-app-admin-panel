import 'package:attendeasyadmin/screens/User_Requests/user_requests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendeasyadmin/screens/Edit/Edit.dart';

import 'package:attendeasyadmin/screens/leave/LeaveRequests.dart';
import 'package:attendeasyadmin/screens/viewrecord/Viewrecord.dart';
import 'package:flutter/material.dart';
import 'package:attendeasyadmin/widgets/admin-drawer.dart';
import 'package:attendeasyadmin/Signup_Signin_Screen/splash.dart';

import '../../utils/color_utils.dart';

class AdminHome extends StatefulWidget {
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  
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
    
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
              actionsIconTheme: IconThemeData(color: Colors.blue),
              title: Text(
                "Home",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: kPColor,
                ),
              ),
              
              centerTitle: true,
            ),
           backgroundColor: Colors.white,
           drawer: AdminDrawerWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset(
                  'assets/images/admin.png', // Replace with your image path
                  height: 100,
      
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              AdminButton(
                icon: Icons.list_alt,
                label: 'View All Records',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewRecord()));
                },
              ),
              SizedBox(height: 20),
              AdminButton(
                icon: Icons.edit,
                label: 'Edit Attendance',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditAttendance()));
                },
              ),
              SizedBox(height: 20),
              AdminButton(
                icon: Icons.approval,
                label: 'Leave Approval',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LeaveRequests()));
                },
              ),
              SizedBox(height: 20),

              AdminButton(
                icon: Icons.approval,
                label: 'Users Requests',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserRequests()));
                },
              ),

             
            ],
          ),
        ),
      ),
    );
  }
}

class AdminButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const AdminButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue, // Customize the button color here
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white, // Customize the icon color here
                ),
                SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white, // Customize the text color here
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
