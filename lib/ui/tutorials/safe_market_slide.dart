import 'package:intro_slider/slide_object.dart';

import '../../ui_imports.dart';

class SafeMarketSlide extends Slide {
  SafeMarketSlide({
    @required BuildContext context,
    @required String title,
    @required String description,
    String pathImage,
    Widget centerWidget,
    IconData centerIcon,
  }) : super(
          title: title,
          description: description,
          pathImage: pathImage,
          centerWidget: centerWidget ??
              Icon(
                centerIcon,
                size: 200,
                color: Colors.white,
              ),
          colorBegin: Theme.of(context).primaryColor,
          colorEnd: Theme.of(context).accentColor,
        );
}
