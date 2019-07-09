import 'package:cube_challenge_timer/timer/cube_challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cube_challenge_timer/generated/i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: S.delegate
          .resolution(fallback: new Locale("en", ""), withCountry: false),
      title: '1vs1 Cube Timer',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: TextTheme(
          subhead: TextStyle(
              fontSize: 16.0
          ),
        ),
      ),
      home: CubeChallengeTimer(),
    );
  }
}
