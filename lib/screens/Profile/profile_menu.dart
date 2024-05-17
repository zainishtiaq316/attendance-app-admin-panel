// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:attendeasyadmin/utils/color_utils.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: GestureDetector(
        onTap: press,
        child: Container(
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    offset: Offset(1, 1),
                    color: black.withOpacity(0.1),
                    blurRadius: 1,
                    spreadRadius: 1)
              ]),
          child: ListTile(
            leading: SvgPicture.asset(
              icon,
              width: 22,
              color: black,
            ),
            title: Text(
              text,
              style: GoogleFonts.openSans(
                  color: black, fontWeight: FontWeight.bold),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: black,
            ),
          ),
        ),
      ),
    );
  }
}
