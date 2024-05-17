import 'package:flutter/material.dart';
import 'color_utils.dart';

loader(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: CircularProgressIndicator(
          color: kPColor,
        ));
      });
}
