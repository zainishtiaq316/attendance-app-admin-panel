import 'package:attendeasyadmin/models/usermodel.dart';
import 'package:attendeasyadmin/screens/viewrecord/Viewrecord.dart';
import 'package:attendeasyadmin/utils/loadingIndicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddUsers extends StatefulWidget {
  AddUsers({Key? key}) : super(key: key);

  @override
  _AddUsersState createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  final _auth = FirebaseAuth.instance;
  String? token;
  Future<void> getFirebaseMessagingToken() async {
    await FirebaseMessaging.instance.requestPermission();

    await FirebaseMessaging.instance.getToken().then((t) {
      if (t != null) {
        setState(() {
          token = t;
          print('Push Token: $t');
        });
      }
    });
  }

  //our form key
  final _formKey = GlobalKey<FormState>();
  //editing controller
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final phoneNumberEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final photoUrlContainer = new TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final firstNameFieldContainer = Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        autofocus: false,
        obscureText: false,
        enableSuggestions: true,
        autocorrect: true,
        controller: firstNameEditingController,
        cursorColor: Colors.black45,
        style: TextStyle(color: Colors.black45.withOpacity(0.9)),
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name can't be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Name (Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true,
        ),
      ),
    );

    final lastNameFieldContainer = Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        autofocus: false,
        controller: lastNameEditingController,
        obscureText: false,
        enableSuggestions: true,
        autocorrect: true,
        cursorColor: Colors.black45,
        style: TextStyle(color: Colors.black45.withOpacity(0.9)),
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Last Name can't be Empty");
          }
          return null;
        },
        onSaved: (value) {
          lastNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Last Name",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true,
        ),
      ),
    );

    final emailFieldContainer = Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        autofocus: false,
        obscureText: false,
        enableSuggestions: true,
        autocorrect: true,
        controller: emailEditingController,
        cursorColor: Colors.black45,
        style: TextStyle(color: Colors.black45.withOpacity(0.9)),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          //reg expression for email validation
          if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+$")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true,
        ),
      ),
    );

    final phoneNumberFieldContainer = Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11),
        ],
        autofocus: false,
        obscureText: false,
        enableSuggestions: true,
        autocorrect: true,
        controller: phoneNumberEditingController,
        cursorColor: Colors.black45,
        style: TextStyle(color: Colors.black45.withOpacity(0.9)),
        keyboardType: TextInputType.phone,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{11,}$');
          if (value!.isEmpty) {
            return ("Phone Number can't be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid phone number (Min. 11 Character)");
          }
          return null;
        },
        onSaved: (value) {
          phoneNumberEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Phone Number",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true,
        ),
      ),
    );

    final passwordFieldContainer = Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        autofocus: false,
        enableSuggestions: false,
        autocorrect: false,
        controller: passwordEditingController,
        style: TextStyle(color: Colors.black45.withOpacity(0.9)),
        cursorColor: Colors.black45,
        obscureText: _obscurePassword,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password (Min. 6 Character)");
          }
          return null;
        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword; // Toggle visibility
              });
            },
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true,
        ),
      ),
    );

    final addUserButton = GestureDetector(
      onTap: () async {
        await signUp(
          emailEditingController.text,
          passwordEditingController.text,
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: Text(
          "Add User",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Add User",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    firstNameFieldContainer,
                    SizedBox(height: 15),
                    lastNameFieldContainer,
                    SizedBox(height: 15),
                    emailFieldContainer,
                    SizedBox(height: 15),
                    phoneNumberFieldContainer,
                    SizedBox(height: 15),
                    passwordFieldContainer,
                    SizedBox(height: 15),
                    addUserButton
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  //signup function
  Future<void> signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      loader(context);
      await getFirebaseMessagingToken();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

    //writing all values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = lastNameEditingController.text;
    userModel.phoneNumber = phoneNumberEditingController.text;
    userModel.photoURL = photoUrlContainer.text;
    userModel.role = "User";
    userModel.token = token;
    // userModel.notifications = [];
    await FirebaseAuth.instance.currentUser!
        .updateDisplayName("${firstNameEditingController.text}");
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Successful Add User");
    //  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ViewRecord()));

    Navigator.pop(context);
  }
}
