import 'package:flutter/material.dart';

import '../../../utils/color_utils.dart';
import '../../screens/Profile/developer_contact.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({Key? key}) : super(key: key);

  @override
  _HelpCenterState createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Help Center",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            //passing this to a route
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: Text(
                'How can the admin view all the records of login students?'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    "The admin can access a list or table that displays the records of all the students who have logged into the system. This list will contain relevant information such as their names, login dates, and login times."),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
                "How can the admin edit, add, and delete the students' attendance?"),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    "The admin will have access to an interface or module where they can perform actions related to student attendance. They can edit existing attendance records, add new attendance entries for students, and delete attendance records if necessary."),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
                "How can the admin create a report of user attendance for a specific date range?"),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    "The admin can navigate to the report generation section and input the desired 'FROM' and 'TO' dates to define the date range. The system will then generate a report that displays the attendance details of specific users within that specified date range."),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Is it possible to edit my profile picture?'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'Yes, you can edit your profile picture. Look for the "Edit Profile" or "Profile Settings" option within the app. From there, you should be able to upload or change your profile picture.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
                "How can the admin handle leave approvals and keep track of leaves, presents, and absences?"),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'The admin will have a dedicated module for leave management. In this module, they can review leave requests submitted by students, approve or reject them, and keep track of the number of leaves taken by each student.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
                'How can the admin create a complete system report for attendance within a specific date range?'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    "The admin can go to the system report section and enter the desired 'FROM' and 'TO' dates to specify the date range."),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
                'How can the admin set up the grading system based on attendance?'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    "In the admin panel, there will be a grading system configuration module. The admin can set the criteria for different grades based on attendance. "),
              ),
            ],
          ),
          ExpansionTile(
            title: Text(
              'Developer Contacts',
              style: TextStyle(color: Colors.black),
            ),
            children: [
              ListTile(
                title: Text(
                  'Contact with Developer',
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeveloperContactPage(),
                    ),
                  );
                },
              ),
            ],
          )

          // Add more queries and their answers as needed
        ],
      ),
    );
  }
}
