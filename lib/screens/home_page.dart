import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fun_with_dice/components/reusable_card.dart';
import 'package:fun_with_dice/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:fun_with_dice/screens/dice_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      print("setState");
      _packageInfo = info;
      print(_packageInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Text("Herzlich Willkommen"),
                Text("Kniffel-App"),
                Text("noch ein Prototyp :)")
              ],
            ),
            OutlinedButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DicePage()),
                )
              },
              child: Text("Kniffel"),
            ),
            OutlinedButton(
              onPressed: () => {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => HighscorePage()),
                // )
              },
              child: Text("Highscores"),
            ),
            Center(
              child: Text(
                  "${_packageInfo.appName}, ${_packageInfo.version}, ${_packageInfo.buildNumber} "),
            ),
          ]),
    );
  }
}

Future<PackageInfo> packageInfo() async {
  return await PackageInfo.fromPlatform();
}
