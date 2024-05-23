import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRequestDetail extends StatelessWidget {
  final Map<String, dynamic> userRequest;

  UserRequestDetail({required this.userRequest});

  Future<void> deleteUserRequest(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('userRegistrationRequests').doc(docId).delete();
    } catch (e) {
      print("Error deleting document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Request Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First Name: ${userRequest['firstName']}'),
            Text('Last Name: ${userRequest['lastName']}'),
            Text('Email: ${userRequest['email']}'),
            Text('Phone Number: ${userRequest['phoneNumber']}'),
            Text('Message: ${userRequest['message']}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                print("${userRequest['id']}");
                await deleteUserRequest(userRequest['id']);
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
