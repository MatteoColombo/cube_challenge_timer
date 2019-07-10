import 'package:cube_challenge_timer/cube_challenge.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cube_challenge_timer/generated/i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      ),
      builder: (context, widget) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
        child: widget,
      ),
      home: CubeChallengeTimer(),
    );
  }
}