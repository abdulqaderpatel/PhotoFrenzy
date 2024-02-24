import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> showErrorDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title:
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
        content: Text(message),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: const Text(
                'Ok',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    },
  );
}

Future<void> showReactionCount(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title:
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ]),
        content: Text(message),
        actions: <Widget>[
          Center(
            child: TextButton(
              child: const Text(
                'Ok',
                style:
                TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      );
    }
  );
}

showToast({required String message,bool error=false}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor:error?Colors.red: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}
