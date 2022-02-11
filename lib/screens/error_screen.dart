/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: library_private_types_in_public_api

import 'package:iglu_ory_kratos_example/importer.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  child: Image.asset(
                    'assets/images/ory+iglu_error.png',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MElevatedButton(
                title: 'HOME',
                onPressed: () {
                  Nav.pushReplacement(
                    context,
                    screen: const LoadingScreen(),
                    name: '/login',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
