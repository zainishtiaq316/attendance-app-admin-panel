import 'package:attendeasyadmin/screens/Profile/AdminProfile.dart';
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
   User? user = FirebaseAuth.instance.currentUser;

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() async {
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
    String? name = user?.displayName;
    String? imageUrl = user?.photoURL;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange.shade400,
          surfaceTintColor: Colors.orange.shade400,
          elevation: 10,
          actionsIconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "Admin Home",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminProfile()));
                  },
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.white,
                    backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                    child: imageUrl == null
                        ? Text(
                            name != null ? name[0].toUpperCase() : "",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        drawer: AdminDrawerWidget(),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.blue.shade900,  Colors.orange.shade300],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Image.asset(
                    'assets/images/admin.png', // Replace with your image path
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  "Welcome, Admin!",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Manage your tasks efficiently",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 30),
                AdminButton(
                  icon: Icons.list_alt,
                  label: 'View All Records',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewRecord()),
                    );
                  },
                ),
                SizedBox(height: 20),
                AdminButton(
                  icon: Icons.edit,
                  label: 'Edit Attendance',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditAttendance()),
                    );
                  },
                ),
                SizedBox(height: 20),
                AdminButton(
                  icon: Icons.approval,
                  label: 'Leave Approval',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LeaveRequests()),
                    );
                  },
                ),
                SizedBox(height: 20),
                AdminButton(
                  icon: Icons.person_add,
                  label: 'Users Requests',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserRequests()),
                    );
                  },
                ),
                SizedBox(height: 30),
              ],
            ),
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
            gradient: LinearGradient(
              colors: [Colors.blue.shade500, Colors.blue.shade800],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
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
