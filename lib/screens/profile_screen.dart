/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: avoid_dynamic_calls, unawaited_futures, use_build_context_synchronously, lines_longer_than_80_chars, library_private_types_in_public_api

import 'package:built_value/json_object.dart';
import 'package:iglu_ory_kratos_example/importer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final scrollController = ScrollController();

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  String startFirstName = '';
  String startLastName = '';

  bool isEmailValid = true;
  bool isNameValid = true;

  bool isLastNameValid = true;

  bool isPasswordValid = true;
  bool isRepeatPasswordValid = true;

  bool isPasswordVisible = false;
  bool isLoading = false;
  bool isLoadingPassword = false;

  bool isEditMode = false;

  SelfServiceSettingsFlow? selfServiceSettingsFlow;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      selfServiceSettingsFlow =
          await global.handlers.initHandlersSettingsScreen(context);
      try {
        _emailController.text =
            (global.session?.identity.traits?.asMap['email'] as String?) ?? '';
        _firstNameController.text = (global.session?.identity.traits
                ?.asMap['name']?['first'] as String?) ??
            '';
        _lastNameController.text = (global
                .session?.identity.traits?.asMap['name']?['last'] as String?) ??
            '';
        startFirstName = (global.session?.identity.traits?.asMap['name']
                ?['first'] as String?) ??
            '';
        startLastName = (global.session?.identity.traits?.asMap['name']?['last']
                as String?) ??
            '';
      } catch (_) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Builder(
            builder: (ctx) => Form(
              key: _formKey,
              child: _returnProfileValuesSection(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _returnProfileValuesSection() {
    final scrollableContent = Align(
      child: Container(
        width: 500,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.only(top: 30, bottom: 30),
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Scrollbar(
          controller: scrollController,
          child: ListView(
            shrinkWrap: true,
            controller: scrollController,
            padding: EdgeInsets.only(
              top: 30,
              bottom: 30 + MediaQuery.of(context).viewPadding.bottom,
            ),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Profile',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      fontSize: 28,
                    ),
                  ),
                  MElevatedButton(
                    title: 'Logout',
                    backgroundColor: Colors.red,
                    backgroundColorState: MaterialStateProperty.all(Colors.red),
                    onPressed: () async {
                      await global.handlers.logoutHandler();
                    },
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    height: 34,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MElevatedButton(
                    title: isEditMode ? 'Save' : 'Edit',
                    onPressed: () {
                      if (isEditMode) {
                        _saveProfileAction();
                      } else {
                        setState(() => isEditMode = !isEditMode);
                      }
                    },
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    height: 34,
                    isLoading: isLoading,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              MTextField(
                controller: _emailController,
                hint: 'Inserisci Email',
                check: isEmailValid || _firstNameController.text.isEmpty,
                isEnabled: false,
                onChanged: (val) {
                  setState(() {
                    isEmailValid = val.isEmpty || val.isEmail;
                  });
                },
                suffixIcon: const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              MTextField(
                controller: _firstNameController,
                check: (isNameValid && _firstNameController.text.isNotEmpty) ||
                    _firstNameController.text.isEmpty,
                onChanged: (val) {
                  setState(() {
                    isNameValid = val.isEmpty || val.length >= 2;
                  });
                },
                isEnabled: isEditMode,
                hint: 'Insert Name',
                suffixIcon: isEditMode
                    ? const Icon(
                        Icons.edit_rounded,
                        size: 20,
                        color: textColor,
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              MTextField(
                controller: _lastNameController,
                check: (isNameValid && _lastNameController.text.isNotEmpty) ||
                    _lastNameController.text.isEmpty,
                onChanged: (val) {
                  setState(() {
                    isLastNameValid = val.isEmpty || val.length >= 2;
                  });
                },
                isEnabled: isEditMode,
                hint: 'Insert Last Name',
                suffixIcon: isEditMode
                    ? const Icon(
                        Icons.edit_rounded,
                        size: 20,
                        color: textColor,
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 24),
              const Divider(
                height: 1,
                color: Colors.grey,
              ),
              const SizedBox(height: 44),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MElevatedButton(
                    title: 'Change Password',
                    onPressed: canSavePassword() ? _passwordChange : null,
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    height: 34,
                    isLoading: isLoadingPassword,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              MTextField(
                controller: _passwordController,
                obscureText: !isPasswordVisible,
                check: _passwordController.text.isEmpty ||
                    (isPasswordValid &&
                        (_passwordController.text ==
                                _repeatPasswordController.text ||
                            _repeatPasswordController.text.isEmpty)),
                onChanged: (val) {
                  setState(() {
                    isPasswordValid = val.isEmpty || val.length >= 8;
                  });
                },
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  child: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    size: 22,
                    color: textSecondaryColor,
                  ),
                ),
                hint: 'Insert New Password',
              ),
              const SizedBox(height: 24),
              MTextField(
                controller: _repeatPasswordController,
                check: _repeatPasswordController.text.isEmpty ||
                    (isRepeatPasswordValid &&
                        (_repeatPasswordController.text ==
                                _passwordController.text ||
                            _passwordController.text.isEmpty)),
                obscureText: !isPasswordVisible,
                onChanged: (val) {
                  setState(() {
                    isRepeatPasswordValid = val.isEmpty || val.length >= 8;
                  });
                },
                hint: 'Repeat New Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                  child: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    size: 22,
                    color: textSecondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    return scrollableContent;
  }

  bool canSavePassword() {
    if ((_passwordController.text == _repeatPasswordController.text) &&
        (_passwordController.text.isNotEmpty &&
            _repeatPasswordController.text.isNotEmpty) &&
        isPasswordValid &&
        isRepeatPasswordValid) {
      return true;
    } else {
      return false;
    }
  }

  bool fieldChanged(BuildContext context) {
    return isNameValid &&
        (startFirstName != _firstNameController.text) &&
        (startLastName != _lastNameController.text) &&
        (isEmailValid && _emailController.text.trim().isNotEmpty);
  }

  Future _saveProfileAction() async {
    if (!fieldChanged(context)) {
      setState(() => isEditMode = false);
      return;
    }

    setState(() => isLoading = true);

    final map = Map<dynamic, dynamic>.from(
      global.session?.identity.traits?.asMap ?? <dynamic, dynamic>{},
    );
    map['name'] = {
      'first': _firstNameController.text,
      'last': _lastNameController.text
    };

    final result = await global.handlers.saveSettingsHandler(
      context: context,
      flow: selfServiceSettingsFlow,
      traits: JsonObject(map),
      password: '',
    );

    if (result.item2 != null) {
      Nav.pushReplacement(
        context,
        screen: const ProfileScreen(),
        name: '/settings',
      );
    } else {
      showCustomDialog(
        context: context,
        title: 'Error',
        message: result.item1,
        titleButton: 'OK',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).unfocus();
    });

    setState(() => isLoading = false);
    setState(() => isEditMode = false);
  }

  Future _passwordChange() async {
    if (!isPasswordValid) {
      return;
    }

    setState(() => isLoadingPassword = true);

    final result = await global.handlers.saveSettingsHandler(
      context: context,
      flow: selfServiceSettingsFlow,
      traits: global.session?.identity.traits,
      password: _repeatPasswordController.text,
      method: 'password',
    );

    if (result.item2 != null) {
      Nav.pushReplacement(
        context,
        screen: const ProfileScreen(),
        name: '/settings',
      );
    } else {
      showCustomDialog(
        context: context,
        title: 'Error',
        message: result.item1,
        titleButton: 'OK',
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      FocusScope.of(context).unfocus();
    });

    setState(() => isLoadingPassword = false);
  }
}
