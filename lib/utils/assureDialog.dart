import 'package:flutter/material.dart';

assuranceDialog(BuildContext context, VoidCallback onYes) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Are you sure ?",
            textAlign: TextAlign.center,
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "No",
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20.0),
                GestureDetector(
                  onTap: onYes,
                  child: Container(
                    height: 50,
                    width: 100,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Yes",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      });
}
