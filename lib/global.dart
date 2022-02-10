/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///
// ignore_for_file: cascade_invocations

import 'package:dio/adapter_browser.dart';
import 'package:iglu_ory_kratos_example/importer.dart';

class Global {
  Global() {
    baseUrl = 'http://127.0.0.1:4433';
    api = KratosApiDart(
      basePathOverride: baseUrl,
    );
    final adapter = BrowserHttpClientAdapter();
    adapter.withCredentials = true;
    api.dio.httpClientAdapter = adapter;
    vAlphaApi = api.getV0alpha2Api();
  }

  Session? session;
  Handlers handlers = Handlers();
  late V0alpha2Api vAlphaApi;
  late KratosApiDart api;
  late String baseUrl;
}

const primaryColor = Color(0xFF526076);
const textColor = Color(0xFF232323);
const textSecondaryColor = Color(0xFF8E8E8E);
