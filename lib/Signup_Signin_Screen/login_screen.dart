// ignore_for_file: body_might_complete_normally_catch_error

import 'package:flutter/widgets.dart';
import 'package:attendeasyadmin/screens/Home/AdminHome.dart';
import 'package:attendeasyadmin/Signup_Signin_Screen/Forgot_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:attendeasyadmin/widgets/bezier-container.dart';

import '../models/usermodel.dart';
import '../screens/Home/Home_page.dart';
import '../utils/loadingIndicator.dart';
//import 'package:fluttertoast/fluttertoast.dart'

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;
  UserModel loggedInUser = UserModel();
  String? role;
  String? token;
bool _obscurePassword = true;
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

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
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

  //login function
  Future<void> sigIn(
    String email,
    String password,
  ) async {
    if (_formKey.currentState!.validate()) {
      loader(context);
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) async => {
                // Fluttertoast.showToast(msg: "Login Successful"),
                // if (FirebaseAuth.instance.currentUser!.emailVerified)
                //   {
                await getuser(FirebaseAuth.instance.currentUser!.uid),
                setState(() {
                  role = loggedInUser.role;
                }),
                 Fluttertoast.showToast(msg: "Signin Successful !"),
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        role == "Admin" ? AdminHome() : HomePageView()))
                // }
                // else
                //   {
                //     Navigator.pop(context),
                //     Fluttertoast.showToast(msg: "Email Not Verified")
                //   }
              })
          .catchError((e) {
            Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error found, check email or password !");
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //email field
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
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
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
          hintText: "Admin",
        
          floatingLabelBehavior: FloatingLabelBehavior.never,
          
           hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
           border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true) );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      enableSuggestions: false,
      autocorrect: false,
      controller: passwordController,
      cursorColor: Colors.black45,
      obscureText: _obscurePassword,
      style: TextStyle(color: Colors.black45.withOpacity(0.9)),
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
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
         
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscurePassword =
                    !_obscurePassword; // Toggle visibility
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
                  filled: true
         ),
    );

    //loginButton
    final loginButton = GestureDetector(
       onTap: () async {
           await sigIn(
              emailController.text,
              passwordController.text,
            );
        },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
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
        child: GestureDetector(
         
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          ),
         
        ),
      ),
    );

    DateTime? currentBackPressTime;

    Future<bool> onWillPop() async {
      // myFocusNode.unfocus();
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: 'Press back again to exit');
        return Future.value(false);
      }
      SystemNavigator.pop(); // add this.

      return Future.value(true);
    }
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        
        body: Container(
           height: height,
          child: Stack(
            children: <Widget>[
               Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer()),
              Container(
                 padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       SizedBox(height: height * .2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                            child: Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                     Expanded(child: SingleChildScrollView(child: Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [ Text(
                        "Admin",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      emailField,
                      SizedBox(height: 10),
                      Text(
                        "Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      passwordField,
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPassword()));
                            },
                            child: Text(
                              "Forgot Password ?",
                              style: TextStyle(
                                  color: Color(0xffe46b10),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      loginButton,
                    
                      ],),))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
