import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:attendeasyadmin/utils/color_utils.dart';
import 'package:attendeasyadmin/utils/loadingIndicator.dart';

import 'AdminProfile.dart';

class AdminChangePassword extends StatefulWidget {
  const AdminChangePassword({super.key});

  @override
  State<AdminChangePassword> createState() => _AdminChangePasswordState();
}

class _AdminChangePasswordState extends State<AdminChangePassword> {
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

  final passwordEditingController = new TextEditingController();
  final confirmpasswordEditingController = new TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    //password field
    final passwordField = TextFormField(
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
        //new
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
          filled: true),
    );

    //confirm password
    final confirmpasswordField = TextFormField(
      autofocus: false,
      enableSuggestions: false,
      autocorrect: false,
      controller: confirmpasswordEditingController,
      style: TextStyle(color: Colors.black45.withOpacity(0.9)),
      cursorColor: Colors.black45,
      obscureText: _obscureConfirmPassword,
      validator: (value) {
        if (confirmpasswordEditingController.text !=
            passwordEditingController.text) {
          return "Password don't match";
        }
        return null;
      },
      onSaved: (value) {
        //new
        confirmpasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirm Password",
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscureConfirmPassword =
                    !_obscureConfirmPassword; // Toggle visibility
              });
            },
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true),
    );

    //signup button
    final updateButton = GestureDetector(
      onTap: () async {
        // Check if both passwords match
        if (_formKey.currentState!.validate()) {
          if (passwordEditingController.text ==
              confirmpasswordEditingController.text) {
            try {
              // Get the current user
              User? user = _auth.currentUser;
              if (user != null) {
                // Update the password
                await loader(context);
                await user.updatePassword(passwordEditingController.text);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AdminProfile()));
                // Password updated successfully
                print('Password updated successfully');
                // You can navigate to another screen or show a success message here
              }
            } catch (e) {
              // Handle any errors that occur during password update
              print('Error updating password: $e');
              
              // Show error message to the user
              // You can also handle specific error cases and show different messages
            }
          } else {
            // Passwords don't match
            print('Passwords do not match');
            // Show an error message to the user
          }
        } else {
          // Form validation failed
          print('Form validation failed');
          // Show an error message to the user
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
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: Text(
          "Update Password",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Change Password",
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
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  passwordField,
                  SizedBox(height: 10),
                  Text(
                    "Confirm password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  confirmpasswordField,
                  SizedBox(height: 20),
                  updateButton,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}