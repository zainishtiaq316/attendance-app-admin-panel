/*import 'package:flutter/material.dart';

class EditAttendanceDetailsScreen extends StatefulWidget {
  final String documentId;

  const EditAttendanceDetailsScreen({required this.documentId});

  @override
  _EditAttendanceDetailsScreenState createState() =>
      _EditAttendanceDetailsScreenState();
}

class _EditAttendanceDetailsScreenState
    extends State<EditAttendanceDetailsScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _rollNoController = TextEditingController();
  TextEditingController _attendanceStatusController = TextEditingController();
  TextEditingController _currentDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch the attendance record using the documentId and populate the text fields with existing values
    fetchAttendanceRecord();
  }

  void fetchAttendanceRecord() {
    // Implement the logic to fetch the attendance record using the documentId
    // You can use FirebaseFirestore to query the database and retrieve the record
    // Once you have the record, populate the text fields with the existing values

    // Example:
    // FirebaseFirestore.instance
    //     .collection("MarkAttendance")
    //     .doc(user.uid)
    //     .collection("attendance")
    //     .doc(widget.documentId)
    //     .get()
    //     .then((DocumentSnapshot snapshot) {
    //   if (snapshot.exists) {
    //     setState(() {
    //       _nameController.text = snapshot.data()['name'];
    //       _rollNoController.text = snapshot.data()['rollNo'];
    //       _attendanceStatusController.text =
    //           snapshot.data()['attendanceStatus'];
    //       _currentDateController.text = snapshot.data()['currentDate'];
    //     });
    //   }
    // });
  }

  void updateAttendanceRecord() {
    // Implement the logic to update the attendance record

    // Example:
    // FirebaseFirestore.instance
    //     .collection("MarkAttendance")
    //     .doc(user.uid)
    //     .collection("attendance")
    //     .doc(widget.documentId)
    //     .update({
    //   'name': _nameController.text,
    //   'rollNo': _rollNoController.text,
    //   'attendanceStatus': _attendanceStatusController.text,
    //   'currentDate': _currentDateController.text,
    // }).then((_) {
    //   // Successfully updated the record
    //   Navigator.of(context).pop();
    // }).catchError((error) {
    //   // An error occurred while updating the record
    //   // Handle the error appropriately
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Attendance Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: _rollNoController,
              decoration: InputDecoration(
                labelText: 'Roll No',
              ),
            ),
            TextField(
              controller: _attendanceStatusController,
              decoration: InputDecoration(
                labelText: 'Attendance Status',
              ),
            ),
            TextField(
              controller: _currentDateController,
              decoration: InputDecoration(
                labelText: 'Current Date',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                updateAttendanceRecord();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}*/
