import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  Place filterSelection;
  List<Color> sliderColor = [Colors.green, Colors.orange, Colors.red];
  List<String> sliderTips = [
    "Nur die Läden mit sehr geringer Auslastung werden angezeigt "
        "(optimal für besonders gefährdete Personen)",
    "Die Läden mit sehr hoher Auslastung werden nicht angezeigt",
    "Alle Läden werden angezeigt, auch wenn gerade viel los ist"
  ];

  _FilterDialogState(this._mapBloc);

  @override
  void initState() {
    sliderValue = _mapBloc.fillStatusPreference.toDouble();

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
                'Auslastungsniveau',
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
              child: Text(sliderTips[(sliderValue - 1).round()]),
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
                title: const Text('Supermarkt'),
                leading: Radio(
              activeColor: Theme.of(context).accentColor,
                  value: FilterSelection.supermarket,
                  onChanged: (FilterSelection value) {
                setState(() {
                  filterSelection = value;
                });
                  }, groupValue: filterSelection,
                )),
            ListTile(
                title: const Text('Bäckerei'),
                leading: Radio(
                  activeColor: Theme
                      .of(context)
                      .accentColor,
                  value: FilterSelection.bakery,
                  onChanged: (FilterSelection value) {
                    setState(() {
                      filterSelection = value;
                    });
                  }, groupValue: filterSelection,
                )),
            ListTile(
                title: const Text('Apotheke'),
                leading: Radio(
                  activeColor: Theme
                      .of(context)
                      .accentColor,
                  value: FilterSelection.pharmacy,
                  onChanged: (FilterSelection value) {
                    setState(() {
                      filterSelection = value;
                    });
                  }, groupValue: filterSelection,
                )),
            FlatButton(
              onPressed: () {
                _mapBloc.add(MapSettingsChanged(
                    sliderValue.round(), filterSelection));
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ));
  }
}
