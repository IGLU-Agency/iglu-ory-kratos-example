/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: avoid_bool_literals_in_conditional_expressions, import_of_legacy_library_into_null_safe, avoid_void_async, lines_longer_than_80_chars

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:iglu_ory_kratos_example/importer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

////////////////////
Global global = Global();
///////////////////

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    setUrlStrategy(PathUrlStrategy());
    return MaterialApp(
      title: 'IGLU Ory Kratos Example',
      color: const Color(0xFF263542),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        return PageRouteBuilder<dynamic>(
          pageBuilder: (_, __, ___) => const LoadingScreen(),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
          settings: RouteSettings(name: settings.name),
        );
      },
    );
  }
}
