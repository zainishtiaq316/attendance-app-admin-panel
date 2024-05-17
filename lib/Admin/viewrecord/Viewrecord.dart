import 'package:attendeasyadmin/Admin/viewrecord/userdetailscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../models/usermodel.dart';
// Import the user details screen

class ViewRecord extends StatefulWidget {
  const ViewRecord({Key? key}) : super(key: key);

  @override
  State<ViewRecord> createState() => _ViewRecordState();
}

class _ViewRecordState extends State<ViewRecord> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "View Record",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
    );
  }
}
