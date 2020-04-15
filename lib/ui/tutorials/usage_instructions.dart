import 'package:reservation_system_customer/ui_imports.dart';

class UsageInstructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                localizations.usageInstructionsFirstTicketTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(height: 6),
              Text(
                localizations.usageInstructionsFirstTicketSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontWeight: FontWeight.normal),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image(
                  height: 80,
                  image: AssetImage("assets/AppIcon.png"),
                ),
              ),
              SizedBox(height: 8),
              Text(localizations.usageInstructionsFirstTicketDescription,
                  style:
                      Theme.of(context).textTheme.body1.copyWith(height: 1.5)),
              SizedBox(height: 20),
              RaisedButton(
                child:
                    Text(localizations.usageInstructionsOkButton.toUpperCase()),
                color: Color(0xFF00F2A9),
                textColor: Color(0xFF322153),
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20),
                    side: BorderSide(color: Color(0xFF00F2A9))),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
