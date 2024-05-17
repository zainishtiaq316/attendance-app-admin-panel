import 'package:flutter/material.dart';
import 'package:attendeasyadmin/utils/color_utils.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
        backgroundColor: kPColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Languages",
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
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 15, left: 15, bottom: 15, right: 15), child: Row(
            children: [
              Text("Language", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
              Spacer(),
              Radio(
                activeColor: Colors.blue,
                value: 12, groupValue: 12, onChanged: (value){}),
              
              Text("English", style: TextStyle(color: Colors.black, fontSize: 20, ),),
              
            ],
          ),)
        ],
      ),
    ),
   
    );
  }
}