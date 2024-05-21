import 'package:attendeasyadmin/screens/Edit/Edit_Attendance.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../models/usermodel.dart';
// Import the user details screen

class EditAttendance extends StatefulWidget {
  const EditAttendance({Key? key}) : super(key: key);

  @override
  State<EditAttendance> createState() => _EditAttendanceState();
}

class _EditAttendanceState extends State<EditAttendance> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Attendance",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
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
                                    child: user.photoURL == null
                                        ? Text(
                                            user.firstName != null
                                                ? user.firstName![0]
                                                    .toUpperCase()
                                                : "",
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
