import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:attendeasyadmin/screens/Home/AdminHome.dart';
import 'package:attendeasyadmin/screens/Profile/AdminProfile.dart';
import 'package:attendeasyadmin/screens/Profile/myimagePicker.dart';
import 'package:attendeasyadmin/screens/Profile/uplader.dart';
import 'package:attendeasyadmin/utils/color_utils.dart';
import 'package:attendeasyadmin/utils/loadingIndicator.dart';

import '../../models/usermodel.dart';

class EditProfileAdmin extends StatefulWidget {
  const EditProfileAdmin({super.key});

  @override
  State<EditProfileAdmin> createState() => _EditProfileAdminState();
}

class _EditProfileAdminState extends State<EditProfileAdmin> {
 User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
   final _formKey = GlobalKey<FormState>();
    //editing controller
    final firstNameEditingController = new TextEditingController();
    final lastNameEditingController = new TextEditingController();
    final emailEditingController = new TextEditingController();
    final phoneNumberEditingController = new TextEditingController();
    final rollNoNumberEditingController = new TextEditingController();
    String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? rollNo;

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    // Extract user data
    setState(() {
      firstNameEditingController.text = userData['firstName'];
      lastNameEditingController.text = userData['secondName'];
      emailEditingController.text = userData['email'];
      phoneNumberEditingController.text = userData['phoneNumber'];
      rollNoNumberEditingController.text = userData['rollNo'];
    });
  }
  @override
  void initState() {
    super.initState();
    // Call fetchUserData when the widget initializes
    fetchUserData();
  }
  File? pickImage;
  final _imgPicker = MyImagePicker();
  final UploaderService uploaderService = UploaderService();
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
      enabled: false,
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
    //first name field
    final rollNoField = TextFormField(
      autofocus: false,
      obscureText: false,
      enableSuggestions: true,
      autocorrect: true,
      enabled: false,
      controller: rollNoNumberEditingController,
      cursorColor: Colors.black45,
      style: TextStyle(color: Colors.black45.withOpacity(0.9)),
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Roll No can't be Empty");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Roll No");
        }
        return null;
      },
      onSaved: (value) {
        //new
        rollNoNumberEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Roll No",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.9)),
          border: InputBorder.none,
          fillColor: Color(0xfff3f3f4),
          filled: true),
    );
    //signup button
    final update = GestureDetector(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          loader(context);
          await FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              // "photoURL": image.downloadLink,
            
              "firstName": firstNameEditingController.text.trim(),
              "secondName": lastNameEditingController.text.trim(),
              "phoneNumber": phoneNumberEditingController.text.trim(),
          
            }).whenComplete((){
               Fluttertoast.showToast(msg: "Profile Updated");
            }).
            
            catchError((e){
               Fluttertoast.showToast(msg: e!.message);
            });
            Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminProfile()));
          // if (pickImage != null) {
          //   loader(context);
          //   final image = await uploaderService.uploadFile(
          //       pickImage!, "Profile_Images", FileType.Image);

          //   // await FirebaseDatabase.instance
          //   //     .ref("Users")
          //   //     .child(FirebaseAuth.instance.currentUser!.uid)
          //   //     .update({"photoURL": image.downloadLink});
            

          //   await FirebaseAuth.instance.currentUser!
          //   //     .updatePhotoURL(image.downloadLink)
          //   //     .whenComplete(() {
              

          //   //   Fluttertoast.showToast(msg: "Profile Updated");

          //   //   setState(() {
          //   //     pickImage = null;
          //   //   });
          //   // });
          
          
          // }
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
          "Update",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
                backgroundColor: kPColor,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  "Edit Profile",
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
      body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Stack(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.44,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 2,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1),
                                          offset: Offset(0, 10))
                                    ],
                                    shape: BoxShape.circle,
                                  ),
                                  child: pickImage == null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            errorWidget: (context, url, error) {
                                              return Image.asset(
                                                "assets/images/user.png",
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                "${user?.photoURL != null ? user?.photoURL : profileIcon}",
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(500),
                                          child: Image.file(
                                            pickImage!,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                              Positioned(
                                  bottom: 10,
                                  right: 5,
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Center(
                                        child: GestureDetector(
                                            onTap: () async {
                                              _showImageSourceModal();
                                            },
                                            child: Icon(Icons.camera_alt,
                                                color: Colors.black)),
                                      ))),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                           
                            SizedBox(height: 20),
                            update,
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
    );
  }

  void _showImageSourceModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  final file = await _imgPicker.pickImage(
                      imageSource: ImageSource.camera);

                  if (file != null) {
                    setState(() {
                      pickImage = file;
                    });
                  }
                   if (pickImage != null) {
            loader(context);
            final image = await uploaderService.uploadFile(
                pickImage!, "Profile_Images", FileType.Image);

            // await FirebaseDatabase.instance
            //     .ref("Users")
            //     .child(FirebaseAuth.instance.currentUser!.uid)
            //     .update({"photoURL": image.downloadLink});
            await FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              "photoURL": image.downloadLink,
            
              // "firstName": firstNameEditingController.text.trim(),
              // "secondName": lastNameEditingController.text.trim(),
              // "phoneNumber": phoneNumberEditingController.text.trim(),
          
            }).catchError((e){
               Fluttertoast.showToast(msg: e!.message);
            });

            await FirebaseAuth.instance.currentUser!
                .updatePhotoURL(image.downloadLink)
                .whenComplete(() {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AdminProfile()));

              Fluttertoast.showToast(msg: "Profile Updated");

              setState(() {
                pickImage = null;
              });
            });
                   }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
                onTap: () async {
                  final file = await _imgPicker.pickImage(
                      imageSource: ImageSource.gallery);

                  if (file != null) {
                    setState(() {
                      pickImage = file;
                    });
                  }
                   if (pickImage != null) {
            loader(context);
            final image = await uploaderService.uploadFile(
                pickImage!, "Profile_Images", FileType.Image);

            // await FirebaseDatabase.instance
            //     .ref("Users")
            //     .child(FirebaseAuth.instance.currentUser!.uid)
            //     .update({"photoURL": image.downloadLink});
            await FirebaseFirestore.instance
                .collection("users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({
              "photoURL": image.downloadLink,
            
              // "firstName": firstNameEditingController.text.trim(),
              // "secondName": lastNameEditingController.text.trim(),
              // "phoneNumber": phoneNumberEditingController.text.trim(),
          
            }).catchError((e){
               Fluttertoast.showToast(msg: e!.message);
            });

            await FirebaseAuth.instance.currentUser!
                .updatePhotoURL(image.downloadLink)
                .whenComplete(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminProfile()));

              Fluttertoast.showToast(msg: "Profile Updated");

              setState(() {
                pickImage = null;
              });
            });
                   }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}