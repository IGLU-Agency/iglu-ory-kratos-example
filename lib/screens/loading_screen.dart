/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: lines_longer_than_80_chars, dead_code, use_build_context_synchronously, unawaited_futures, library_private_types_in_public_api

import 'package:iglu_ory_kratos_example/importer.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      var isLoggedIn = global.session != null;
      final settings = ModalRoute.of(context)?.settings.name ?? '/';
      try {
        final checkSession = await global.vAlphaApi.toSession();
        if (checkSession.data != null) {
          global.session = checkSession.data;
          isLoggedIn = true;
        }
      } catch (_) {}

      if (settings == '/') {
      } else if (settings.startsWith('/login')) {
        if (!isLoggedIn) {
          Nav.push(
            context,
            screen: const LoginScreen(),
            name: settings,
          );
        } else {
          Nav.push(context, screen: const ProfileScreen(), name: '/settings');
        }
      } else if (settings.startsWith('/settings')) {
        if (!isLoggedIn) {
          Nav.push(
            context,
            screen: const LoginScreen(),
            name: '/login',
          );
        } else {
          Nav.push(context, screen: const ProfileScreen(), name: settings);
        }
      } else if (settings.startsWith('/forgot')) {
        if (!isLoggedIn) {
          Nav.push(
            context,
            screen: const RecoverPasswordScreen(),
            name: settings,
          );
        } else {
          Nav.push(context, screen: const ProfileScreen(), name: '/settings');
        }
      } else if (settings.startsWith('/verify/email')) {
        if (isLoggedIn) {
          Nav.push(
            context,
            screen: const VerifiedScreen(),
            name: settings,
          );
        } else {
          Nav.push(context, screen: const LoginScreen(), name: '/login');
        }
        Nav.push(context, screen: const VerifiedScreen(), name: settings);
      } else if (settings.startsWith('/registration')) {
        if (!isLoggedIn) {
          Nav.push(
            context,
            screen: const SignupScreen(),
            name: settings,
          );
        } else {
          Nav.push(context, screen: const ProfileScreen(), name: '/settings');
        }
      } else {
        Nav.push(context, screen: const ErrorScreen(), name: settings);
      }
    });
  }

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
                  height: 120,
                  width: 140,
                  child: Image.asset(
                    'assets/images/iglu_logo.png',
                  ),
                ),
              ),
              const SizedBox(height: 2),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
