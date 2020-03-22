import 'package:flutter/material.dart';
import 'package:reservation_system_customer/bloc/bloc.dart';
import 'package:intl/intl.dart';

import '../../app_localizations.dart';

class ReservationListEntry extends StatefulWidget {
  final item;

  const ReservationListEntry({Key key, this.item}) : super(key: key);

  @override
  _ReservationListEntryState createState() => _ReservationListEntryState();
}

class _ReservationListEntryState extends State<ReservationListEntry> {
  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    return Container(
      height: 120,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: 50,
                  child: Image(
                    image: AssetImage('assets/002-shop.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.item.location?.name ?? '',
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline,
                          softWrap: true,
                        ),
                        Text(
                          widget.item.location?.address ?? "",
                          style: Theme
                              .of(context)
                              .textTheme
                              .caption,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 60,
                      child: FlatButton(
                        child: Image(
                          image: AssetImage(
                            'assets/004-bell.png',
                          ),
                          fit: BoxFit.fitWidth,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Text(AppLocalizations.of(context).translate("notification"))
                  ],
                ),
              ],
            ),
          ),
          Text(
            DateFormat.yMMMMd("de_DE").add_jm().format(widget.item.startTime),
            style: TextStyle(fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}