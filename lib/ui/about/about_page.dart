import 'package:flutter/widgets.dart';
import 'package:reservation_system_customer/ui/about/license_list_page.dart';
import 'package:reservation_system_customer/ui_imports.dart';
import 'about_page_header.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int selectedSectionId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).aboutTheAppTitle),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AboutTheAppSection(),
            ),
            Card(
              child: ListTile(
                title: Text(AppLocalizations.of(context).openSourceLicensesTitle),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LicenseListPage())),
              ),
            ),
            Card(
              child: ListTile(
                title: Text("Website"),
              ),
            )
          ],
        ));
  }
}
