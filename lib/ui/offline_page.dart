import 'package:flutter/material.dart';
import 'package:reservation_system_customer/app_localizations.dart';

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
              AppLocalizations.of(context).translate("offline"),
              style: Theme.of(context).textTheme.headline,
            ),
          )
        )
      ),
    );
  }
}
