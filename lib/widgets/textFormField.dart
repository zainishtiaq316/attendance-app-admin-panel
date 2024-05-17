import 'package:flutter/material.dart';
import 'package:attendeasyadmin/utils/color_utils.dart';

// ignore: must_be_immutable
class Textformfield extends StatelessWidget {
  Textformfield(
      {Key? key,
      required this.keyboard,
      required this.hintText,
      required this.obsecure,
      required this.controller,
      required this.validator,
      required this.suffixicon,
      this.prefixicon,
      this.onchange,
      required this.enabled,
      this.formatterList})
      : super(key: key);

  final String hintText;
  dynamic controller;
  dynamic keyboard;
  final bool obsecure;
  final FormFieldValidator<String?>? validator;
  final IconButton? suffixicon;
  final Icon? prefixicon;
  final Function(String)? onchange;
  final dynamic formatterList;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        inputFormatters: formatterList,
        onChanged: onchange,
        autofocus: false,
        obscureText: obsecure,
        enableSuggestions: true,
        autocorrect: true,
        controller: controller,
        cursorColor: Colors.black45,
        style: TextStyle(color: kPColor),
        keyboardType: keyboard,
        validator: validator,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: prefixicon,
            suffixIcon: suffixicon,
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: hintText,
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: white.withOpacity(0.3),
            hintStyle: TextStyle(color: black),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                    width: 2, style: BorderStyle.solid, color: Colors.blue)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide:
                    const BorderSide(width: 0, style: BorderStyle.solid))),
      ),
    );
  }
}
