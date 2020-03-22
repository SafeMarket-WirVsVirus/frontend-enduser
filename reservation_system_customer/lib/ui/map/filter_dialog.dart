import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reservation_system_customer/app_localizations.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:reservation_system_customer/repository/repository.dart';

class FilterDialog extends StatefulWidget {
  final MapBloc mapBloc;

  const FilterDialog({Key key, this.mapBloc}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState(mapBloc);
}

class _FilterDialogState extends State<FilterDialog> {
  final MapBloc _mapBloc;
  double sliderValue;
  LocationType filterSelection;
  List<Color> sliderColor = [Colors.green, Colors.orange, Colors.red];

  _FilterDialogState(this._mapBloc);

  @override
  void initState() {
    super.initState();
    sliderValue = _mapBloc.fillStatusPreference.toDouble();
    filterSelection = _mapBloc.filterSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Text(
                AppLocalizations.of(context).translate("fill_status"),
                style: Theme.of(context).textTheme.headline,
              ),
            ),
            Slider(
              onChanged: (double value) {
                setState(() {
                  if (value > 0) sliderValue = value;
                });
              },
              value: sliderValue,
              min: 0.0,
              max: 3.0,
              divisions: 3,
              activeColor: sliderColor[(sliderValue - 1).round()],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(_getSliderTips()),
            ),
            SizedBox(
              height: 20,
            ),
            ListView.builder(
              itemBuilder: (context, index) => _CheckboxTile(
                locationType: LocationType.values[index],
                groupValue: filterSelection,
                locationSelected: (LocationType value) {
                  setState(() {
                    filterSelection = value;
                  });
                },
              ),
              itemCount: LocationType.values.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            ),
            FlatButton(
              onPressed: () {
                _mapBloc.add(
                    MapSettingsChanged(sliderValue.round(), filterSelection));
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).translate("ok")),
            ),
          ],
        ));
  }

  String _getSliderTips() {
    List<String> sliderTips = [
      AppLocalizations.of(context).translate("slider_tips_1"),
      AppLocalizations.of(context).translate("slider_tips_2"),
      AppLocalizations.of(context).translate("slider_tips_3"),
    ];
    return sliderTips[sliderValue.round() - 1];
  }
}

class _CheckboxTile extends StatelessWidget {
  final LocationType locationType;
  final LocationType groupValue;
  final ValueChanged<LocationType> locationSelected;

  const _CheckboxTile({
    Key key,
    @required this.locationType,
    @required this.groupValue,
    @required this.locationSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(locationType.localized),
        leading: Radio(
          activeColor: Theme.of(context).accentColor,
          value: locationType,
          onChanged: (_) => locationSelected(locationType),
          groupValue: groupValue,
        ));
  }
}

extension LocationTypeDescription on LocationType {
  String get localized {
    switch (this) {
      case LocationType.supermarket:
        return 'Supermarkt';
      case LocationType.bakery:
        return 'Bäckerei';
      case LocationType.pharmacy:
        return 'Apotheke';
    }
    return '';
  }
}
