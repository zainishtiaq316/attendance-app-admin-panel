import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:attendeasyadmin/Signup_Signin_Screen/splash.dart';
import 'package:attendeasyadmin/utils/color_utils.dart';
import 'package:attendeasyadmin/utils/loadingIndicator.dart';

class AdminAccountInfo extends StatefulWidget {
  const AdminAccountInfo({super.key});

  @override
  State<AdminAccountInfo> createState() => _AdminAccountInfoState();
}

class _AdminAccountInfoState extends State<AdminAccountInfo> {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? name = user?.displayName;
    String? imageUrl = user?.photoURL;
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Account Info",
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
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user?.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator(
                  color: kPColor,
                )); // Loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Map<String, dynamic>? userData = snapshot.data?.data();
                String? firstName = userData?['firstName'];
                String? SecondName = userData?['secondName'];
                String? email = userData?['email'];
                String? phone = userData?['phoneNumber'];

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: CircleAvatar(
                              radius: 80.0,
                              backgroundColor: Colors.white,
                              backgroundImage: imageUrl != null
                                  ? NetworkImage(imageUrl)
                                  : null,
                              child: imageUrl == null
                                  ? Text(
                                      name != null ? name[0].toUpperCase() : "",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                      ),
                      info("Name", "$firstName $SecondName"),
                      info("Email", "$email"),
                      info("Phone", "$phone"),
                   
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          AwesomeDialog(
                              context: context,
                              dialogType: DialogType.noHeader,
                              animType: AnimType.bottomSlide,
                           
                              title: 'Deactivate Account',
                              desc:
                                  'Are you sure you want to deactivate your account?',
                              btnCancelOnPress: () {
                                Navigator.of(context).pop();
                              },
                              btnOkOnPress: () async {
                                 loader(context);
                                await FirebaseAuth.instance.currentUser!
                                    .delete();
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SplashScreen()));
                              }).show();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.07,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                                child: Text(
                              "Deactivate Your Account",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            }));
  }

  Widget info(String name, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Row(
        children: [
          Text(
            "${name ?? ""} : ",
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Text(
            "${value ?? ""}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }

}