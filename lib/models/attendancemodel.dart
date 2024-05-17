class AttendanceModel {
  String? uid;
  String? Name;
  String? rollno;
  String? status;
  String? token;

  AttendanceModel({
    this.uid,
    this.Name,
    this.rollno,
    this.status,
    this.token,
  });

  // recieving data from serve
  factory AttendanceModel.fromMap(map) {
    return AttendanceModel(
      uid: map['uid'],
      Name: map['Name'],
      rollno: map['rollno'],
      status: map['status'],
      token: map['token'] ?? "",
    );
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'Name': Name,
      'rollno': rollno,
      'status': status,
      'token': token,
    };
  }
}
