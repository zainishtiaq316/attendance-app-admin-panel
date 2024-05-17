import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/usermodel.dart';
import '../../utils/color_utils.dart';

// ignore: must_be_immutable
class EditAttendanceScreen extends StatefulWidget {
  UserModel user = UserModel();
  final auth = FirebaseAuth.instance;
  String? uid;
  String? userToken;

  EditAttendanceScreen({required this.user});

  @override
  _EditAttendanceScreenState createState() => _EditAttendanceScreenState();
}

class _EditAttendanceScreenState extends State<EditAttendanceScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController rollNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController attendanceStatusController = TextEditingController();
  TextEditingController currentDateController = TextEditingController();

  Future<void> deleteAttendanceRecord(
      String collection, String recordId) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(widget.user.uid)
        .collection("attendance")
        .doc(recordId)
        .delete();
  }

  Future<void> updateAttendanceRecord(
      String collection, String recordId, String name) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(widget.user.uid)
        .collection("attendance")
        .doc(recordId)
        .update({
      'name': name,
    });
  }

  Future<void> addAttendanceRecord(String attendanceStatus) async {
    String rollNo = rollNoController.text;
    String CurrentDate = DateFormat.yMd().format(DateTime.now());
    String id = FirebaseFirestore.instance.collection('users').doc().id;

    if (attendanceStatus == 'Present' || attendanceStatus == 'Absent') {
      await FirebaseFirestore.instance
          .collection("MarkAttendance")
          .doc(widget.user.uid)
          .collection("attendance")
          .doc(id)
          .set({
        'id': id,
        'name': '${widget.user.firstName} ${widget.user.secondName}',
        'rollNo': rollNo,
        'contact': widget.user.phoneNumber,
        'email': widget.user.email,
        'attendanceStatus': attendanceStatus,
        'CurrentDate': CurrentDate,
        'userId': widget.uid,
        'userToken': widget.userToken,
      });
    } else if (attendanceStatus == 'Leave') {
      await FirebaseFirestore.instance
          .collection("Confirmedleaves")
          .doc(widget.user.uid)
          .collection("attendance")
          .doc(id)
          .set({
        'id': id,
        'name': '${widget.user.firstName} ${widget.user.secondName}',
        'rollNo': rollNo,
        'contact': widget.user.phoneNumber,
        'email': widget.user.email,
        'attendanceStatus': attendanceStatus,
        'currentDate': CurrentDate,
        'userId': widget.uid,
        'userToken': widget.userToken,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.uid = widget.auth.currentUser!.uid;
    widget.auth.currentUser!.getIdToken().then((token) {
      setState(() {
        widget.userToken = token;
      });
    });
    nameController.text = '${widget.user.firstName} ${widget.user.secondName}';
    rollNoController.text = rollNoController.text;
    contactController.text = '${widget.user.phoneNumber}';
    emailController.text = '${widget.user.email}';
    currentDateController.text = DateFormat.yMd().format(DateTime.now());
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
          .collection('attendance')
          .where('CurrentDate', isEqualTo: currentDate)
          .get(),
      FirebaseFirestore.instance
          .collection('Confirmedleaves')
          .doc(widget.user.uid) // Use the user ID as the document ID
          .collection('attendance')
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit and Delete",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: FutureBuilder<bool>(
                          // Pass your query function as the future argument
                          future: checkAttendance(),
                          // Define a builder function that returns a widget based on the state of the future
                          builder: (context, snapshot) {
                            // Check if the future is completed
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // Check if the future returned true or false
                              if (snapshot.data == true) {
                                // The attendance is already marked on the current date, so return a message widget
                                return Padding(
                                  padding: EdgeInsets.only(top: 80.0),
                                  child: AlertDialog(
                                    title: Padding(
                                      padding: EdgeInsets.only(
                                          top:
                                              20.0), // Add some padding to the top
                                      child: Text(
                                          'User already marked attendance today.'),
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  // Adjust the height as needed
                                  child: SingleChildScrollView(
                                    child: AlertDialog(
                                      title: Text("Add Attendance"),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                labelText: "Name",
                                              ),
                                            ),
                                            TextField(
                                              controller: rollNoController,
                                              decoration: InputDecoration(
                                                labelText: "Roll No",
                                              ),
                                            ),
                                            TextField(
                                              controller: contactController,
                                              decoration: InputDecoration(
                                                labelText: "Contact",
                                              ),
                                            ),
                                            TextField(
                                              controller: emailController,
                                              decoration: InputDecoration(
                                                labelText: "Email",
                                              ),
                                            ),
                                            TextField(
                                              controller:
                                                  attendanceStatusController,
                                              decoration: InputDecoration(
                                                labelText: "Attendance Status",
                                              ),
                                            ),
                                            TextField(
                                              controller: currentDateController,
                                              decoration: InputDecoration(
                                                labelText:
                                                    "Current Date and Time",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text("Add"),
                                          onPressed: () {
                                            String attendanceStatus =
                                                attendanceStatusController.text;
                                            addAttendanceRecord(
                                                attendanceStatus);
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
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
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          }),
                    );
                  },
                );
              },
              child: Text("Add Attendance"),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("MarkAttendance")
                .doc(widget.user.uid)
                .collection("attendance")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return Text('No data found');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              final markAttendanceDocs = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: markAttendanceDocs.length,
                itemBuilder: (context, index) {
                  final markAttendanceData =
                      markAttendanceDocs[index].data() as Map<String, dynamic>;
                  final recordId = markAttendanceDocs[index].id;
                  var name = markAttendanceData['name'];
                  final rollNo = markAttendanceData['rollNo'];
                  var attendanceStatus = markAttendanceData['attendanceStatus'];
                  final currentDate = markAttendanceData['CurrentDate'];

                  return Card(
                    child: InkWell(
                      onTap: () {
                        // Perform edit operation here
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Edit Attendance"),
                              content: TextField(
                                controller: TextEditingController(text: name),
                                onChanged: (value) {
                                  name = value;
                                },
                                decoration: InputDecoration(
                                  labelText: "Edit Name",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text("Update"),
                                  onPressed: () {
                                    updateAttendanceRecord(
                                      "MarkAttendance",
                                      recordId,
                                      name,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onLongPress: () {
                        // Perform delete operation here
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Delete Attendance"),
                              content: Text(
                                  "Are you sure you want to delete this attendance record?"),
                              actions: [
                                TextButton(
                                  child: Text("Delete"),
                                  onPressed: () {
                                    deleteAttendanceRecord(
                                      "MarkAttendance",
                                      recordId,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          ListTile(
                            title: Text("Name: $name"),
                            subtitle: Text(
                                "Roll No: $rollNo    Attendance Status: $attendanceStatus      Current Date: $currentDate"),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Confirmedleaves")
                .doc(widget.user.uid)
                .collection("attendance")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return Text('No data found');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              final confirmedLeavesDocs = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: confirmedLeavesDocs.length,
                itemBuilder: (context, index) {
                  final confirmedLeavesData =
                      confirmedLeavesDocs[index].data() as Map<String, dynamic>;
                  final recordId = confirmedLeavesDocs[index].id;
                  var name = confirmedLeavesData['name'];
                  final rollNo = confirmedLeavesData['rollNo'];
                  var attendanceStatus =
                      confirmedLeavesData['attendanceStatus'];
                  final currentDate = confirmedLeavesData['currentDate'];

                  return Card(
                    child: InkWell(
                      onTap: () {
                        // Perform edit operation here
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Edit Attendance"),
                              content: TextField(
                                controller: TextEditingController(text: name),
                                onChanged: (value) {
                                  name = value;
                                },
                                decoration: InputDecoration(
                                  labelText: "Edit Name",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text("Update"),
                                  onPressed: () {
                                    updateAttendanceRecord(
                                      "Confirmedleaves",
                                      recordId,
                                      name,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onLongPress: () {
                        // Perform delete operation here
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Delete Attendance"),
                              content: Text(
                                  "Are you sure you want to delete this attendance record?"),
                              actions: [
                                TextButton(
                                  child: Text("Delete"),
                                  onPressed: () {
                                    deleteAttendanceRecord(
                                      "Confirmedleaves",
                                      recordId,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          ListTile(
                            title: Text("Name: $name"),
                            subtitle: Text(
                                "Roll No: $rollNo    Attendance Status: $attendanceStatus      Current Date: $currentDate"),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
