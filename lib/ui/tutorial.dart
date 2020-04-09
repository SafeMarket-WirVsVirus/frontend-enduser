import 'package:reservation_system_customer/ui_imports.dart';
import 'package:tutorial_coach_mark/target_position.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Tutorial {
  static showTutorial(BuildContext context, List<TutorialItem> items) {
    TutorialCoachMark(context,
        targets: getTargets(items),
        // List<TargetFocus>
        colorShadow: Colors.red,
        // DEFAULT Colors.black
        // alignSkip: Alignment.bottomRight,
        // textSkip: "SKIP",
        // paddingFocus: 10,
        finish: () {
      print("finish");
    }, clickTarget: (target) {
      print(target);
    }, clickSkip: () {
      print("skip");
    })
      ..show();
  }

  static List getTargets(List<TutorialItem> items) {
    List<TargetFocus> targets = List();

    items.forEach((element) {
      targets.add(TargetFocus(
          targetPosition: element.targetPosition,
          keyTarget: element.targetKey,
          contents: [
            ContentTarget(
                align: AlignContent.bottom,
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        element.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20.0),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          element.subtitle,
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ))
          ]));
    });
    return targets;
  }
}

class TutorialItem {
  final String title;
  final String subtitle;
  final GlobalKey targetKey;
  final TargetPosition targetPosition;
  final Function onTap;

  TutorialItem(
      {@required this.title,
      @required this.subtitle,
      @required this.onTap,
      this.targetKey,
      this.targetPosition})
      : assert(targetKey != null || targetPosition != null);
}
