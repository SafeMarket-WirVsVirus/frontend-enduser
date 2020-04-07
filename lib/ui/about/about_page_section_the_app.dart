import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

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
        Row(
          children: <Widget>[
            Image.asset(
              "assets/AppIcon.png",
              width: 60,
              height: 60,
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "SafeMarket",
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  appVersion,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            )
          ],
        ),
        SizedBox(
          height: 16,
        ),
        RichText(
          text: new TextSpan(
            children: [
              TextSpan(
                text: 'Our project was created during the ',
                style: new TextStyle(color: Colors.black, fontSize: 17),
              ),
              TextSpan(
                text: '#WirVsVirus hackathon',
                style: new TextStyle(color: Colors.blue, fontSize: 17),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    launch('https://wirvsvirushackathon.devpost.com/');
                  },
              ),
              TextSpan(
                text:
                    '.\n\nSafeMarket is a digital reservation service which minimizes infections and queues. It allows people visiting a place to see the future, planned occupancy rate. Our first use case during the Corona pandemic is the visit of a store such as a supermarket with minimizing social interactions.',
                style: new TextStyle(color: Colors.black, fontSize: 17),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
