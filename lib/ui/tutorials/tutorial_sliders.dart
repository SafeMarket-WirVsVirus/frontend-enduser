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
            "You are almost ready to use the app. Please give us access to your location so we can search for stores around you.",
        centerWidget: Column(
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
            FlatButton(
              color: Colors.blueAccent,
              child: Text(
                "Grant location access",
              ),
              onPressed: () {},
            )
          ],
        ),
        backgroundColor: Color(0xffFFA500),
      ),
    );

    return IntroSlider(
      slides: slides,
      onDonePress: this.onDonePress,
      sizeDot: 7.0,
      colorActiveDot: Theme.of(context).primaryColor,
      isScrollable: true,
    );
  }
}
