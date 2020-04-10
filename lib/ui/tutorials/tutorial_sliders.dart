import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import '../../ui_imports.dart';

class TutorialSliders extends StatefulWidget {
  @override
  _TutorialSlidersState createState() => _TutorialSlidersState();
}

class _TutorialSlidersState extends State<TutorialSliders> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

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
                title: Text(String.fromCharCode(0x2022) + " Buchung eines Einkaufslots"),
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
            "You are almost ready to use the app. Please give us access to your location so we can search for stores ariund you.",
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
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onPressed: () {

              },
            )
          ],
        ),
        backgroundColor: Color(0xffFFA500),
      ),
    );
  }

  void onDonePress() {
    // Do what you want
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
    );
  }
}
