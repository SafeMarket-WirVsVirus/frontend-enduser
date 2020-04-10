import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import '../../ui_imports.dart';

class TutorialSliders extends StatefulWidget {
  @override
  _TutorialSlidersState createState() => _TutorialSlidersState();
}

class _TutorialSlidersState extends State<TutorialSliders> {
  @override
  void initState() {
    super.initState();
  }

  void onDonePress() {
    // Do what you want
  }

  @override
  Widget build(BuildContext context) {
    List<Slide> slides = new List();
    slides.add(new Slide(
      title: "Disclaimer",
      description:
          "Aktuell befindet sich diese Applikation noch in der ersten Beta."
          " Konkret sind deshalb noch keine echten Märkte hinterlegt."
          " Testmärkte finden Sie aber zum Beispiel"
          " in Berlin Mitte und Dortmund Innenstadt",
      //pathImage: "assets/AppIcon.png",
      colorBegin: Theme.of(context).primaryColor,
      colorEnd: Theme.of(context).accentColor,
    ));
    slides.add(new Slide(
      title: "Übersicht",
      description:
          "SafeMarket bietet verschiedene Funktion um Sie beim Einkauf zu unterstützen: \n\n" +
              String.fromCharCode(0x2022) +
              " Buchung eines Einkaufslots \n" +
              String.fromCharCode(0x2022) +
              "Verwaltung Ihrer gebuchten Slots\n" +
              String.fromCharCode(0x2022) +
              "Betreten des Markts mit einem Slot\n",
      pathImage: "assets/AppIcon.png",
      colorBegin: Theme.of(context).primaryColor,
      colorEnd: Theme.of(context).accentColor,
    ));
    slides.add(new Slide(
      title: "Einkaufslot buchen",
      description: "Wählen Sie Ihren Standort",
      colorBegin: Theme.of(context).primaryColor,
      colorEnd: Theme.of(context).accentColor,
    ));
    slides.add(new Slide(
      title: "Einkaufslot buchen",
      description: "Wählen Sie Ihren präferierten Laden",
      colorBegin: Theme.of(context).primaryColor,
      colorEnd: Theme.of(context).accentColor,
    ));
    slides.add(new Slide(
      title: "Einkaufslot buchen",
      description: "Wählen Sie den gewünschten Solt",
      colorBegin: Theme.of(context).primaryColor,
      colorEnd: Theme.of(context).accentColor,
    ));
    slides.add(new Slide(
      title: "Einkaufslot buchen",
      description: "Bestätigen Sie anschließend den Slot",
      colorBegin: Theme.of(context).primaryColor,
      colorEnd: Theme.of(context).accentColor,
    ));
    slides.add(new Slide(
      title: "Verwalten ihrer Slots",
      description: "Sie können sich an Ihre gebuchten Slots errinerrn lassen",
      colorBegin: Theme.of(context).primaryColor,
      colorEnd: Theme.of(context).accentColor,
    ));
    slides.add(new Slide(
      title: "Betreten des Markts mit einem Slot",
      description:
          "Sie können einen Slot stornieren, falls Sie den geplanten Einkauf doch nicht wahrnehmen können \n Hinweis: Dieser ist anschließend dauerhaft gelöscht",
      colorBegin: Theme.of(context).primaryColor,
      colorEnd: Theme.of(context).accentColor,
    ));
    slides.add(new Slide(
      title: "Check-in Im Markt",
      description:
          "Sie haben 2 Möglichekeiten den Laden mit SafeMarket betreten: \n\n" +
              String.fromCharCode(0x2022) +
              "Zeigen Sie den QR Code Ihres Tickets am Eingang des Ladens\n" +
              String.fromCharCode(0x2022) +
              "Nennen Sie die Geheimwörter dem Türsteher am Eingang des Ladens\n",
      colorBegin: Theme.of(context).primaryColor,
      colorEnd: Theme.of(context).accentColor,
    ));
    slides.add(new Slide(
      title: "Verhaltensguide: ",
      description:
          "Bei der Nutzung von SafeMarktet sollten Sie folgendes beachten  : \n\n" +
              String.fromCharCode(0x2022) +
              "Bitte kommen Sie maximal 5 Minuten vor Tickentbeginn\n" +
              String.fromCharCode(0x2022) +
              "Bitte kommen Sie maximal xyz Minuten nach Tickentbeginn\n" +
              String.fromCharCode(0x2022) +
              "Ihr Ticket verfällt nach zyx Minuten\n",
      colorBegin: Theme.of(context).primaryColor,
      colorEnd: Theme.of(context).accentColor,
    ));
    slides.add(
      new Slide(
        title: "Location Permission",
        description:
            "Please give us access to your location so we can search for stores around you. You can also leave this option disabled for now if you don't need to see your live location.",
        centerWidget: _LocationPermissionWidget(
          onAccessGranted: () {
            print("on access granted");
          },
        ),
        colorBegin: Colors.blueAccent,
        colorEnd: Colors.greenAccent,
      ),
    );

    slides.add(
      new Slide(
        title: "All Done",
        description: "You are now ready to use SafeMarket.\nSafe shopping!\n\nP.S.: You can rewatch this tutorial by going to settings -> tutorial :)",
        centerWidget: Icon(
          Icons.done_outline,
          color: Colors.white,
          size: 200,
        ),
        colorBegin: Colors.blueAccent,
        colorEnd: Colors.greenAccent,
      ),
    );

    return IntroSlider(
      slides: slides,
      onDonePress: this.onDonePress,
      sizeDot: 6.0,
      colorActiveDot: Theme.of(context).primaryColor,
      isScrollable: true,
    );
  }
}

class _LocationPermissionWidget extends StatefulWidget {
  final Function onAccessGranted;

  const _LocationPermissionWidget({Key key, this.onAccessGranted})
      : super(key: key);

  @override
  __LocationPermissionWidgetState createState() =>
      __LocationPermissionWidgetState();
}

class __LocationPermissionWidgetState extends State<_LocationPermissionWidget> {
  bool loading = false;
  bool accessGranted = false;
  bool enableGrantAccessButton = true;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  _checkPermission({bool showDialogIfFailed = false}) {
    Geolocator().checkGeolocationPermissionStatus().then((geolocationStatus) {
      bool access = false;
      bool enableButton = false;

      print(geolocationStatus);

      switch (geolocationStatus) {
        case GeolocationStatus.disabled:
          access = false;
          enableButton = false;
          break;
        case GeolocationStatus.denied:
          access = false;
          enableButton = true;
          break;
        case GeolocationStatus.granted:
          access = true;
          enableButton = false;
          widget.onAccessGranted();
          break;
        case GeolocationStatus.restricted:
          access = true;
          enableButton = false;
          break;
        case GeolocationStatus.unknown:
          access = false;
          enableButton = true;
          break;
      }

      setState(() {
        accessGranted = access;
        loading = false;
        enableGrantAccessButton = enableButton;
      });

      if (showDialogIfFailed && !accessGranted) {
        // show a alert dialog
        AlertDialog dialog = AlertDialog(
          title: Text("Location access"),
          content: Text(
              "Please give us access to your location so we can search for stores around you. If you disabled location access for this app you need to manually enable it again from the system settings."),
          actions: [
            FlatButton(
              child: Text(AppLocalizations.of(context).commonOk),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return dialog;
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.my_location,
          size: 200,
          color: Colors.white,
        ),
        SizedBox(
          height: 50,
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              child: child,
              opacity: animation,
            );
          },
          child: loading
              ? CircularProgressIndicator()
              : FlatButton(
                  color: Colors.blueAccent,
                  child: Text(
                    accessGranted ? "Access granted" : "Grant location access",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: !enableGrantAccessButton
                      ? null
                      : () {
                          setState(() {
                            loading = true;
                          });

                          //show location permission prompt

                          Geolocator()
                              .getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.low)
                              .then((value) {
                            print("then: getCurrentPosition $value");

                            setState(() {
                              accessGranted = true;
                              loading = false;
                              enableGrantAccessButton = false;
                            });

                            widget.onAccessGranted();
                          }).catchError((error, stackTrace) {
                            _checkPermission(showDialogIfFailed: true);
                          });
                        },
                ),
        )
      ],
    );
  }
}
