import 'package:attendeasyadmin/screens/Home/AdminHome.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/joinModel.dart';
import '../../utils/assureDialog.dart';
import '../../utils/color_utils.dart';
import '../../utils/loadingIndicator.dart';
import '../Home/AdminBN.dart';
import 'leaveConfirmation.dart';

class leavedetails extends StatefulWidget {
  const leavedetails({super.key, required this.joinModel});
  final JoinModel joinModel;

  @override
  State<leavedetails> createState() => _leavedetailsState();
}

class _leavedetailsState extends State<leavedetails> {
  @override
  Widget build(BuildContext context) {
    DocumentReference documentRef = FirebaseFirestore.instance
        .collection("JoinRequests")
        .doc(widget.joinModel.id);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Leave Details",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            //passing this to a route
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Name:",
                  style: GoogleFonts.openSans(
                      fontSize: 13, color: black, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.joinModel.name,
                  style: GoogleFonts.openSans(
                    color: black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          //const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Roll No:",
                  style: GoogleFonts.openSans(
                      fontSize: 13, color: black, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.joinModel.rollNo,
                  style: GoogleFonts.openSans(
                    color: black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email:",
                  style: GoogleFonts.openSans(
                      fontSize: 13, color: black, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.joinModel.email,
                  style: GoogleFonts.openSans(
                    color: black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Phone no:",
                  style: GoogleFonts.openSans(
                      fontSize: 13, color: black, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.joinModel.contact,
                  style: GoogleFonts.openSans(
                    color: black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Attendance Status:",
                  style: GoogleFonts.openSans(
                      fontSize: 13, color: black, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.joinModel.attendanceStatus,
                  style: GoogleFonts.openSans(
                    color: black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Current Date:",
                  style: GoogleFonts.openSans(
                      fontSize: 13, color: black, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.joinModel.currentDate,
                  style: GoogleFonts.openSans(
                    color: black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Time:",
                  style: GoogleFonts.openSans(
                      fontSize: 13, color: black, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.joinModel.time,
                  style: GoogleFonts.openSans(
                    color: black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              "Description:",
              style: GoogleFonts.openSans(
                  fontSize: 13, color: black, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              widget.joinModel.description,
              style: GoogleFonts.openSans(
                color: black,
                fontSize: 13,
              ),
            ),
          ),

          Spacer(),

          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => leaveConfiramtion(
                              id: widget.joinModel.id,
                              name: widget.joinModel.name,
                              rollNo: widget.joinModel.rollNo,
                              email: widget.joinModel.email,
                              contact: widget.joinModel.contact,
                              attendanceStatus:
                                  widget.joinModel.attendanceStatus,
                              currentDate: widget.joinModel.currentDate,
                              description: widget.joinModel.description,
                              userId: widget.joinModel.userId,
                              userToken: widget.joinModel.userToken,
                              time: widget.joinModel.time,
                            )));
              },
              
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.07,
                decoration: BoxDecoration(color: Colors.green.shade900, borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text("Accept",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        color: white,
                      )),
                ),
              ),
            ),
          ),
          // : SizedBox.shrink(),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: GestureDetector(
              onTap: () {
                   AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.noHeader,
                                      animType: AnimType.bottomSlide,
                                      title: 'Rejected ',
                                      desc: 'Are you sure?',
                                      btnCancelOnPress: () {
                                        Navigator.of(context).pop();
                                      },
                                      btnOkOnPress: () async {
                                                        loader(context);
            
                  await documentRef.delete();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminHome()));
                                      }).show();
                                
                // assuranceDialog(context, () async {
                //   loader(context);
            
                //   await documentRef.delete();
            
                //   Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => AdminBottomNav()));
                // });
              },
              
              child: Container(
                 width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.07,
                decoration: BoxDecoration(color: Colors.red.shade900, borderRadius: BorderRadius.circular(30)),
                
                child: Center(
                  child: Text("Reject",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        color: white,
                      )),
                ),
              ),
            ),
          ),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }
}
