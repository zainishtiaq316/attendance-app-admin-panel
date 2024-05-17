// ignore_for_file: body_might_complete_normally_catch_error
import 'package:attendeasyadmin/Admin/profile/admin_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:attendeasyadmin/models/usermodel.dart';
import 'package:attendeasyadmin/utils/color_utils.dart';
import 'package:attendeasyadmin/utils/loadingIndicator.dart';


class ChangeEmail extends StatefulWidget {
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmail> {
  final _auth = FirebaseAuth.instance;
   //our form key
  final _formKey = GlobalKey<FormState>();
  //editing controller

  final TextEditingController emailController = new TextEditingController();
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

 
  Future getuser(String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        role = loggedInUser.role;
      });
    });
  }

  //firebase
  UserModel loggedInUser = UserModel();
  String? role;
  @override
  Widget build(BuildContext context) {
    
    final emailField = TextFormField(
        autofocus: false,
        obscureText: false,
        enableSuggestions: true,
        autocorrect: true,
        controller: emailController,
        cursorColor: Colors.black45,
        style: TextStyle(color: Colors.black45.withOpacity(0.9)),
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          //reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          //new
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
            enabled: false,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
            border: InputBorder.none,
            fillColor: Color(0xfff3f3f4),
            filled: true));
    //changeEmail button
    final changeEmail = GestureDetector(
  onTap: () async {
    try {
      if (_formKey.currentState!.validate()) {
        loader(context);
        // ignore: deprecated_member_use
        
        await FirebaseAuth.instance.currentUser?.updateEmail(emailController.text.trim());
        
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "email": emailController.text.trim(),
        });

        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => AdminSettings()));

        Fluttertoast.showToast(msg: "Email Changed");
      }
    } catch (e) {
      Navigator.pop(context);
      print("Error while changing email: $e");
      Fluttertoast.showToast(msg: "Error occurred while changing email");
      // Handle the error here, e.g., show an error message to the user
    }
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
        )
      ],
      gradient: LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xfffbb448), Color(0xfff7892b)],
      ),
    ),
    child: Text(
      "Change Email",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
);

    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Change Email",
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
      backgroundColor: Colors.white,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  emailField,
                  SizedBox(height: 20),
                  changeEmail,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
