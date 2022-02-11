/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

import 'package:built_value/json_object.dart';
import 'package:iglu_ory_kratos_example/importer.dart';

class Handlers {
  Handlers();

  Future<void> manageUserLogin(
    Session? user,
    BuildContext context,
  ) async {
    global.session = user;
  }

  //MARK: FUNCTIONS HANDLERS
  Future<bool> logoutHandler() async {
    try {
      final url =
          await global.vAlphaApi.createSelfServiceLogoutFlowUrlForBrowsers();
      if (url.data?.logoutUrl != null) {
        open(
          url: url.data!.logoutUrl,
          name: '_self',
        );
        return true;
      }
      return false;
    } catch (e) {
      logger(e);
      return false;
    }
  }

  Future<Tuple2<String?, bool>> sendEmailConfirmationHandler(
    BuildContext context,
  ) async {
    try {
      await Nav.push(
        context,
        screen: const VerifiedScreen(),
        name: ModalRoute.of(context)?.settings.name,
      );
      return const Tuple2(null, true);
    } catch (e) {
      return const Tuple2(
        null,
        false,
      );
    }
  }

  Future<Session?> sessionHandler() async {
    try {
      final s = await global.vAlphaApi.toSession();
      if (s.data != null) {
        return s.data;
      }
      return null;
    } catch (e) {
      if (e is DioError) {
        logger(e.message);
      }
      return null;
    }
  }

  Future<Tuple2<String?, bool>> forgotHandler(
    String email, {
    SelfServiceRecoveryFlow? flow,
  }) async {
    try {
      if (flow != null) {
        final body = SubmitSelfServiceRecoveryFlowBody((builder) {
          builder
            ..csrfToken = flow.ui.nodes.firstOrNull?.attributes.value?.asString
            ..email = email
            ..method = 'link';
        });

        final serviceResponse =
            await global.vAlphaApi.submitSelfServiceRecoveryFlow(
          flow: flow.id,
          submitSelfServiceRecoveryFlowBody: body,
        );

        if (serviceResponse.data != null) {
          return Tuple2(
            flow.ui.messages?.firstOrNull?.text,
            true,
          );
        }
      }
      return Tuple2(
        flow?.ui.messages?.firstOrNull?.text,
        false,
      );
    } catch (e) {
      String? message;
      if (e is DioError) {
        final initFlowUrl = getUrlForFlow(
          base: global.baseUrl,
          flow: 'login',
        );
        redirectOnSoftError(
          redirectTo: initFlowUrl,
          error: e,
        );
        try {
          final json = e.response?.data as Map?;
          final ui = json?['ui'] as Map?;
          final messages = ui?['messages'] as List?;
          final text = messages?.firstOrNull as Map?;
          message = text?['text'] as String?;
        } catch (e) {
          logger(e);
        }
      }
      return Tuple2(
        message,
        false,
      );
    }
  }

  Future<Tuple3<String?, bool, bool>> verifyEmailHandler(
    String? token, {
    SelfServiceVerificationFlow? flow,
  }) async {
    try {
      if (flow != null) {
        final body = SubmitSelfServiceVerificationFlowBody((builder) {
          builder
            ..csrfToken = flow.ui.nodes.firstOrNull?.attributes.value?.asString
            ..email = global.session?.identity.id
            ..method = 'link';
        });

        final serviceResponse =
            await global.vAlphaApi.submitSelfServiceVerificationFlow(
          flow: flow.id,
          submitSelfServiceVerificationFlowBody: body,
        );

        if (serviceResponse.data != null) {
          return Tuple3(
            flow.ui.messages?.firstOrNull?.text,
            true,
            true,
          );
        }
      }
      return Tuple3(
        flow?.ui.messages?.firstOrNull?.text,
        false,
        true,
      );
    } catch (e) {
      String? message;
      if (e is DioError) {
        final initFlowUrl = getUrlForFlow(
          base: global.baseUrl,
          flow: 'verification',
        );
        redirectOnSoftError(
          redirectTo: initFlowUrl,
          error: e,
        );
        try {
          final json = e.response?.data as Map?;
          final ui = json?['ui'] as Map?;
          final messages = ui?['messages'] as List?;
          final text = messages?.firstOrNull as Map?;
          message = text?['text'] as String?;
        } catch (e) {
          logger(e);
        }
      }
      return Tuple3(
        message,
        false,
        true,
      );
    }
  }

  Future<Tuple2<String?, Session?>> loginHandler(
    String email,
    String password, {
    SelfServiceLoginFlow? flow,
  }) async {
    try {
      if (flow != null) {
        final body = SubmitSelfServiceLoginFlowBody((builder) {
          builder
            ..csrfToken = flow.ui.nodes.firstOrNull?.attributes.value?.asString
            ..method = SessionAuthenticationMethodMethodEnum.password.name
            ..passwordIdentifier = email
            ..password = password;
        });

        final serviceResponse =
            await global.vAlphaApi.submitSelfServiceLoginFlow(
          flow: flow.id,
          submitSelfServiceLoginFlowBody: body,
        );

        if (serviceResponse.data != null) {
          return Tuple2(
            flow.ui.messages?.firstOrNull?.text,
            serviceResponse.data?.session,
          );
        }
      }
      return Tuple2(
        flow?.ui.messages?.firstOrNull?.text,
        null,
      );
    } catch (e) {
      String? message;
      if (e is DioError) {
        final initFlowUrl = getUrlForFlow(
          base: global.baseUrl,
          flow: 'login',
        );
        redirectOnSoftError(
          redirectTo: initFlowUrl,
          error: e,
        );
        try {
          final json = e.response?.data as Map?;
          final ui = json?['ui'] as Map?;
          final messages = ui?['messages'] as List?;
          final text = messages?.firstOrNull as Map?;
          message = text?['text'] as String?;
        } catch (e) {
          logger(e);
        }
      }
      return Tuple2(
        message,
        null,
      );
    }
  }

  Future<Tuple2<String?, Session?>> registrationHandler(
    String email,
    String password, {
    SelfServiceRegistrationFlow? flow,
  }) async {
    try {
      if (flow != null) {
        final jsonobject = JsonObject({'email': email});
        final body = SubmitSelfServiceRegistrationFlowBody((builder) {
          builder
            ..csrfToken = flow.ui.nodes.firstOrNull?.attributes.value?.asString
            ..method = SessionAuthenticationMethodMethodEnum.password.name
            ..traits = jsonobject
            ..password = password;
        });

        final serviceResponse =
            await global.vAlphaApi.submitSelfServiceRegistrationFlow(
          flow: flow.id,
          submitSelfServiceRegistrationFlowBody: body,
        );

        if (serviceResponse.data != null) {
          return Tuple2(
            flow.ui.messages?.firstOrNull?.text,
            serviceResponse.data?.session,
          );
        }
      }
      return Tuple2(
        flow?.ui.messages?.firstOrNull?.text,
        null,
      );
    } catch (e) {
      String? message;
      if (e is DioError) {
        final initFlowUrl = getUrlForFlow(
          base: global.baseUrl,
          flow: 'registration',
        );
        redirectOnSoftError(
          redirectTo: initFlowUrl,
          error: e,
        );
        try {
          final json = e.response?.data as Map?;
          final ui = json?['ui'] as Map?;
          final messages = ui?['messages'] as List?;
          final text = messages?.firstOrNull as Map?;
          message = text?['text'] as String?;
        } catch (e) {
          logger(e);
        }
      }
      return Tuple2(
        message,
        null,
      );
    }
  }

  Future<Tuple2<String?, Identity?>> saveSettingsHandler({
    required BuildContext context,
    String? password,
    JsonObject? traits,
    SelfServiceSettingsFlow? flow,
    String method = 'profile',
  }) async {
    try {
      if (flow != null) {
        final body = SubmitSelfServiceSettingsFlowBody((builder) {
          builder
            ..csrfToken = flow.ui.nodes.firstOrNull?.attributes.value?.asString
            ..method = SessionAuthenticationMethodMethodEnum.password.name
            ..traits = traits
            ..method = method
            ..password = password;
        });

        final serviceResponse =
            await global.vAlphaApi.submitSelfServiceSettingsFlow(
          flow: flow.id,
          submitSelfServiceSettingsFlowBody: body,
        );
        if (serviceResponse.data != null) {
          return Tuple2(
            flow.ui.messages?.firstOrNull?.text,
            serviceResponse.data?.identity,
          );
        }
      }
      return Tuple2(
        flow?.ui.messages?.firstOrNull?.text,
        null,
      );
    } catch (e) {
      logger(e);
      String? message;
      if (e is DioError) {
        final initFlowUrl = getUrlForFlow(
          base: global.baseUrl,
          flow: 'login',
        );
        redirectOnSoftError(
          redirectTo: initFlowUrl,
          error: e,
        );
        try {
          final json = e.response?.data as Map?;
          final ui = json?['ui'] as Map?;
          final messages = ui?['messages'] as List?;
          final text = messages?.firstOrNull as Map?;
          message = text?['text'] as String?;
        } catch (e) {
          logger(e);
        }
      }
      return Tuple2(
        message,
        null,
      );
    }
  }

  //MARK: INIT HANDLERS

  Future<SelfServiceLoginFlow?> initHandlersLoginScreen(
    BuildContext context,
  ) async {
    final query = ModalRoute.of(context)?.settings.name?.getQueryParameters() ??
        <String, String>{};
    final flow = query['flow'];
    const aal = '';
    const refresh = '';
    const returnTo = '';
    final initFlowUrl = getUrlForFlow(
      base: global.baseUrl,
      flow: 'login',
      query: {'aal': aal, 'refresh': refresh, 'return_to': returnTo},
    );
    if (!isQuerySet(flow)) {
      open(
        url: initFlowUrl,
        name: '_self',
      );
      return null;
    }
    try {
      final response =
          await global.vAlphaApi.getSelfServiceLoginFlow(id: flow ?? '');
      return response.data;
    } catch (e) {
      if (e is DioError) {
        redirectOnSoftError(
          redirectTo: initFlowUrl,
          error: e,
        );
      }
      return null;
    }
  }

  Future<SelfServiceRegistrationFlow?> initHandlersRegistrationScreen(
    BuildContext context,
  ) async {
    final query = ModalRoute.of(context)?.settings.name?.getQueryParameters() ??
        <String, String>{};
    final flow = query['flow'];
    const returnTo = '';
    final initFlowUrl = getUrlForFlow(
      base: global.baseUrl,
      flow: 'registration',
      query: {'return_to': returnTo},
    );
    if (!isQuerySet(flow)) {
      open(
        url: initFlowUrl,
        name: '_self',
      );
      return null;
    }
    try {
      final response =
          await global.vAlphaApi.getSelfServiceRegistrationFlow(id: flow ?? '');
      return response.data;
    } catch (e) {
      if (e is DioError) {
        redirectOnSoftError(
          redirectTo: initFlowUrl,
          error: e,
        );
      }
      return null;
    }
  }

  Future<SelfServiceRecoveryFlow?> initHandlersForgotScreen(
    BuildContext context,
  ) async {
    final query = ModalRoute.of(context)?.settings.name?.getQueryParameters() ??
        <String, String>{};
    final flow = query['flow'];
    const returnTo = '';
    final initFlowUrl = getUrlForFlow(
      base: global.baseUrl,
      flow: 'recovery',
      query: {'return_to': returnTo},
    );
    if (!isQuerySet(flow)) {
      open(
        url: initFlowUrl,
        name: '_self',
      );
      return null;
    }
    try {
      final response =
          await global.vAlphaApi.getSelfServiceRecoveryFlow(id: flow ?? '');
      return response.data;
    } catch (e) {
      if (e is DioError) {
        redirectOnSoftError(
          redirectTo: initFlowUrl,
          error: e,
        );
      }
      return null;
    }
  }

  Future<SelfServiceVerificationFlow?> initHandlersVerifyEmail(
    BuildContext context,
  ) async {
    if (global.session?.identity.verifiableAddresses?.firstOrNull?.verified ==
        true) {
      await Nav.push(
        context,
        screen: const ProfileScreen(),
        name: '/settings',
      );
      return null;
    }
    final query = ModalRoute.of(context)?.settings.name?.getQueryParameters() ??
        <String, String>{};
    final flow = query['flow'];
    const returnTo = '';
    final initFlowUrl = getUrlForFlow(
      base: global.baseUrl,
      flow: 'verification',
      query: {'return_to': returnTo},
    );
    if (!isQuerySet(flow)) {
      open(
        url: initFlowUrl,
        name: '_self',
      );
      return null;
    }
    try {
      final response =
          await global.vAlphaApi.getSelfServiceVerificationFlow(id: flow ?? '');
      return response.data;
    } catch (e) {
      if (e is DioError) {
        redirectOnSoftError(
          redirectTo: initFlowUrl,
          error: e,
        );
      }
      return null;
    }
  }

  Future<SelfServiceSettingsFlow?> initHandlersSettingsScreen(
    BuildContext context,
  ) async {
    final query = ModalRoute.of(context)?.settings.name?.getQueryParameters() ??
        <String, String>{};
    final flow = query['flow'];
    const returnTo = '';
    final initFlowUrl = getUrlForFlow(
      base: global.baseUrl,
      flow: 'settings',
      query: {'return_to': returnTo},
    );
    if (!isQuerySet(flow)) {
      open(
        url: initFlowUrl,
        name: '_self',
      );
      return null;
    }
    try {
      final response =
          await global.vAlphaApi.getSelfServiceSettingsFlow(id: flow ?? '');
      return response.data;
    } catch (e) {
      if (e is DioError) {
        redirectOnSoftError(
          redirectTo: initFlowUrl,
          error: e,
        );
      }
      return null;
    }
  }
}
