class AttendanceData {
  String? id;
  String? uid;
  final String name;
  final String rollNumber;
  final String attendanceStatus;
  final String date;
  String? token;

  AttendanceData(
      {this.id,
      this.uid,
      required this.name,
      required this.rollNumber,
      required this.attendanceStatus,
      required this.date,
      this.token});
  factory AttendanceData.fromMap(Map<String, dynamic> map) {
    return AttendanceData(
        id: map["id"],
        uid: map['uid'],
        name: map['name'],
        rollNumber: map['rollNumber'],
        attendanceStatus: map['attendanceStatus'],
        date: map['date'],
        token: map['token']);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'rollNumber': rollNumber,
      'attendanceStatus': attendanceStatus,
      'date': date,
      'token': token
    };
  }
}
