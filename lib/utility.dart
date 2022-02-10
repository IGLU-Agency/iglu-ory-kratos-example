/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: use_build_context_synchronously, lines_longer_than_80_chars, avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'package:iglu_ory_kratos_example/importer.dart';

String getUrlForFlow({
  required String base,
  required String flow,
  Map<String, String>? query,
}) {
  var url = '${base.removeTrailingSlash()}/self-service/$flow/browser';
  if (query != null && query.isNotEmpty) {
    url += '?';
    query.forEach((key, dynamic value) {
      url += '$key=$value&';
    });
    if (url.endsWith('&')) {
      url = url.substring(0, url.length - 1);
    }
  }
  return url;
}

bool isQuerySet(dynamic x) {
  return x is String && x.isNotEmpty;
}

dynamic redirectOnSoftError({
  required DioError error,
  required String redirectTo,
}) {
  logger(error.message, tag: 'REDIRECT ON SOFT ERROR');
  logger(error.error, tag: 'REDIRECT ON SOFT ERROR');
  if (error.response?.statusCode == 404 ||
      error.response?.statusCode == 410 ||
      error.response?.statusCode == 403) {
    open(url: redirectTo, name: '_self');
  }
  return null;
}

void open({
  required String url,
  required String name,
  String? options,
}) {
  try {
    html.window.open(url, name, options);
  } catch (e) {
    logger('error-----$e');
  }
}

void logger(dynamic input, {String tag = '[DEBUG]'}) {
  debugPrint('$tag -- $input');
}

void showCustomDialog({
  required BuildContext context,
  String? title = 'Email verified correctly',
  String? message = 'Press continue to go to your profile',
  String? titleButton = 'Continue',
  Function()? onPressed,
}) {
  showDialog<dynamic>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black12,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      title: Text(
        title ?? '',
        style: const TextStyle(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      contentPadding: const EdgeInsets.only(top: 24, left: 40, right: 40),
      titlePadding: const EdgeInsets.only(top: 24, left: 40, right: 40),
      actionsPadding:
          const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (message != null)
              Text(
                message,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                  color: textSecondaryColor,
                  fontSize: 16,
                ),
              ),
          ],
        ),
      ),
      actions: [
        MElevatedButton(
          title: titleButton,
          reduce: true,
          height: 30,
          onPressed: onPressed ??
              () {
                Nav.push(
                  context,
                  screen: const ProfileScreen(),
                  name: '/settings',
                );
              },
        ),
      ],
    ),
  );
}
