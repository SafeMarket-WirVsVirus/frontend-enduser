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
              child: ChoiceChip(
                label: state.filterSettings.locationType == l ? Text(
                    l.localized(context),
                    style: TextStyle(
                      color: Colors.black,
                    )
                ) : Text(""),
                selected: state.filterSettings.locationType == l,
                backgroundColor: Colors.white,
                selectedColor: Theme
                    .of(context)
                    .accentColor,
                shadowColor: Colors.black,
                elevation: (state.filterSettings.locationType == l) ? 10 : 5,
                avatar: Icon(
                  l.getIcon(),
                  size: 18,),
                onSelected: (bool selected) {
                    BlocProvider.of<MapBloc>(context).add(
                        MapSettingsChanged(FilterSettings(
                          locationType: l,
                        )));
                },
              ),
            );
          }).toList(),
        );
      },

    );
  }
}

extension LocationTypeDescription on LocationType {
  String localized(context) {
    switch (this) {
      case LocationType.supermarket:
        return AppLocalizations
            .of(context)
            .locationFilterSupermarketsLabel;
      case LocationType.bakery:
        return AppLocalizations
            .of(context)
            .locationFilterBakeriesLabel;
      case LocationType.pharmacy:
        return AppLocalizations
            .of(context)
            .locationFilterPharmaciesLabel;
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
