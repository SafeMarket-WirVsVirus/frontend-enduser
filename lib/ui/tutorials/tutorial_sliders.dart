import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:provider/provider.dart';

import '../../ui_imports.dart';
import 'safe_market_slide.dart';

class TutorialSliders extends StatelessWidget {
  void onDonePress(BuildContext context) {
    Provider.of<UserRepository>(context, listen: false)
        .saveUserFinishedTutorial();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final locale = _locale(context);

    List<Slide> slides = new List();
    slides.add(SafeMarketSlide(
      context: context,
      title: appLocalizations.tutorialWelcomeTitle,
      description: appLocalizations.tutorialWelcomeDescription,
      centerIcon: Icons.announcement,
    ));

    slides.add(SafeMarketSlide(
      context: context,
      title: appLocalizations.tutorialIntroductionTitle,
      description: appLocalizations.tutorialIntroductionDescription,
      pathImage: "assets/AppIcon.png",
    ));

    slides.add(SafeMarketSlide(
      context: context,
      title: appLocalizations.tutorialBookTicketTitle,
      centerWidget: Image(
          image: AssetImage("assets/tutorial/$locale/book_slot_gif_v0.3.gif"),
          width: MediaQuery.of(context).size.width * 0.5),
      description: appLocalizations.tutorialBookTicketDescription,
    ));

    slides.add(SafeMarketSlide(
      context: context,
      title: appLocalizations.tutorialManageTicketsTitle,
      description: appLocalizations.tutorialManageTicketsDescription,
      centerWidget: Image(
          image: AssetImage("assets/tutorial/$locale/interact_slot_0.3.gif"),
          width: MediaQuery.of(context).size.width * 0.5),
    ));

    slides.add(SafeMarketSlide(
      context: context,
      title: appLocalizations.tutorialCheckInTitle,
      description: appLocalizations.tutorialCheckInDescription,
      centerWidget: Image(
          image: AssetImage("assets/tutorial/$locale/enter_market_0.3.gif"),
          width: MediaQuery.of(context).size.width * 0.5),
    ));

    slides.add(SafeMarketSlide(
      context: context,
      title: appLocalizations.tutorialLocationPermissionTitle,
      description: appLocalizations.tutorialLocationPermissionDescription,
      centerWidget: _LocationPermissionWidget(
        onAccessGranted: () {
          debug("on access granted");
        },
      ),
    ));

    slides.add(SafeMarketSlide(
      context: context,
      title: appLocalizations.tutorialLastSlideTitle,
      description: appLocalizations.tutorialLastSlideDescription,
      centerIcon: Icons.done_outline,
    ));

    return IntroSlider(
      slides: slides,
      nameSkipBtn: appLocalizations.tutorialSkipButton.toUpperCase(),
      nameNextBtn: appLocalizations.tutorialNextButton.toUpperCase(),
      nameDoneBtn: appLocalizations.tutorialDoneButton.toUpperCase(),
      onSkipPress: () => onDonePress(context),
      onDonePress: () => onDonePress(context),
      sizeDot: 8.0,
      colorActiveDot: Theme.of(context).primaryColor,
      isScrollable: true,
    );
  }

  String _locale(BuildContext context) {
    final locale = AppLocalizations.of(context).locale;
    return AppLocalizations.delegate.isSupported(locale)
        ? locale.languageCode
        : 'en';
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

      debug('$geolocationStatus');

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
        final localizations = AppLocalizations.of(context);
        _showInfoDialog(
            context: context,
            title: localizations.tutorialLocationPermissionDeclinedDialogTitle,
            message: localizations
                .tutorialLocationPermissionDeclinedDialogDescription,
            actionText: localizations
                .tutorialLocationPermissionDeclinedGoToSettingsButton
                .toUpperCase(),
            onPressed: () => AppSettings.openAppSettings());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(width: 16),
                    Text(
                      localizations.tutorialLocationPermissionStatusTesting,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
              : FlatButton(
                  color: Colors.blueAccent,
                  child: Text(
                    accessGranted
                        ? localizations.tutorialLocationPermissionStatusGranted
                        : localizations
                            .tutorialLocationPermissionStatusNotGranted,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: !enableGrantAccessButton
                      ? null
                      : () => _requestLocationPermission(),
                ),
        )
      ],
    );
  }

  _requestLocationPermission() async {
    setState(() {
      loading = true;
    });

    //show location permission prompt

    bool isLocationEnabled = await Geolocator().isLocationServiceEnabled();

    if (!isLocationEnabled) {
      setState(() {
        loading = false;
      });

      final localizations = AppLocalizations.of(context);

      _showInfoDialog(
          context: context,
          title: localizations.tutorialLocationServiceDisabledDialogTitle,
          message:
              localizations.tutorialLocationServiceDisabledDialogDescription,
          actionText: localizations
              .tutorialLocationServiceDisabledDialogLocationServiceButton
              .toUpperCase(),
          onPressed: () => AppSettings.openLocationSettings());
      return;
    }

    Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((value) {
      debug("Success: location retrieved: $value");

      setState(() {
        accessGranted = true;
        loading = false;
        enableGrantAccessButton = false;
      });

      widget.onAccessGranted();
    }).catchError((e, stackTrace) {
      error("Could not get user location", error: e);
      _checkPermission(showDialogIfFailed: true);
    });
  }
}

_showInfoDialog(
    {@required BuildContext context,
    @required String title,
    @required String message,
    @required String actionText,
    VoidCallback onPressed}) {
  AlertDialog dialog = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      FlatButton(
        child: Text(actionText),
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          }
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
