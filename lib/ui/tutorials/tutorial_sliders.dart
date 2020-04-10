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
        title: "Location Permission",
        description: "Please give us acces to your location",
        pathImage: "assets/AppIcon.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      new Slide(
        title: "PENCIL",
        description:
            "Ye indulgence unreserved connection alteration appearance",
        pathImage: "assets/AppIcon.png",
        backgroundColor: Color(0xff203152),
      ),
    );
    slides.add(
      new Slide(
        title: "RULER",
        description:
            "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of",
        pathImage: "assets/AppIcon.png",
        backgroundColor: Color(0xff9932CC),
      ),
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
