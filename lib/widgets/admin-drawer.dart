import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:attendeasyadmin/screens/Profile/admin_settings.dart';
import 'package:attendeasyadmin/screens/viewrecord/Viewrecord.dart';
import 'package:attendeasyadmin/Signup_Signin_Screen/splash.dart';

import 'package:attendeasyadmin/utils/color_utils.dart';
import 'package:attendeasyadmin/utils/loadingIndicator.dart';

import '../screens/Profile/developer_contact_drawer.dart';
import '../screens/Home/AdminHome.dart';
import '../screens/Profile/AdminProfile.dart';
import '../screens/viewrecord/all_users.dart';


class AdminDrawerWidget extends StatelessWidget {
  const AdminDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
 
  String? name = user?.displayName;
  String? imageUrl = user?.photoURL;

     return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
  stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator(color: kPColor)); // Loading indicator while fetching data
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      Map<String, dynamic>? userData = snapshot.data?.data();
      String? firstName = userData?['firstName'];
      String? secondName = userData?['secondName'];
      String? email = userData?['email'];
      String? imageUrl = userData?['photoURL'];
      String? name = firstName;

      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: Drawer(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              children: [
                Container(
                  color: Color(0xfff7892b),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.32,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.white,
                          backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
                          child: imageUrl == null ? Text(
                            name != null ? name[0].toUpperCase() : "",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ) : null,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "${firstName ?? ""} ${secondName ?? ""}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          email ?? "",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminHome()));
                    },
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "Home",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.home,
                        color: Colors.black,
                        weight: 12,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        weight: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllUsers()));
                    },
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "All Users",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.supervised_user_circle,
                        color: Colors.black,
                        weight: 12,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        weight: 12,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminProfile()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "Profile",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.person,
                        color: Colors.black,
                        weight: 12,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        weight: 12,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminSettings()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "Settings",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.settings,
                        color: Colors.black,
                        weight: 12,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        weight: 12,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeveloperContactDrawer()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "Contact",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Icon(
                        Icons.help,
                        color: Colors.black,
                        weight: 12,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.black,
                        weight: 12,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListTile(
                    onTap: () async {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.noHeader,
                        animType: AnimType.bottomSlide,
                        title: 'Logout',
                        desc: 'Are you sure?',
                        btnCancelOnPress: () {
                          Navigator.of(context).pop();
                        },
                        btnOkOnPress: () async {
                          loader(context);
                          await logout(context);
                        },
                      ).show();
                    },
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Icon(
                      Icons.logout,
                      color: Colors.black,
                      weight: 12,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      weight: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey.shade400,
        ),
      );
    }
  },
);

    
    }

    Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreen()));
  }
}
