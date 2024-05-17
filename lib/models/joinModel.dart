import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class JoinModel {
  final String id;
  final String name;
  final String rollNo;
  final String email;
  final String contact;
  final String attendanceStatus;

  final String currentDate;
  final String description;
  final String userId;
  final String userToken;
  final String time;
  JoinModel({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.email,
    required this.contact,
    required this.time,
    required this.attendanceStatus,
    required this.currentDate,
    required this.description,
    required this.userId,
    required this.userToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'rollNo': rollNo,
      'email': email,
      'contact': contact,
      'attendanceStatus': attendanceStatus,
      'currentDate': currentDate,
      'description': description,
      'userId': userId,
      'userToken': userToken,
    };
  }

  factory JoinModel.fromMap(Map<String, dynamic> map) {
    return JoinModel(
      id: map['id'] as String,
      name: map['name'] as String,
      rollNo: map['rollNo'] as String,
      email: map['email'] as String,
      contact: map['contact'] as String,
      attendanceStatus: map['attendanceStatus'] as String,
      currentDate: map['currentDate'] as String,
      description: map['description'] as String,
      userId: map['userId'] as String,
      userToken: map['userToken'] as String,
      time: map['time'] as String
    );
  }

  String toJson() => json.encode(toMap());

  factory JoinModel.fromJson(String source) =>
      JoinModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
