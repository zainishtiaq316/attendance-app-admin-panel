import 'package:attendeasyadmin/Admin/widget/admin-drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendeasyadmin/Admin/profile/eidt_profile_screen.dart';
import 'package:attendeasyadmin/Signup_Signin_Screen/splash.dart';
import 'package:attendeasyadmin/screens/Profile/change_email.dart';
import 'package:attendeasyadmin/screens/Profile/language_settings.dart';
import 'package:attendeasyadmin/utils/color_utils.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  late FocusNode myFocusNode;

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() async {
    // myFocusNode.unfocus();
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press back again to exit');
      setState(() {
        myFocusNode.unfocus();
      });
      return Future.value(false);
    }
     await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreen()));

    return Future.value(true);
  }
   @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    
    // ignore: deprecated_member_use
    return WillPopScope(
       onWillPop: onWillPop,
      child: Scaffold(
          appBar: AppBar(
            actionsIconTheme: IconThemeData(color: Colors.blue),
            title: Text(
              "Settings",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                color: kPColor,
              ),
            ),
            centerTitle: true,
          ),
      
          drawer: AdminDrawerWidget(),
          body: SingleChildScrollView(
                    child: Column(
                      children: [
                       Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top :10,bottom: 20),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.22,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(color: Colors.grey, blurRadius: 2)
                                ],
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditProfileAdmin()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 15, right: 15, bottom: 15),
                                    child: Row(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.10,
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.05,
                                          decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Icon(
                                            Icons.edit_note_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Edit Profile",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Spacer(),
                                        Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade300,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChangeEmail()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 15, right: 15, bottom: 15),
                                    child: Row(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.10,
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.05,
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Icon(
                                            Icons.contact_mail,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Change Email",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Spacer(),
                                        Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 20),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.09,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(color: Colors.grey, blurRadius: 2)
                                ],
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LanguageSettings()));
                                 },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 15, right: 15, bottom: 15),
                                    child: Row(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.10,
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.05,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Icon(
                                            Icons.language,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Language Settings",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Spacer(),
                                        Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              
              
              
              ),
    );
            
            
            
            
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SplashScreen()));
  }

}