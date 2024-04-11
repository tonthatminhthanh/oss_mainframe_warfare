import 'dart:io';
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
        _createResultImage(),
        Column(
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
        )
      ],
    );
  }

  Future _saveAndShare(Uint8List bytes) async {
    XFile xFile = XFile.fromData(bytes);

    await Share.shareXFiles([xFile], text: "I am "
        " ${FirebaseAuth.instance.currentUser!.displayName} "
<<<<<<< Updated upstream
        "and I lost to the hordes of viruses on wave $wavesCount} in Mainframe Warfare!",);
=======
        "and I lost to the hordes of viruses on wave $wavesCount in Mainframe Warfare!",);
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
              "and I lost to the hordes of viruses on wave $wavesCount} in Mainframe Warfare!"
=======
              "and I lost to the hordes of viruses on wave $wavesCount in Mainframe Warfare!"
>>>>>>> Stashed changes
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
