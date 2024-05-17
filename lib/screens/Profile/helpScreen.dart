import 'package:flutter/material.dart';

import '../../utils/color_utils.dart';
import 'developer_contact.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({Key? key}) : super(key: key);

  @override
  _HelpCenterScreenState createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Help Center",
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
      body: ListView(
        children: [
          ExpansionTile(
            title: Text('How do I create an account?'),
            iconColor: kPColor,
            collapsedIconColor: kPColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'To create an account, go to the registration page and fill in the required details. Once you have submitted the form, you will receive a verification email. Click on the verification link in the email to activate your account.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How can I mark my attendance?'),
            iconColor: kPColor,
            collapsedIconColor: kPColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    "To mark your attendance, locate the 'Mark Attendance' button on the app's interface. Click or tap on it to register yourself as present for the day."),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Can I view my attendance records using the app?'),
            iconColor: kPColor,
            collapsedIconColor: kPColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'Yes, you can. Simply click or tap on the "View" button to access your attendance history. It will display all the days you have marked your attendance.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Is it possible to edit my profile picture?'),
            iconColor: kPColor,
            collapsedIconColor: kPColor,
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
            title: Text('Can I mark attendance more than once in a day?'),
            iconColor: kPColor,
            collapsedIconColor: kPColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'No, the app restricts users from marking attendance more than once in a day. Once you have marked your attendance for the day, the option will no longer be available until the next day.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Can I delete my attendance record?'),
            iconColor: kPColor,
            collapsedIconColor: kPColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    'No, the app does not allow users to delete their attendance records. This ensures accurate tracking and prevents any manipulation of attendance data.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('How can I request leave using the app?'),
            iconColor: kPColor,
            collapsedIconColor: kPColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Text(
                    "To request leave, locate the 'Mark Leave' button on the app's interface. Click or tap on it to submit a leave request to the admin. The admin will review and approve or reject the leave request."),
              ),
            ],
          ),
          ExpansionTile(
            iconColor: kPColor,
            collapsedIconColor: kPColor,
            title: Text(
              'Developer Contacts',
              style: TextStyle(color: Colors.black),
            ),
            children: [
              ListTile(
                title: Text(
                  'Contact with Developer',
                  style: TextStyle(color: kPColor),
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
