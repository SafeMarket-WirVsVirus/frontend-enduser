import 'package:reservation_system_customer/ui_imports.dart';

class MapChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapBloc, MapState>(
      condition: (oldState, newState) =>
          oldState.filterSettings != newState.filterSettings,
      builder: (BuildContext context, state) {
        return Wrap(
          spacing: 10,
          runSpacing: -5,
          runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          children: LocationType.values.map<Widget>((LocationType l) {
            return Padding(
              padding: EdgeInsets.all(0),
              child: _LocationTypeChip(
                isSelected: l == state.filterSettings.locationType,
                locationType: l,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _LocationTypeChip extends StatelessWidget {
  final bool isSelected;
  final LocationType locationType;

  const _LocationTypeChip({
    Key key,
    @required this.isSelected,
    @required this.locationType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: isSelected
          ? Text(locationType.localized(context),
              style: TextStyle(
                color: Colors.black,
              ))
          : Text(''),
      labelPadding: isSelected ? null : EdgeInsets.all(0),
      selected: isSelected,
      backgroundColor: Colors.white,
      selectedColor: Theme.of(context).accentColor,
      shadowColor: Colors.black,
      elevation: isSelected ? 10 : 5,
      avatar: Icon(
        locationType.getIcon(),
        size: 18,
      ),
      onSelected: (bool selected) {
        BlocProvider.of<MapBloc>(context).add(MapSettingsChanged(FilterSettings(
          locationType: locationType,
        )));
      },
    );
  }
}

extension LocationTypeDescription on LocationType {
  String localized(context) {
    final localization = AppLocalizations.of(context);
    switch (this) {
      case LocationType.supermarket:
        return localization.locationFilterSupermarketsLabel;
      case LocationType.bakery:
        return localization.locationFilterBakeriesLabel;
      case LocationType.pharmacy:
        return localization.locationFilterPharmaciesLabel;
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
