import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SectionLicenses extends StatefulWidget {
  @override
  _SectionLicensesState createState() => _SectionLicensesState();
}

class _SectionLicensesState extends State<SectionLicenses> {
  List licenses = [];

  _getLicenses() async {
    List tmp = [];
    Map<String, dynamic> jsonLicenses =
        json.decode(await rootBundle.loadString("assets/licenses.json"));

    if (jsonLicenses != null) {
      jsonLicenses.forEach((key, value) {
        tmp.add(License(
          libName: key,
          licenseText: value,
        ));
      });

      setState(() {
        licenses = tmp;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getLicenses();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: licenses.map<Widget>((license) {
        return ListTile(
          title: Text(license.libName),
          subtitle: Text(license.licenseText),
        );
      }).toList(),
    );
  }
}

class License {
  String libName;
  String licenseText;

  License({@required this.libName, @required this.licenseText});
}
