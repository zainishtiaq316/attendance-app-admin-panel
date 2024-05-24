import 'package:attendeasyadmin/models/usermodel.dart';
import 'package:attendeasyadmin/screens/viewrecord/add_checkin.dart';
import 'package:attendeasyadmin/screens/viewrecord/add_checkout.dart';
import 'package:attendeasyadmin/screens/viewrecord/add_leaves.dart';
import 'package:attendeasyadmin/utils/color_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddAttendance extends StatefulWidget {
  UserModel user = UserModel();
  String? uid;
  String? userToken;
  AddAttendance({Key? key, required this.user}) : super(key: key);

  @override
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddAttendance> {
  String _selectedButton = 'Check In'; // Default selected button
 final nameController = TextEditingController();
  final rollNoController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final currentDateController = TextEditingController();
  final currentTimeController = TextEditingController();
  final attendanceStatusController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
   
    nameController.text = '${widget.user.firstName} ${widget.user.secondName}';
    rollNoController.text = '${widget.user.rollNo}';
    contactController.text = '${widget.user.phoneNumber}';
    emailController.text = '${widget.user.email}';
    String formattedDate = DateFormat.yMd().format(DateTime.now());
    
    String formattedTime2 = DateFormat('h:mm a').format(DateTime.now()); // e.g., "1:15 AM", "9:45 PM"

    currentDateController.text = formattedDate;
    currentTimeController.text = formattedTime2;
  }

  Future<bool> checkAttendance() async {
    // Get the current date as a string
    String currentDate = DateFormat.yMd().format(DateTime.now());
    // Get the user ID from Firebase Auth
    // Query the subcollection where you store the attendance data
    List<QuerySnapshot> snapshots = await Future.wait([
      FirebaseFirestore.instance
          .collection('MarkAttendance')
          .doc(widget.user.uid) // Use the user ID as the document ID
          .collection('CheckIn')
          .where('CurrentDate', isEqualTo: currentDate)
          .get(),
      FirebaseFirestore.instance
          .collection('MarkAttendance')
          .doc(widget.user.uid) // Use the user ID as the document ID
          .collection('CheckOut')
          .where('CurrentDate', isEqualTo: currentDate)
          .get(),
      FirebaseFirestore.instance
          .collection('MarkAttendance')
          .doc(widget.user.uid) // Use the user ID as the document ID
          .collection('leaves')
          .where('currentDate', isEqualTo: currentDate)
          .get(),
    ]);
    // Check if there are any documents in the snapshot
    if (snapshots.any((snapshot) => snapshot.docs.isNotEmpty)) {
      // The attendance or leave is already marked on the current date
      return true;
    } else {
      // The attendance or leave is not marked yet
      return false;
    }
  }
  
  
 
 
  
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        // Pass your query function as the future argument
        future: checkAttendance(),
        // Define a builder function that returns a widget based on the state of the future
        builder: (context, snapshot) {
          // Check if the future is completed
          if (snapshot.connectionState == ConnectionState.done) {
            // Check if the future returned true or false
            if (snapshot.data == true) {
              // The attendance is already marked on the current date, so return a message widget
              return Padding(
                padding: EdgeInsets.only(top: 80.0),
                child: AlertDialog(
                  title: Padding(
                    padding: EdgeInsets.only(
                        top: 20.0), // Add some padding to the top
                    child: Text('User already marked attendance today.'),
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.98,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Add Attendance",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedButton = 'Check In';
                                });
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                  color: _selectedButton == 'Check In'
                                      ? Colors.green.shade800
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: Colors.green.shade800),
                                ),
                                child: Center(
                                  child: Text(
                                    'Check In',
                                    style: TextStyle(
                                      color: _selectedButton == 'Check In'
                                          ? Colors.white
                                          : Colors.green.shade800,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedButton = 'Check Out';
                                });
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                  color: _selectedButton == 'Check Out'
                                      ? Colors.blue.shade800
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: Colors.blue.shade800),
                                ),
                                child: Center(
                                  child: Text(
                                    'Check Out',
                                    style: TextStyle(
                                      color: _selectedButton == 'Check Out'
                                          ? Colors.white
                                          : Colors.blue.shade800,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedButton = 'Leaves';
                                });
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                decoration: BoxDecoration(
                                  color: _selectedButton == 'Leaves'
                                      ? Colors.red.shade800
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border:
                                      Border.all(color: Colors.red.shade800),
                                ),
                                child: Center(
                                  child: Text(
                                    'Leaves',
                                    style: TextStyle(
                                      color: _selectedButton == 'Leaves'
                                          ? Colors.white
                                          : Colors.red.shade800,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      if (_selectedButton == "Check In")
                        checkin()
                      else if (_selectedButton == "Check Out")
                        checkout()
                      else
                        leaves()
                    ],
                  ),
                ),
              );
            }
          } //first if
          else {
            // The future is not completed yet, so return a loading indicator widget
            return Padding(
              padding: const EdgeInsets.all(80.0),
              child: Center(
                child: CircularProgressIndicator(
                  color: kPColor,
                ),
              ),
            );
          }
        });
  }

  Widget checkin() {
    print("${widget.uid}");
    print("${widget.user.token}");
    return AddCheckIn(user: widget.user,); }

  Widget checkout() {
    return AddCheckOut(user: widget.user);
  }

  Widget leaves() {
    return AddLeaves(user: widget.user,);
  }
}
