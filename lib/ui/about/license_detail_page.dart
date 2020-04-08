import 'package:flutter/material.dart';
import 'license.dart';

class LicenseDetailPage extends StatelessWidget {
  final License license;

  const LicenseDetailPage({Key key, @required this.license}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(license.libName),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(license.licenseText),
      )),
    );
  }
}
