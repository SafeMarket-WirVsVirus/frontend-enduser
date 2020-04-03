import 'package:reservation_system_customer/ui_imports.dart';

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
                AppLocalizations.of(context).locationUtilizationSliderTitle,
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
              child: Text(AppLocalizations.of(context).commonOk),
            ),
          ],
        ));
  }

  String _getSliderTips() {
    List<String> sliderTips = [
      AppLocalizations.of(context).locationUtilizationSliderTip1,
      AppLocalizations.of(context).locationUtilizationSliderTip2,
      AppLocalizations.of(context).locationUtilizationSliderTip3,
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
    return RadioListTile(
        title: Text(locationType.localized(context)),
        activeColor: Theme.of(context).accentColor,
        groupValue: groupValue,
        value: locationType,
        onChanged: (_) => locationSelected(locationType));
  }
}

extension LocationTypeDescription on LocationType {
  String localized(context) {
    switch (this) {
      case LocationType.supermarket:
        return AppLocalizations.of(context).locationFilterSupermarketsLabel;
      case LocationType.bakery:
        return AppLocalizations.of(context).locationFilterBakeriesLabel;
      case LocationType.pharmacy:
        return AppLocalizations.of(context).locationFilterPharmaciesLabel;
    }
    return '';
  }
}
