import 'package:flutter/widgets.dart';
import 'package:reservation_system_customer/constants.dart';
import 'package:reservation_system_customer/ui/about/credits_page.dart';
import 'package:reservation_system_customer/ui/about/license_list_page.dart';
import 'package:reservation_system_customer/ui_imports.dart';
import 'package:url_launcher/url_launcher.dart';
import 'about_page_header.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).aboutTheAppTitle),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: AboutTheAppSection(),
            ),
            _AboutPageListItemOpenPage(
              title: AppLocalizations.of(context).openSourceLicensesTitle,
              pageBuilder: (_) => LicenseListPage(),
            ),
            _AboutPageListItemOpenPage(
              title: AppLocalizations.of(context).creditsTitle,
              pageBuilder: (_) => CreditsPage(),
            ),
            _AboutPageListItem(
              title: AppLocalizations.of(context).website,
              onTap: () => launch(Constants.websiteUrl),
            ),
          ],
        ));
  }
}

class _AboutPageListItem extends StatelessWidget {
  final String title;
  final bool hasArrow;
  final VoidCallback onTap;

  const _AboutPageListItem({
    Key key,
    @required this.title,
    @required this.onTap,
    this.hasArrow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: hasArrow ? Icon(Icons.keyboard_arrow_right) : null,
        onTap: onTap,
      ),
    );
  }
}

class _AboutPageListItemOpenPage extends StatelessWidget {
  final String title;
  final WidgetBuilder pageBuilder;

  const _AboutPageListItemOpenPage({
    Key key,
    @required this.title,
    @required this.pageBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AboutPageListItem(
      title: title,
      hasArrow: true,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: pageBuilder),
      ),
    );
  }
}
