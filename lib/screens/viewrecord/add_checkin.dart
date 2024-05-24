import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../models/usermodel.dart';
import '../../utils/color_utils.dart';
import 'dart:core';

import '../../utils/loadingIndicator.dart';

class AddCheckIn extends StatefulWidget {
  UserModel user = UserModel();
   final auth = FirebaseAuth.instance;
  String? uid;
  String? userToken;
   AddCheckIn({super.key, required this.user});

  @override
  State<AddCheckIn> createState() => _markattState();
}

class _markattState extends State<AddCheckIn> {
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
    widget.user.uid = widget.auth.currentUser!.uid;
    widget.auth.currentUser!.getIdToken().then((token) {
      setState(() {
        widget.userToken = token;
      });
    });
    nameController.text = '${widget.user.firstName} ${widget.user.secondName}';
    rollNoController.text = '${widget.user.rollNo}';
    contactController.text = '${widget.user.phoneNumber}';
    emailController.text = '${widget.user.email}';
    // widget.userToken ='${widget.user.token}';
    
    
     attendanceStatusController.text = "Check-In";
    String formattedDate = DateFormat.yMd().format(DateTime.now());
    String formattedTime1 = DateFormat.j().format(DateTime.now()); // e.g., "1 AM", "9 PM"
    String formattedTime2 = DateFormat('h:mm a').format(DateTime.now()); // e.g., "1:15 AM", "9:45 PM"

    currentDateController.text = formattedDate;
    currentTimeController.text = formattedTime2;
  }
  

 Future<bool> checkAttendanceCheckIn() async {
    // Get the current date as a string
    String currentDate = DateFormat.yMd().format(DateTime.now());
    // Get the user ID from Firebase Auth
    String userId = FirebaseAuth.instance.currentUser!.uid;
    // Query the subcollection where you store the attendance data
    List<QuerySnapshot> snapshots = await Future.wait([
      FirebaseFirestore.instance
          .collection('MarkAttendance')
          .doc(userId) // Use the user ID as the document ID
          .collection('CheckIn')
          .where('CurrentDate', isEqualTo: currentDate)
          .get(),
      FirebaseFirestore.instance
          .collection('MarkAttendance')
          .doc(userId) // Use the user ID as the document ID
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
        future: checkAttendanceCheckIn(),
        // Define a builder function that returns a widget based on the state of the future
        builder: (context, snapshot) {
          // Check if the future is completed
          if (snapshot.connectionState == ConnectionState.done) {
            // Check if the future returned true or false
            if (snapshot.data == true) {
              // The attendance is already marked on the current date, so return a message widget
              return Center(
                child: Text('You have already marked your attendance today.'),
              );
            } else {
              // The attendance is not marked yet, so return an elevated button widget that submits the form data to Firebase
              return Container(
                height: MediaQuery.of(context).size.height*0.7,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(0.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          controller: nameController,
                          enabled: false,
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{3,}$');
                            if (value!.isEmpty) {
                              return ("Name can't be Empty");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Valid Name (Min. 3 Character)");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            //new
                            nameController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Name",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            // fillColor: Colors.white.withOpacity(0.3),
                            hintStyle:
                                TextStyle(color: Colors.black45.withOpacity(0.9)),
                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 2,
                            //     style: BorderStyle.solid,
                            //     color: Colors.blueGrey,
                            //   ),
                            // ),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 0,
                            //     style: BorderStyle.solid,
                            //   ),
                            // ),
                            border: InputBorder.none,
                            fillColor: Colors.orange.shade100,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          "Roll No : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          autofocus: false,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          controller: rollNoController,
                          enabled: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Roll Number",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            // fillColor: Colors.white.withOpacity(0.3),
                            hintStyle:
                                TextStyle(color: Colors.black45.withOpacity(0.9)),
                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 2,
                            //     style: BorderStyle.solid,
                            //     color: Colors.blueGrey,
                            //   ),
                            // ),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 0,
                            //     style: BorderStyle.solid,
                            //   ),
                            // ),
                            border: InputBorder.none,
                            fillColor: Colors.orange.shade100,
                          ),
                          onSaved: (value) {
                            //new
                            rollNoController.text = value!;
                          },
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return ("Roll Number can't be Empty");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Valid Roll number");
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          "Attendance Status : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          autofocus: false,
                          obscureText: false,
                          controller: attendanceStatusController,
                          enabled: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{3,}$');
                            if (value!.isEmpty) {
                              return ("Attendance Status");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Attendance Status");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            //new
                            attendanceStatusController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Attendance Status",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            // fillColor: Colors.white.withOpacity(0.3),
                            hintStyle:
                                TextStyle(color: Colors.black45.withOpacity(0.9)),
                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 2,
                            //     style: BorderStyle.solid,
                            //     color: Colors.blueGrey,
                            //   ),
                            // ),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 0,
                            //     style: BorderStyle.solid,
                            //   ),
                            // ),
                            border: InputBorder.none,
                            fillColor: Colors.orange.shade100,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          "Phone Number : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          autofocus: false,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          enabled: false,
                          controller: contactController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Phone Number",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            // fillColor: Colors.white.withOpacity(0.3),
                            hintStyle:
                                TextStyle(color: Colors.black45.withOpacity(0.9)),
                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 2,
                            //     style: BorderStyle.solid,
                            //     color: Colors.blueGrey,
                            //   ),
                            // ),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 0,
                            //     style: BorderStyle.solid,
                            //   ),
                            // ),
                
                            border: InputBorder.none,
                            fillColor: Colors.orange.shade100,
                          ),
                          onSaved: (value) {
                            //new
                            contactController.text = value!;
                          },
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            RegExp regex = new RegExp(r'^.{11,}$');
                            if (value!.isEmpty) {
                              return ("Phone Number can't be Empty");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Valid Phone number");
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          "Email ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          autofocus: false,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          enabled: false,
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your Email");
                            }
                            //reg expression for email validation
                            if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please Enter a valid email");
                            }
                            return null;
                          },
                          onSaved: (value) {
                            //new
                            emailController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Email : ",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            // fillColor: Colors.white.withOpacity(0.3),
                            hintStyle:
                                TextStyle(color: Colors.black45.withOpacity(0.9)),
                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 2,
                            //     style: BorderStyle.solid,
                            //     color: Colors.blueGrey,
                            //   ),
                            // ),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 0,
                            //     style: BorderStyle.solid,
                            //   ),
                            // ),
                
                            border: InputBorder.none,
                            fillColor: Colors.orange.shade100,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          "Curent Date : ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.datetime,
                          autofocus: false,
                          obscureText: false,
                          enableSuggestions: true,
                          autocorrect: true,
                          controller: currentDateController,
                          cursorColor: Colors.black45,
                          style:
                              TextStyle(color: Colors.black45.withOpacity(0.9)),
                          enabled: false,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "field required";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            //new
                            currentDateController.text = value!;
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            hintText: "Current Date",
                            filled: true,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            // fillColor: Colors.white.withOpacity(0.3),
                            hintStyle:
                                TextStyle(color: Colors.black45.withOpacity(0.9)),
                            // focusedBorder: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 2,
                            //     style: BorderStyle.solid,
                            //     color: Colors.blueGrey,
                            //   ),
                            // ),
                            // border: OutlineInputBorder(
                            //   borderRadius: BorderRadius.circular(10),
                            //   borderSide: const BorderSide(
                            //     width: 0,
                            //     style: BorderStyle.solid,
                            //   ),
                            // ),
                            border: InputBorder.none,
                            fillColor: Colors.orange.shade100,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final name = nameController.text;
                            final rollNo = rollNoController.text;
                            final email = emailController.text;
                            final contact = contactController.text;
                            final attendanceStatus =
                                attendanceStatusController.text;
                            final currentDate = currentDateController.text;
                            final  time = currentTimeController.text;
                
                            if (rollNo.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Missing Roll Number"),
                                    content: Text(
                                        "Please wait for the admin to assign you a roll number."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "OK",
                                          style: TextStyle(color: kPColor),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (formKey.currentState!.validate()) {
                               String id = FirebaseFirestore.instance.collection('users').doc().id;
                                print("${DateTime.now().millisecondsSinceEpoch.toString()}, ${name}, ${rollNo}, ${email}, ${time}, ${contact}, ${attendanceStatus}, ${currentDate}, ${widget.userToken}, ${widget.uid}  ");
                             
                              loader(context);
                              // await joinUplaod(
                              //   DateTime.now().millisecondsSinceEpoch.toString(),
                              //   name,
                              //   rollNo,
                              //   email,
                              //   time,
                              //   contact,
                              //   attendanceStatus,
                              //   currentDate,
                              //   widget.userToken!,
                              //   widget.user.uid!,
                                
                              // ).whenComplete(() {
                              //   Navigator.pop(context);
                
                              //   showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return AlertDialog(
                              //         title: Text("Attendance"),
                              //         content: Text("Marked Successfully"),
                              //         actions: [
                              //           TextButton(
                              //             onPressed: () {
                              //               Navigator.pop(context);
                              //               Navigator.pop(context);
                              //             },
                              //             child: Text(
                              //               "OK",
                              //               style: TextStyle(color: kPColor),
                              //             ),
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   );
                              // });
                           
                           
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.shade200,
                                      offset: Offset(2, 4),
                                      blurRadius: 5,
                                      spreadRadius: 2)
                                ],
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xfffbb448),
                                      Color(0xfff7892b)
                                    ])),
                            child: Text(
                              "Submit",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          } else {
            // The future is not completed yet, so return a loading indicator widget
            return Center(
              child: CircularProgressIndicator(color: kPColor,),
             
            );
          }
        },
      )
   ;
  }
}





Future<void> joinUplaod(
  String id,
  String name,
  String rollNo,
  String email,
  String time,
  String contact,
  String attendanceStatus,
  String currentDate,
  String userToken,
  String uid,
) async {
  // final uid = FirebaseAuth.instance.currentUser!.uid;

  // final image = FirebaseAuth.instance.currentUser!.photoURL;
  await FirebaseFirestore.instance
      .collection("MarkAttendance")
      .doc(uid)
      .collection("CheckIn")
      .doc(id)
      .set({
    'id': id,
    'name': name,
    'rollNo': rollNo,
    'contact': contact,
    'email': email,
    'time':time,
    'attendanceStatus': attendanceStatus,
    'CurrentDate': currentDate,
    'userId': uid,
    'userToken': userToken,
  });
}