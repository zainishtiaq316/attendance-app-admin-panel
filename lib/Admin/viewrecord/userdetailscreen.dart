import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/usermodel.dart';
import '../../utils/color_utils.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailsScreen({required this.user});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late TextEditingController rollNoController;
  bool isEditing = false;
  String assignedRollNo = '';

  @override
  void initState() {
    super.initState();
    rollNoController = TextEditingController(text: widget.user.rollNo);
    assignedRollNo = rollNoController.text;
  }

  @override
  void dispose() {
    rollNoController.dispose();
    super.dispose();
  }

  bool isAdmin() {
    // Implement your admin privileges check logic here
    // You can use Firebase Authentication or any other method to determine if the current user is an admin
    // Return true if the user is an admin, false otherwise
    // Example:
    // return FirebaseAuth.instance.currentUser?.uid == 'ADMIN_USER_UID';
    // Replace 'ADMIN_USER_UID' with the UID of the admin user in your Firebase database
    // For simplicity, this example assumes a single admin user with a known UID

    // Placeholder implementation:
    return true; // Assume all users are admins for now
  }

  void saveUpdatedRollNo(String updatedRollNo) async {
    try {
      // Update the roll number in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user.uid)
          .update({'rollNo': updatedRollNo});

      // Show a success message or perform any other desired actions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Roll No updated successfully')),
      );
    } catch (error) {
      // Show an error message or perform any error handling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update Roll No')),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "User Details",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height *
                  0.6, // Set the desired height here
              child: Card(
                elevation: 9,
                shadowColor: black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        'Name',
                        '${widget.user.firstName} ${widget.user.secondName}',
                        20,
                        FontWeight.bold,
                      ),
                      SizedBox(height: 24),
                      _buildDetailRow(
                        'Phone',
                        '${widget.user.phoneNumber}',
                        16,
                        FontWeight.bold,
                      ),
                      SizedBox(height: 24),
                      _buildDetailRow(
                        'Email',
                        '${widget.user.email}',
                        16,
                        FontWeight.bold,
                      ),
                      SizedBox(height: 24),
                      _buildDetailRow(
                        'Roll No',
                        isEditing
                            ? TextFormField(
                                controller: rollNoController,
                                decoration: InputDecoration(
                                  hintText: 'Enter Roll No',
                                ),
                              )
                            : assignedRollNo,
                        16,
                        FontWeight.bold,
                      ),
                      SizedBox(height: 24),
                      isAdmin()
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (isEditing) {
                                    // Save updated roll number
                                    saveUpdatedRollNo(rollNoController.text);
                                    assignedRollNo = rollNoController.text;
                                  }
                                  isEditing = !isEditing;
                                });
                              },
                              child: Text(isEditing ? 'Save' : 'Edit'),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      String label, dynamic value, double fontSize, FontWeight fontWeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: kPColor,
          ),
        ),
        SizedBox(height: 8),
        isEditing &&
                label ==
                    'Roll No' // Check if editing mode and the label is "Roll No"
            ? TextFormField(
                controller: rollNoController,
                decoration: InputDecoration(
                  hintText: 'Enter Roll No',
                ),
              )
            : Text(
                value.toString(),
                style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
              ),
      ],
    );
  }
}
