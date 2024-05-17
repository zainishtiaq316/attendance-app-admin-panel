// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/color_utils.dart';

class DeveloperContactPage extends StatelessWidget {
  const DeveloperContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey.shade200,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        
        title: const Text(
          "Contact With Developer",
          style: TextStyle(
               color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            //passing this to a route
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: Zain Ishtiaq',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Email: zainishtiaq.7866@gmail.com',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                Text(
                  'Phone: +92 3028163676',
                  style: TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          GestureDetector(
            onTap: () async {
              final Uri params = Uri(
                scheme: 'mailto',
                path: 'zainishtiaq.7866@gmail.com',
                query: 'subject=Subject&body=Enter your message',
              );
              String url = params.toString();
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Could not launch email app'),
                ));
              }
            },
           child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,
              decoration: BoxDecoration(color: kPColor, borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mail, color: Colors.white, size: 23,),
                    SizedBox(width: 5,),
                    Text("Email", style: TextStyle(color: Colors.white),),
                  ],
                ),
              )),
          
          ),
          SizedBox(height: 10.0),
        GestureDetector(
            onTap: () async {
              String phoneNumber = '+923028163676';
              String url = 'tel:$phoneNumber';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Could not launch phone app'),
                ));
              }
            },
           
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,
              decoration: BoxDecoration(color: kPColor, borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.white, size: 23,),
                    SizedBox(width: 5,),
                    Text("Call", style: TextStyle(color: Colors.white),),
                  ],
                ),
              )),
          ),

            SizedBox(height: 10.0),
        
            GestureDetector(
            onTap: () async {
             await sendMessageOnWhatsApp();
            },
           child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.05,
              decoration: BoxDecoration(color: kPColor, borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mail, color: Colors.white, size: 23,),
                    SizedBox(width: 5,),
                    Text("WhatsApp", style: TextStyle(color: Colors.white),),
                  ],
                ),
              )),
          
          ),
          
        ]),
      ),
    );
  }
   static Future<void> sendMessageOnWhatsApp()async{


    final number = "+923028163676";
    final message = "Hello Zain Ishtiaq ";

    final url = 'https://wa.me/$number?text=${Uri.encodeComponent(message)}';

    // ignore: deprecated_member_use
    if(await canLaunch(url)){
      
      // ignore: deprecated_member_use
      await launch(url);
    }else{

      throw 'Could not launch $url';
    }
   }
}
