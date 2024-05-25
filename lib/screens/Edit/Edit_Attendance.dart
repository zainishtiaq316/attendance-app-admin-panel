import 'package:attendeasyadmin/screens/viewrecord/add_attendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../models/usermodel.dart';
import '../../utils/color_utils.dart';
import '../viewrecord/add_users.dart';

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

  String _selectedButton = 'CheckinCheckOut'; // Default selected button

  @override
  Widget build(BuildContext context) {
     Widget snapshotWidget() {
      return AddAttendance(user: widget.user,);
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
          "Edit and Delete",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
//     floatingActionButton: FloatingActionButton(
//   backgroundColor: kPColor,
//   tooltip: 'Add Attendance',
//   onPressed: () {
//     print('${widget.user.uid}');
    
//     _showSnapshot();
//   },
//   child: const Icon(Icons.add, color: Colors.white, size: 28),
// ),

      
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       showDialog(
          //         context: context,
          //         builder: (BuildContext context) {
          //           return SingleChildScrollView(
          //             child: FutureBuilder<bool>(
          //                 // Pass your query function as the future argument
          //                 future: checkAttendance(),
          //                 // Define a builder function that returns a widget based on the state of the future
          //                 builder: (context, snapshot) {
          //                   // Check if the future is completed
          //                   if (snapshot.connectionState ==
          //                       ConnectionState.done) {
          //                     // Check if the future returned true or false
          //                     if (snapshot.data == true) {
          //                       // The attendance is already marked on the current date, so return a message widget
          //                       return Padding(
          //                         padding: EdgeInsets.only(top: 80.0),
          //                         child: AlertDialog(
          //                           title: Padding(
          //                             padding: EdgeInsets.only(
          //                                 top:
          //                                     20.0), // Add some padding to the top
          //                             child: Text(
          //                                 'User already marked attendance today.'),
          //                           ),
          //                           actions: [
          //                             TextButton(
          //                               child: Text('OK'),
          //                               onPressed: () {
          //                                 Navigator.of(context).pop();
          //                               },
          //                             ),
          //                           ],
          //                         ),
          //                       );
          //                     } else {
          //                       return Container(
          //                         height:
          //                             MediaQuery.of(context).size.height * 0.7,
          //                         // Adjust the height as needed
          //                         child: SingleChildScrollView(
          //                           child: AlertDialog(
          //                             title: Text("Add Attendance"),
          //                             content: SingleChildScrollView(
          //                               child: Column(
          //                                 children: [
          //                                   TextField(
          //                                     controller: nameController,
          //                                     decoration: InputDecoration(
          //                                       labelText: "Name",
          //                                     ),
          //                                   ),
          //                                   TextField(
          //                                     controller: rollNoController,
          //                                     decoration: InputDecoration(
          //                                       labelText: "Roll No",
          //                                     ),
          //                                   ),
          //                                   TextField(
          //                                     controller: contactController,
          //                                     decoration: InputDecoration(
          //                                       labelText: "Contact",
          //                                     ),
          //                                   ),
          //                                   TextField(
          //                                     controller: emailController,
          //                                     decoration: InputDecoration(
          //                                       labelText: "Email",
          //                                     ),
          //                                   ),
          //                                   TextField(
          //                                     controller:
          //                                         attendanceStatusController,
          //                                     decoration: InputDecoration(
          //                                       labelText: "Attendance Status",
          //                                     ),
          //                                   ),
          //                                   TextField(
          //                                     controller: currentDateController,
          //                                     decoration: InputDecoration(
          //                                       labelText:
          //                                           "Current Date and Time",
          //                                     ),
          //                                   ),
          //                                 ],
          //                               ),
          //                             ),
          //                             actions: [
          //                               TextButton(
          //                                 child: Text("Add"),
          //                                 onPressed: () {
          //                                   String attendanceStatus =
          //                                       attendanceStatusController.text;
          //                                   addAttendanceRecord(
          //                                       attendanceStatus);
          //                                   Navigator.of(context).pop();
          //                                 },
          //                               ),
          //                               TextButton(
          //                                 child: Text("Cancel"),
          //                                 onPressed: () {
          //                                   Navigator.of(context).pop();
          //                                 },
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       );
          //                     }
          //                   } //first if
          //                   else {
          //                     // The future is not completed yet, so return a loading indicator widget
          //                     return Padding(
          //                       padding: const EdgeInsets.all(80.0),
          //                       child: Center(
          //                         child: CircularProgressIndicator(
          //                           color: kPColor,
          //                         ),
          //                       ),
          //                     );
          //                   }
          //                 }),
          //           );
          //         },
          //       );
          //     },
          //     child: Text("Add Attendance"),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 15, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedButton = 'CheckinCheckOut';
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: _selectedButton == "CheckinCheckOut"
                            ? Colors.green.shade800
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.green.shade800),
                      ),
                      child: Center(
                          child: Text(
                        "Check In/Out",
                        style: TextStyle(
                            color: _selectedButton == "CheckinCheckOut"
                                ? Colors.white
                                : Colors.green.shade800,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedButton = 'Leave Attendance';
                      });
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: _selectedButton == "Leave Attendance"
                            ? Colors.red.shade800
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.red.shade800),
                      ),
                      child: Center(
                          child: Text(
                        "Leaves",
                        style: TextStyle(
                            color: _selectedButton == "Leave Attendance"
                                ? Colors.white
                                : Colors.red.shade800,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: _selectedButton == 'CheckinCheckOut'
                ? buildViewAttendance()
                : buildLeaveAttendance(),
          ),
          SizedBox(height: 80)
        ],
      ),
    );
  }

  Widget buildViewAttendance() {
    return StreamBuilder(
      stream: _fetchAttendanceData(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              color: kPColor,
            ),
          );
        }

        final checkInDocs = snapshot.data!['checkIn'] as List<DocumentSnapshot>;
        final checkOutDocs =
            snapshot.data!['checkOut'] as List<DocumentSnapshot>;

        if (checkInDocs.isEmpty) {
          return Center(
            child: Text('No data found'),
          );
        }

        return ListView.builder(
          itemCount: checkInDocs.length,
          itemBuilder: (context, index) {
            final checkInData =
                checkInDocs[index].data() as Map<String, dynamic>;
            final checkOutData =
                checkOutDocs.isNotEmpty && checkOutDocs.length > index
                    ? checkOutDocs[index].data() as Map<String, dynamic>?
                    : null;

            final name = checkInData['name'];

            final rollNo = checkInData['rollNo'];
            final checkInRecordId = checkInDocs[index].id;
            final checkOutRecordId =
                (index < checkOutDocs.length) ? checkOutDocs[index].id : null;

            final attendanceStatus = checkInData['attendanceStatus'];
            final currentDate = checkInData['CurrentDate'];
            final checkInTime = checkInData['time'];
            final checkOutTime = checkOutData?['time'];

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: InkWell(
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
                              onPressed: () async {

                                print("${widget.user.uid}");
                                
                                await FirebaseFirestore.instance
                                    .collection("MarkAttendance")
                                    .doc(widget.user.uid)
                                    .collection("CheckIn")
                                    .doc(checkInRecordId)
                                    .delete();
                                await FirebaseFirestore.instance
                                    .collection("MarkAttendance")
                                    .doc(widget.user.uid)
                                    .collection("CheckOut")
                                    .doc(checkOutRecordId)
                                    .delete();
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Name: $name",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Roll No: $rollNo",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              "Attendance Status: ",
                              style: TextStyle(
                                  color: Colors.green.shade800, fontSize: 15),
                            ),
                            Text(
                              "$attendanceStatus",
                              style: TextStyle(
                                  color: Colors.green.shade800, fontSize: 15),
                            ),
                            if (checkOutTime != null)
                              Text(
                                " & Check-Out",
                                style: TextStyle(
                                    color: Colors.red.shade800, fontSize: 15),
                              ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Current Date: $currentDate",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.1,
                              height: MediaQuery.of(context).size.height * 0.04,
                              child: Image.asset(
                                "assets/images/checkin.png",
                                color: Colors.green.shade800,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(checkInTime,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 15)),
                            if (checkOutTime != null) ...[
                              SizedBox(width: 20),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                child: Image.asset(
                                  "assets/images/checkout.png",
                                  color: Colors.red.shade800,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(checkOutTime,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                            ],
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildLeaveAttendance() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("MarkAttendance")
            .doc(widget.user.uid)
            .collection("leaves")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: kPColor,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(
              color: kPColor,
            );
          }

          final confirmedLeavesDocs = snapshot.data!.docs;
           if (confirmedLeavesDocs.isEmpty) {
          return Center(
            child: Text('No data found'),
          );
        }


          return ListView.builder(
            shrinkWrap: true,
            itemCount: confirmedLeavesDocs.length,
            itemBuilder: (context, index) {
              final confirmedLeavesData =
                  confirmedLeavesDocs[index].data() as Map<String, dynamic>;
              final recordId = confirmedLeavesDocs[index].id;
              var name = confirmedLeavesData['name'];
              final rollNo = confirmedLeavesData['rollNo'];
              var attendanceStatus = confirmedLeavesData['attendanceStatus'];
              final currentDate = confirmedLeavesData['currentDate'];
              final leave = confirmedLeavesData['time'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: InkWell(
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
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection("MarkAttendance")
                                      .doc(widget.user.uid)
                                      .collection("leaves")
                                      .doc(recordId)
                                      .delete();
                                  await FirebaseFirestore.instance
                                      .collection("Confirmedleaves")
                                      .doc(widget.user.uid)
                                      .collection("attendance")
                                      .doc(recordId)
                                      .delete();
                                  await FirebaseFirestore.instance
                                      .collection("AllAttendance")
                                      .doc(recordId)
                                      .delete();
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Name: $name",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Roll No: $rollNo",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Attendance Status: $attendanceStatus",
                            style: TextStyle(
                                color: Colors.green.shade800, fontSize: 15),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Current Date: $currentDate",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.1,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                child: Image.asset(
                                  "assets/images/leave.png",
                                  color: Colors.purple.shade800,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("$leave",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15)),
                            ],
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Stream<Map<String, dynamic>> _fetchAttendanceData() {
    final checkInStream = FirebaseFirestore.instance
        .collection("MarkAttendance")
        .doc(widget.user.uid)
        .collection("CheckIn")
        .snapshots();

    final checkOutStream = FirebaseFirestore.instance
        .collection("MarkAttendance")
        .doc(widget.user.uid)
        .collection("CheckOut")
        .snapshots();

    return Rx.combineLatest2(checkInStream, checkOutStream,
        (QuerySnapshot checkInSnapshot, QuerySnapshot checkOutSnapshot) {
      return {
        'checkIn': checkInSnapshot.docs,
        'checkOut': checkOutSnapshot.docs,
      };
    });
  }
}
