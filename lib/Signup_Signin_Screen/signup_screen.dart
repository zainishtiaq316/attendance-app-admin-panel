// ignore_for_file: body_might_complete_normally_catch_error
import 'package:attendeasyadmin/Signup_Signin_Screen/login_screen.dart';
import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/usermodel.dart';
import '../utils/loadingIndicator.dart';
import '../widgets/bezier-container.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
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
  final confirmpasswordEditingController = new TextEditingController();
  final photoUrlContainer = new TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  @override
  Widget build(BuildContext context) {
    //first name field
    final firstNameField = TextFormField(
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
        //new
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
          filled: true),
    );

    //last name field
    final lastNameField = TextFormField(
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
        //new
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
          filled: true),
    );

    //email field
    final emailField = TextFormField(
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
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid email");
        }
        return null;
      },
      onSaved: (value) {
        //new
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
          filled: true),
    );

    //phone number field
    final phoneNumberField = TextFormField(
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
        //new
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
          filled: true),
    );

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
    final signUpButon = GestureDetector(
      onTap: () async {
          await signUp(
              emailEditingController.text, passwordEditingController.text);
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
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

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

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: kPColor,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: const Text(
      //     "Sign Up",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () {
      //       //passing this to a route
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ),

      backgroundColor: Colors.white,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
          
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(height: 10),
                   Expanded(child: SingleChildScrollView(child: Column(
                    
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                     Text(
                        "First name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      firstNameField,
                      SizedBox(height: 10),
                      Text(
                        "Last name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      lastNameField,
                      SizedBox(height: 10),
                      Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      emailField,
                      SizedBox(height: 10),
                      Text(
                        "Phone number",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      phoneNumberField,
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
                      SizedBox(height: 10),
                      Text(
                        "Confirm password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      confirmpasswordField,
                      SizedBox(height: 20),
                      signUpButon,
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Already have an account  "),
                          
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: Text(
                              "Login ",
                              style: TextStyle(
                                  color: Color(0xffe46b10),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
,
                          
                        ],
                      ),
                      SizedBox(height: 20,)
                    
                   ],),))
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          
          ],
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
    userModel.role = "Admin";
    userModel.token = token;
    // userModel.notifications = [];
    await FirebaseAuth.instance.currentUser!
        .updateDisplayName("${firstNameEditingController.text}");
    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());
    Fluttertoast.showToast(msg: "Successful SignUp, please Signin");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }
}
