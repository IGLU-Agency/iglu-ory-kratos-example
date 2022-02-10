/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

extension StringExtension on String? {
  bool get isEmail {
    final regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    if (regExp.hasMatch(this!)) {
      return true;
    } else {
      return false;
    }
  }

  String? removeTrailingSlash() {
    return this?.replaceAll(RegExp(r'/\/$/'), '');
  }

  Map<String, String>? getQueryParameters() {
    final map = <String, String>{};
    if (this == null) {
      return null;
    }
    final arr = this!.split('?');
    if (arr.length > 1) {
      final first = arr.reversed.first;
      if (first.isNotEmpty) {
        final queryElements = first.split('&');
        if (queryElements.isNotEmpty) {
          for (var i = 0; i < queryElements.length; i++) {
            final element = queryElements[i];
            final split = element.split('=');
            if (split.length > 1) {
              map[split[0]] = split[1];
            }
          }
          if (map.isEmpty) {
            return null;
          }
          return map;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
