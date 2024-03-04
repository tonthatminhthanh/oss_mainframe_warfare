import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseConnectionPage extends StatefulWidget {
  FirebaseConnectionPage({super.key, this.builder});
  final Widget Function(BuildContext context)? builder;

  @override
  State<FirebaseConnectionPage> createState() => _FirebaseConnectionPageState();
}

class _FirebaseConnectionPageState extends State<FirebaseConnectionPage> {
  bool isConnected = false;
  bool hasError = false;
  String extraErrMsg = "";
  @override
  Widget build(BuildContext context) {
    if(!isConnected)
      {
        return Scaffold(
          body: hasError ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.warning, color: Colors.red,),
                Text("Cannot connect to server!", style: TextStyle(color: Colors.red),),
                Text("Error: $extraErrMsg"),
                ElevatedButton(
                    onPressed: () {
                      hasError = true;

                    },
                    child: Text("Try again")
                )
              ],
            ),
          ) : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.blue,),
                Text("Connecting to server...", style: TextStyle(color: Colors.blue))
              ],
            ),
          )
        );
      }
    else
    {
      return widget.builder!(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _establishConnection();
  }

  void _establishConnection()
  {
    Firebase.initializeApp().then(
          (value) {
        setState(() {
          isConnected = true;
        });
      },
    ).catchError(
            (error) {
          setState(() {
            hasError = true;
            extraErrMsg = error.toString();
          });
        }
    );
  }
}
