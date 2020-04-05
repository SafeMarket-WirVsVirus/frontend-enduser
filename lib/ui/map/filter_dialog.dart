import 'package:flutter/cupertino.dart';
import 'package:reservation_system_customer/ui_imports.dart';
import 'package:reservation_system_customer/ui/map/filter_settings_theme.dart';

class FilterDialog extends StatefulWidget {
  final MapBloc mapBloc;

  const FilterDialog({Key key, @required this.mapBloc}) : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final _fillStatus = [FillStatus.green, FillStatus.yellow, FillStatus.red];

  double get sliderValue => _fillStatus.indexOf(minFillStatus).toDouble();
  LocationType filterSelection;
  FillStatus minFillStatus;

  _FilterDialogState();

  @override
  void initState() {
    super.initState();
    final filterSettings = widget.mapBloc.state.filterSettings;
    minFillStatus = filterSettings.minFillStatus;
    filterSelection = filterSettings.locationType;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text(
                  AppLocalizations.of(context).locationUtilizationSliderTitle,
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
              Slider(
                onChanged: (double value) {
                  setState(() {
                    minFillStatus = _fillStatusFromSliderValue(value);
                  });
                },
                value: sliderValue,
                min: 0.0,
                max: 2.0,
                divisions: 2,
                activeColor: minFillStatus.color(context),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(_sliderTip),
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
                  var fillStatus = FillStatus.green;
                  try {
                    fillStatus = _fillStatusFromSliderValue(sliderValue);
                  } on Object catch (_) {}

                  widget.mapBloc.add(
                    MapSettingsChanged(
                      FilterSettings(
                        locationType: filterSelection,
                        minFillStatus: fillStatus,
                      ),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context).commonOk),
              ),
            ],
          ),
        ));
  }

  FillStatus _fillStatusFromSliderValue(double value) {
    return _fillStatus[value.round()];
  }

  String get _sliderTip {
    switch (minFillStatus) {
      case FillStatus.red:
        return AppLocalizations.of(context).locationUtilizationSliderTip3;
      case FillStatus.yellow:
        return AppLocalizations.of(context).locationUtilizationSliderTip2;
      case FillStatus.green:
        return AppLocalizations.of(context).locationUtilizationSliderTip1;
    }
    return '';
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
        title: Row(
          children: [
            Icon(locationType.icon(context), size: 20, color: Colors.grey),
            SizedBox(width: 8),
            Text(locationType.localized(context)),
          ],
        ),
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
