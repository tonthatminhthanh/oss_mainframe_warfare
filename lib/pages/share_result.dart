import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import 'main_menu.dart';

class ShareResultPage extends StatelessWidget {
  int wavesCount;
  ShareResultPage({super.key, required this.wavesCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _createResultImage()),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Share your achievement?"
                , style: TextStyle(
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontSize: 24, fontFamily: "Silver"),),
              ElevatedButton(
                  onPressed: () async {
                    ScreenshotController controller = ScreenshotController();
                    final image = await controller.captureFromWidget(_createResultImage());
          
                    _saveAndShare(image);
                  },
                  child: Text("Let's share it!", style: TextStyle(
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.none,
                      color: Colors.white,fontSize: 24,
                      fontFamily: "Silver"))
              ),
              ElevatedButton(onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainMenuPage(),)
                );
              }, child: Text("Return to menu", style: TextStyle(
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  color: Colors.white,fontSize: 24,
                  fontFamily: "Silver"))
              )
            ],
          ),
        )
      ],
    );
  }

  Future _saveAndShare(Uint8List bytes) async {
    final dir = await getApplicationDocumentsDirectory();

    XFile xFile = XFile.fromData(bytes);
    xFile.saveTo("${dir.path}/result.png");

    await Share.shareXFiles([XFile("${dir.path}/result.png")], text: "I am "
        " ${FirebaseAuth.instance.currentUser!.displayName} "
        "and I lost to the hordes of viruses on wave $wavesCount in Mainframe Warfare!",);
  }

  Widget _createResultImage()
  {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(FirebaseAuth.instance.currentUser!.photoURL!
            , width: 150, height: 150,),
          Text("I am "
              " ${FirebaseAuth.instance.currentUser!.displayName} "
              "and I lost to the hordes of viruses on wave $wavesCount in Mainframe Warfare!"
            , style: TextStyle(
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: 24, fontFamily: "Silver"),),
        ],
      ),
    );
  }
}
