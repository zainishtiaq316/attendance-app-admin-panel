import 'package:attendeasyadmin/screens/viewrecord/add_users.dart';
import 'package:attendeasyadmin/screens/viewrecord/userdetailscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../utils/color_utils.dart';
import '../../models/usermodel.dart';

class ViewRecord extends StatefulWidget {
  const ViewRecord({Key? key}) : super(key: key);

  @override
  State<ViewRecord> createState() => _ViewRecordState();
}

class _ViewRecordState extends State<ViewRecord> {
  Stream<List<UserModel>> fetchAllUsers() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('role', isNotEqualTo: 'Admin')
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      List<UserModel> allUsers = [];
      querySnapshot.docs.forEach((document) {
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
      });
      return allUsers;
    });
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      // Delete user from Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await FirebaseFirestore.instance
          .collection("MarkAttendance")
          .doc(user.uid)
          .delete();
      await FirebaseFirestore.instance
          .collection("Confirmedleaves")
          .doc(user.uid)
          .delete();

      await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  void navigateToUserDetails(UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget snapshotWidget() {
      return AddUsers();
    }

    void _showSnapshot() {
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          useSafeArea: true,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(25),
              topStart: Radius.circular(25),
            ),
          ),
          builder: (BuildContext context) => AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: snapshotWidget(),
              ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Users",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSnapshot();
        },
        tooltip: 'Increment',
        focusColor: kPColor,
        splashColor: kPColor,
        backgroundColor: kPColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
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
                                          
                                    ),

                                 
                                    SizedBox(
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
    );
  }
}
