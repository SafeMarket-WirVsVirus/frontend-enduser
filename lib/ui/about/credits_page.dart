import 'package:reservation_system_customer/ui_imports.dart';

class CreditsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(8),
          child: Text(AppLocalizations.of(context).creditsTitle),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context).creditsDesignSectionTitle, style: Theme.of(context).textTheme.headline),
            SizedBox(height: 10),
            Text(AppLocalizations.of(context).creditsDesignSectionBody, style: Theme.of(context).textTheme.subhead.copyWith(height: 1.5)),
          ],
        ),
      ),
    );
  }
}
