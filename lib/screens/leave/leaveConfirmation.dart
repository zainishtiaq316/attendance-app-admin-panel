import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:attendeasyadmin/screens/Home/AdminHome.dart';

import '../../utils/color_utils.dart';
import '../../utils/loadingIndicator.dart';
import '../Home/AdminBN.dart';

class leaveConfiramtion extends StatefulWidget {
  const leaveConfiramtion({
    super.key,
    required this.id,
    required this.name,
    required this.rollNo,
    required this.email,
    required this.contact,
    required this.attendanceStatus,
    required this.currentDate,
    required this.description,
    required this.time,
    required this.userId,
    required this.userToken,
  });
  final String id;
  final String name;
  final String rollNo;
  final String email;
  final String contact;
  final String attendanceStatus;
  final String time;
  final String currentDate;
  final String description;
  final String userId;
  final String userToken;

  @override
  State<leaveConfiramtion> createState() => _leaveConfiramtionState();
}

class _leaveConfiramtionState extends State<leaveConfiramtion> {
  final commentController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  Future<void> uplaodConfirmedLeave(
      String id,
      String name,
      String rollNo,
      String email,
      String time,
      String contact,
      String attendanceStatus,
      String currentDate,
      String description,
      String userId,
      String userToken) async {
    await FirebaseFirestore.instance
        .collection("Confirmedleaves")
        .doc(userId)
        .collection("attendance")
        .doc(id)
        .set({
      'id': id,
      'name': name,
      'rollNo': rollNo,
      'email': email,
      'time' : time,
      'contact': contact,
      'attendanceStatus': attendanceStatus,
      'currentDate': currentDate,
      'description': description,
      'userId': userId,
      'userToken': userToken,
    });
     await FirebaseFirestore.instance
        .collection("MarkAttendance")
        .doc(userId)
        .collection("leaves")
        .doc(id)
        .set({
      'id': id,
      'name': name,
      'rollNo': rollNo,
      'email': email,
      'time':time,
      'contact': contact,
      'attendanceStatus': attendanceStatus,
      'currentDate': currentDate,
      'description': description,
      'userId': userId,
      'userToken': userToken,
    });
  }

  Future<void> allConfirmedLeave(
      String id,
      String name,
      String rollNo,
      String email,
      String time,
      String contact,
      String attendanceStatus,
      String currentDate,
      String description,
      String userId,
      String userToken) async {
    // final uid = FirebaseAuth.instance.currentUser!.uid;
    // final image = FirebaseAuth.instance.currentUser!.photoURL;
    await FirebaseFirestore.instance.collection("AllAttendance").doc(id).set({
      'id': id,
      'name': name,
      'rollNo': rollNo,
      'email': email,
      'time':time,
      'contact': contact,
      'attendanceStatus': attendanceStatus,
      'currentDate': currentDate,
      'description': description,
      'userId': userId,
      'userToken': userToken,
    });
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
    commentController.text = "Leave Approved";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Leave Approval",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.text,
                autofocus: false,
                obscureText: false,
                enableSuggestions: true,
                autocorrect: true,
                cursorColor: Colors.black45,
                style: TextStyle(color: Colors.black45.withOpacity(0.9)),
                enabled: true,
                controller: commentController,
                validator: (v) {
                  if (v!.isEmpty) {
                    return "field required";
                  }
                  return null;
                },
                onSaved: (value) {
                  //new
                  commentController.text = value!;
                },
                textInputAction: TextInputAction.next,
              decoration: InputDecoration(
         
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Enter Comment",
        
          floatingLabelBehavior: FloatingLabelBehavior.never,
          
           hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
           border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true)  ),
              const SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: GestureDetector(
                  onTap: () async {
                    //final comment = commentController.text.trim();
                    if (formkey.currentState!.validate()) {
                      loader(context);
                      await uplaodConfirmedLeave(
                          widget.id,
                          widget.name,
                          widget.rollNo,
                          widget.email,
                          widget.time,
                          widget.contact,
                          widget.attendanceStatus,
                          widget.currentDate,
                          widget.description,
                          widget.userId,
                          widget.userToken);
                      await allConfirmedLeave(
                          widget.id,
                          widget.name,
                          widget.rollNo,
                          widget.email,
                          widget.time,
                          widget.contact,
                          widget.attendanceStatus,
                          widget.currentDate,
                          widget.description,
                          widget.userId,
                          widget.userToken);
                      await FirebaseFirestore.instance
                          .collection("JoinRequests")
                          .doc(widget.id)
                          .delete();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminHome()));
                    }
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.07,
                decoration: BoxDecoration(color: kPColor, borderRadius: BorderRadius.circular(30)),
                
                    child: Center(
                      child: Text(
                        'Confirm Leave',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                
                  
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
