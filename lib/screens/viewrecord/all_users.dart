import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendeasyadmin/screens/viewrecord/userdetailscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:attendeasyadmin/Signup_Signin_Screen/splash.dart';

import '../../../utils/color_utils.dart';
import '../../models/usermodel.dart';
import '../../widgets/admin-drawer.dart';
// Import the user details screen

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _ViewRecordState();
}

class _ViewRecordState extends State<AllUsers> {
  Future<List<UserModel>> fetchAllUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    List<UserModel> allUsers = [];
    if (querySnapshot.docs.isNotEmpty) {
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;
      for (var document in documents) {
        Map<String, dynamic> userData = document.data() as Map<String, dynamic>;
        UserModel user = UserModel(
            uid: userData['uid'],
            firstName: userData['firstName'],
            secondName: userData['secondName'],
            phoneNumber: userData['phoneNumber'],
            email: userData['email'],
            photoURL: userData['photoURL'],
            rollNo: userData['rollNo']);
        allUsers.add(user);
      }
    }
    return allUsers;
  }

  void navigateToUserDetails(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(user: user),
      ),
    );
  }
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
            "All Users",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: kPColor,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        drawer: AdminDrawerWidget(),
        body: Container(
          child: FutureBuilder<List<UserModel>>(
            future: fetchAllUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<UserModel>? users = snapshot.data;
                if (users != null && users.isNotEmpty) {
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      UserModel user = users[index];
                      return Card(
                        color: Colors.white,
                        elevation: 3,
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shadowColor: black,
                        child: ListTile(
                          onTap: () {
                            navigateToUserDetails(user);
                          },
                          title: Center(
                            child: Text(
                              '${user.firstName} ${user.secondName}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
      
                          // Add more user details if needed
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No users found'));
                }
              }
            },
          ),
        ),
      ),
    );
  }


}
