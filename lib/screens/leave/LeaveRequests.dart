import 'package:attendeasyadmin/screens/leave/leaveDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../utils/color_utils.dart';
import '../../models/joinModel.dart';

class LeaveRequests extends StatefulWidget {
  const LeaveRequests({super.key});

  @override
  State<LeaveRequests> createState() => _LeaveRequestsState();
}

class _LeaveRequestsState extends State<LeaveRequests> {
  List<Map<String, dynamic>> dataList = [];
  void getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('JoinRequests').get();

    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if (!data.containsKey('currentDate')) {
        data['currentDate'] = DateFormat.yMd().format(DateTime.now());
      }
      setState(() {
        dataList.add(data);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
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
          "Leave Requests",
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
      body: dataList.isEmpty
          ? Center(
              child: Text(
                "No Leave Requests",
                style: GoogleFonts.openSans(
                  color: black,
                ),
              ),
            )
          : ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final list = dataList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => leavedetails(
                                  joinModel: JoinModel(
                                    id: list['id'] ?? "",
                                    name: list['name'],
                                    rollNo: list['rollNo'],
                                    email: list['email'],
                                    contact: list['contact'],
                                    attendanceStatus: list['attendanceStatus'],
                                    currentDate: list['currentDate'] ?? "",
                                    description: list['description'],
                                    userId: list['userId'],
                                    userToken: list['userToken'],
                                    time: list['time']
                                  ),
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.all(8),
                    // height: MediaQuery.of(context).size.height * 0.05,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 1,
                              spreadRadius: 1,
                              color: black.withOpacity(0.1))
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 16),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            style: GoogleFonts.openSans(
                                              color: black,
                                            ),
                                            children: [
                                          TextSpan(
                                            text: 'Leave Request From ',
                                            style: GoogleFonts.openSans(color: black),
                                          ),
                                          TextSpan(
                                            text: '${list['name']}',
                                            style: GoogleFonts.openSans(
                                                color: black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ])),
                                  
                                  ],
                                ),
                               SizedBox(height: 5,),
                               Text(list['rollNo'], style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),)
                                , SizedBox(height: 5,),
                               Text(list['email'], style: TextStyle(color: Colors.black, fontSize: 13, ),)
                                  , SizedBox(height: 5,),
                               Text(list['contact'], style: TextStyle(color: Colors.black, fontSize: 13, ),)
                                , SizedBox(height: 10,),
                                 Text("Leave Description : ", style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),)
                                , SizedBox(height: 5,),
                               Text(list['description'], style: TextStyle(color: Colors.black, fontSize: 13, ),)
                              
                              ],
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height*0.2,
                              width: MediaQuery.of(context).size.width*0.1,  
                              color: Colors.blue,
                              child: Icon(CupertinoIcons.forward, size: 30,color: Colors.white,))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
