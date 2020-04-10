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

    slides.add(
      new Slide(
          title: "Disclaimer",
          description:
              "Aktuell befindet sich diese Applikation noch in der ersten Beta."
              " Konkret sind deshalb noch keine echten Märkte hinterlegt."
              " Testmärkte finden Sie aber zum Beispiel"
              " in Berlin Mitte und Dortmund Innenstadt",
          //pathImage: "assets/AppIcon.png",
          colorBegin: Colors.blueAccent,
          colorEnd: Colors.greenAccent),
    );
    slides.add(
      new Slide(
          title: "Übersicht",
          widgetDescription: Column(
            children: <Widget>[
              Text(
                  "SafeMarket bietet verschiedene Funktion um Sie beim Einkauf zu unterstützen:"),
              ListTile(
                title: Text(String.fromCharCode(0x2022) +
                    " Buchung eines Einkaufslots"),
              )
            ],
          ),
          pathImage: "assets/AppIcon.png",
          colorBegin: Colors.blueAccent,
          colorEnd: Colors.greenAccent),
    );

    slides.add(
      new Slide(
        title: "Location Permission",
        description:
            "You are almost ready to use the app. Please give us access to your location so we can search for stores around you.",
        centerWidget: _LocationPermissionWidget(
          onAccessGranted: () {
            print("on access granted");
          },
        ),
        backgroundColor: Color(0xffFFA500),
      ),
    );

    return IntroSlider(
      slides: slides,
      onDonePress: this.onDonePress,
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

  _checkPermission() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //used so the height stays the same after the transition so the decryption text does not move
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      accessGranted
                          ? "Access granted"
                          : "Grant location access",
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
                                    desiredAccuracy: LocationAccuracy.high)
                                .then((value) {
                              print("then: getCurrentPosition $value");

                              setState(() {
                                accessGranted = true;
                                loading = false;
                                enableGrantAccessButton = false;
                              });

                              widget.onAccessGranted();
                            }).catchError((error, stackTrace) {
                              _checkPermission();
                            });
                          },
                  ),
          )
        ],
      ),
    );
  }
}
