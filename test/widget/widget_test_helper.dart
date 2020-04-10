import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:reservation_system_customer/ui_imports.dart';

export 'package:mockito/mockito.dart';
export 'package:bloc_test/bloc_test.dart';
export 'package:flutter/foundation.dart';
export 'package:flutter_test/flutter_test.dart';
export 'package:provider/provider.dart';
export 'package:reservation_system_customer/ui_imports.dart';
export '../data_helper.dart';

class MockAppLocalizations extends Fake implements AppLocalizations {
  @override
  Locale get locale => Locale('en');
}

class MockLocalizationsDelegate extends Fake
    implements LocalizationsDelegate<AppLocalizations> {

  final MockAppLocalizations mockAppLocalizations;

  MockLocalizationsDelegate(this.mockAppLocalizations);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(mockAppLocalizations);
  }

  bool isSupported(Locale locale) => true;

  Type get type => AppLocalizations;
}

mockBlocState<T>(Bloc<dynamic, T> bloc, T state) {
  when(bloc.state).thenReturn(state);
  whenListen(bloc, Stream.fromIterable([state]));
}

class TestApp extends StatelessWidget {
  final Widget child;
  final List<Bloc> blocs;

  const TestApp({Key key, @required this.child, this.blocs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mockAppLocalizations = MockAppLocalizations();
    return MaterialApp(
      home: MultiBlocProvider(
        providers: blocs.map((bloc) {
          // The cast is necessary unfortunately to create the correct type for the bloc provider.
          // Without the cast every BlocProvider is of the type Bloc<dynamic,dynamic>.
          if (bloc is MapBloc) {
            return BlocProvider.value(value: bloc);
          } else if (bloc is ReservationsBloc) {
            return BlocProvider.value(value: bloc);
          }
          throw Exception(
              'Unknown Bloc type. Please cast to the correct bloc.');
        }).toList(),
        child: child,
      ),
      localizationsDelegates: [
        MockLocalizationsDelegate(mockAppLocalizations),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}
