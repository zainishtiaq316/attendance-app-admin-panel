/*import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceRecord {
  final String name;
  final String rollNo;
  final String attendanceStatus;
  final DateTime currentDate;

  AttendanceRecord({
    required this.name,
    required this.rollNo,
    required this.attendanceStatus,
    required this.currentDate,
  });

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      name: map['name'] as String,
      rollNo: map['rollNo'] as String,
      attendanceStatus: map['attendanceStatus'] as String,
      currentDate: (map['currentDate'] as Timestamp).toDate(),
    );
  }
}*/
