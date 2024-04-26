import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main_menu.dart';

AppBar returnTitleBar({required BuildContext context, required String title})
{
  return AppBar(
    backgroundColor: Colors.blue,
    title: Row(
      children: [
        Icon(Icons.book, color: Colors.white,),
        Text(title, style: TextStyle(fontSize: 16),)
      ],
    ),
    actions: [
      ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero
              ))
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MainMenuPage(),)
            );
          },
          child: Icon(Icons.close, color: Colors.white,)
      )
    ],
    automaticallyImplyLeading: false,
  );
}