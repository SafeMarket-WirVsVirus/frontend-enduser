import 'package:reservation_system_customer/ui_imports.dart';

class OfflinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Center(
            child: Text(
              AppLocalizations.of(context).reservationsNotAvailableOffline,
              style: Theme.of(context).textTheme.headline,
            ),
          ),
        ),
      ),
    );
  }
}
