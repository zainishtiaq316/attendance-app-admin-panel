import 'dart:async';

import 'package:attendeasyadmin/screens/Edit/Edit_Attendance.dart';
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

class AllAttandence extends StatefulWidget {
  const AllAttandence({Key? key}) : super(key: key);

  @override
  State<AllAttandence> createState() => _ViewRecordState();
}

class _ViewRecordState extends State<AllAttandence> {
  Stream<List<UserModel>> fetchAllUsersStream() {
    // Create a StreamController to manage the stream
    StreamController<List<UserModel>> _controller =
        StreamController<List<UserModel>>();

    // Whenever there's a change in the collection, update the stream
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((querySnapshot) {
      List<UserModel> allUsers = [];
      if (querySnapshot.docs.isNotEmpty) {
        List<QueryDocumentSnapshot> documents = querySnapshot.docs;
        for (var document in documents) {
          Map<String, dynamic> userData =
              document.data() as Map<String, dynamic>;
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
      // Add the updated list of users to the stream
      _controller.add(allUsers);
    });

    // Return the stream from the StreamController
    return _controller.stream;
  }

  Stream<List<UserModel>> fetchAllUsers() {
  return FirebaseFirestore.instance
      .collection('users')
      .where('role', isNotEqualTo: 'Admin')
      .snapshots()
      .map((querySnapshot) {
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
              rollNo: userData['rollNo'],
            );
            allUsers.add(user);
          }
        }
        return allUsers;
      });
}

  void navigateToUserDetails(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditAttendanceScreen(user: user),
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
        backgroundColor: Colors.orange.shade400,
        surfaceTintColor: Colors.orange.shade400,
              actionsIconTheme: IconThemeData(color: Colors.blue),
              title: Text(
                "All Attendance",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              centerTitle: true,
            ),
           drawer: AdminDrawerWidget(), body: Container(
             decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade400, Colors.blue.shade900,  Colors.orange.shade300],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),),
        child: StreamBuilder<List<UserModel>>(
          stream: fetchAllUsers(),
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
                      surfaceTintColor: Colors.white,
                      elevation: 3,
                      margin:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shadowColor: Colors.black,
                      child: ListTile(
                        onTap: () {
                          navigateToUserDetails(user);
                        },
                        title: Container(
                          
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                      radius: 40.0,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: user.photoURL != null
                                          ? NetworkImage(user.photoURL!)
                                          : null,
                                      child: user.photoURL!.isEmpty
                                          ? Text(
                                              "${user.firstName?[0]}",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            )
                                          : null,
                                          
                                    ), SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${user.firstName} ${user.secondName}',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        'Roll No : ${user.rollNo}',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${user.email}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${user.phoneNumber}',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
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
   
    ));
  }
}
