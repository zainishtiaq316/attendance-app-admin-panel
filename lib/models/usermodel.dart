class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? phoneNumber;
  String? photoURL;
  String? rollNo;
  String? token;
  String? role;

  UserModel({
    this.uid,
    this.email,
    this.firstName,
    this.secondName,
    this.phoneNumber,
    this.photoURL,
    this.rollNo,
    this.role,
    this.token,
  });

  // recieving data from serve
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      secondName: map['secondName'],
      phoneNumber: map['phoneNumber'],
      photoURL: map['photoURL'],
      rollNo: map['rollNo'],
      role: map['role'] ?? "User",
      token: map['token'] ?? "",
    );
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'phoneNumber': phoneNumber,
      'photoURL': photoURL,
      'rollNo': rollNo,
      'token': token,
      'role': role,
    };
  }
}
