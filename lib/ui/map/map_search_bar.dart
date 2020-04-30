import 'dart:math';

import '../../ui_imports.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

final kGoogleApiKey = "AIzaSyASiLyTF70AjXY22eMns2Lpcny0ifCA5Gw";
final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class MapSearchBar extends StatefulWidget {
  @override
  _MapSearchBarState createState() => _MapSearchBarState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _MapSearchBarState extends State<MapSearchBar> {
  Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildDropdownMenu(),
        RaisedButton(
          onPressed: _handlePressButton,
          child: Text("Search places"),
        ),
      ],
    );
  }

  Widget _buildDropdownMenu() => DropdownButton(
        value: _mode,
        items: <DropdownMenuItem<Mode>>[
          DropdownMenuItem<Mode>(
            child: Text("Overlay"),
            value: Mode.overlay,
          ),
          DropdownMenuItem<Mode>(
            child: Text("Fullscreen"),
            value: Mode.fullscreen,
          ),
        ],
        onChanged: (m) {
          setState(() {
            _mode = m;
          });
        },
      );

  void onError(PlacesAutocompleteResponse response) {
    debug(response.errorMessage);
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "de",
      components: [Component(Component.country, "de")],
    );

    displayPrediction(p, homeScaffoldKey.currentState);
  }
}

Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    scaffold.showSnackBar(
      SnackBar(content: Text("${p.description} - $lat/$lng")),
    );
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
