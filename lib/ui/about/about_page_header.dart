import 'package:flutter/gestures.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ui_imports.dart';

class AboutTheAppSection extends StatefulWidget {
  @override
  _AboutTheAppSectionState createState() => _AboutTheAppSectionState();
}

class _AboutTheAppSectionState extends State<AboutTheAppSection> {
  String appVersion = "---";

  @override
  void initState() {
    super.initState();

    _getAppVersion().then((version) {
      setState(() {
        appVersion = version;
      });
    });
  }

  Future<String> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        Image.asset(
          "assets/AppIcon.png",
          width: 130,
          height: 130,
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          "SafeMarket",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        Text(
          appVersion,
          style: TextStyle(fontSize: 19, color: Colors.grey[700]),
        ),
        SizedBox(
          height: 16,
        ),
        RichText(
          text: new TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context).aboutTheAppDescription1,
                style: new TextStyle(color: Colors.black, fontSize: 17),
              ),
              TextSpan(
                text: AppLocalizations.of(context).aboutTheAppDescription2,
                style: new TextStyle(color: Colors.blue, fontSize: 17),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    launch('https://wirvsvirushackathon.devpost.com/');
                  },
              ),
              TextSpan(
                text: AppLocalizations.of(context).aboutTheAppDescription3,
                style: new TextStyle(color: Colors.black, fontSize: 17),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
