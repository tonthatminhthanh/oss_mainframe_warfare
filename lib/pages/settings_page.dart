import 'package:flutter/material.dart';
import 'package:mw_project/pages/windows_titlebar.dart';
import 'package:mw_project/ui/widget_overlay/volume_slider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnTitleBar(context: context, title: "Settings"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: VolumeSlider()),
          Text(
              "This game is developed by Ton That Minh Thanh, font is made by Poppy Works",
          style: TextStyle(fontSize: 16, fontFamily: "Silver", color: Colors.white)
          )
        ],
      ),
    );
  }
}
