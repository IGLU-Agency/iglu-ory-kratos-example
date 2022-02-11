/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: library_private_types_in_public_api

import 'package:iglu_ory_kratos_example/importer.dart';

class VerifiedScreen extends StatefulWidget {
  const VerifiedScreen({Key? key}) : super(key: key);

  @override
  _VerifiedScreenState createState() => _VerifiedScreenState();
}

class _VerifiedScreenState extends State<VerifiedScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      final res = await global.handlers.initHandlersVerifyEmail(context);
      Future<dynamic>.delayed(const Duration(milliseconds: 400), () {
        if (res != null) showCustomDialog(context: context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 120,
                width: 140,
                child: Image.asset(
                  'assets/images/iglu_logo.png',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
