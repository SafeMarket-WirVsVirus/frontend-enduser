import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reservation_system_customer/ui/about/license_detail_page.dart';

import 'license.dart';

class LicenseListPage extends StatefulWidget {
  @override
  _LicenseListPageState createState() => _LicenseListPageState();
}

class _LicenseListPageState extends State<LicenseListPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Open Source Licenses"),
      ),
      body: ListView.builder(
          itemCount: licenses.length,
          itemBuilder: (BuildContext context, int index) {
            License selectedLicense = licenses[index];
            return ListTile(
              title: Text(selectedLicense.libName),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LicenseDetailPage(
                            license: selectedLicense,
                          ))),
            );
          }),
    );
  }
}
