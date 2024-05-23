import 'package:attendeasyadmin/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user_request_detail.dart';

class UserRequests extends StatefulWidget {
  const UserRequests({Key? key}) : super(key: key);

  @override
  State<UserRequests> createState() => _UserRequestsState();
}

class _UserRequestsState extends State<UserRequests> {
  late Stream<List<Map<String, dynamic>>> _userRequestsFuture;

  @override
  void initState() {
    super.initState();
    _userRequestsFuture = fetchUserRequests();
  }

  Stream<List<Map<String, dynamic>>> fetchUserRequests() async* {
    CollectionReference users =
        FirebaseFirestore.instance.collection('userRegistrationRequests');

    try {
      await for (QuerySnapshot querySnapshot in users.snapshots()) {
        List<Map<String, dynamic>> userRequests = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
        yield userRequests;
      }
    } catch (e) {
      print("Error fetching data: $e");
      yield [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "User Requests",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _userRequestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(
              color: kPColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No user requests found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var userRequest = snapshot.data![index];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserRequestDetail(userRequest: userRequest),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      elevation: 3,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shadowColor: Colors.black.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person, color: kPColor),
                                  SizedBox(width: 10),
                                  Text(
                                    '${userRequest['firstName']} ${userRequest['lastName']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: kPColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                    Icon(Icons.mail,),
                                     SizedBox(width: 10),
                                  Text(
                                    '${userRequest['email']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                    Icon(Icons.phone,),
                                     SizedBox(width: 10),
                                  Text(
                                    '${userRequest['phoneNumber']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                    Icon(Icons.message_sharp,),
                                     SizedBox(width: 10),
                                  Text(
                                    '${userRequest['message']}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
