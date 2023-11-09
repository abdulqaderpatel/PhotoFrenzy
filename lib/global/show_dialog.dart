import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              child: const Text('Ok',style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600),),
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
