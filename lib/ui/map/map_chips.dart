

import 'package:reservation_system_customer/ui_imports.dart';

class MapChips extends StatefulWidget {
  final MapBloc mapBloc;

  const MapChips({Key key, this.mapBloc}) : super(key: key);

  @override
  _MapChipsState createState() => _MapChipsState();
}

class _MapChipsState extends State<MapChips> {
  LocationType selectedType;


  @override
  void initState() {
    selectedType = widget.mapBloc.state.filterSettings.locationType;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: -5,
      runAlignment: WrapAlignment.center,
      alignment: WrapAlignment.center,
      children: LocationType.values.map<Widget>((LocationType l) {
        return Padding(
          padding: EdgeInsets.all(0),
          child: ChoiceChip(
            label: Text(
                l.localized(context),
                style: TextStyle(
                  color: Colors.black,
                )
            ),
            selected: selectedType == l,
            backgroundColor: Colors.white,
            selectedColor: Theme.of(context).accentColor,
            shadowColor: Colors.black,
            elevation: (selectedType == l) ? 10 : 5,
            avatar: Icon(
              l.getIcon(),
              size: 18,),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  selectedType = l;
                }
                widget.mapBloc.add(
                    MapSettingsChanged(FilterSettings(
                        locationType: l,
                        minFillStatus: FillStatus.red))); // TODO remove minFillStatus from FilterSettings
              });
            },
          ),
        );
      }).toList(),
    );
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

  IconData getIcon() {
    switch (this) {
      case LocationType.supermarket:
        return Icons.local_grocery_store;
      case LocationType.bakery:
        return Icons.local_cafe;
      case LocationType.pharmacy:
        return Icons.local_pharmacy;
    }
    return Icons.location_on;
  }
}
