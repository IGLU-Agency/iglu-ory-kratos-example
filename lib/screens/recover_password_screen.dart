/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: unawaited_futures, use_build_context_synchronously, lines_longer_than_80_chars

import 'package:iglu_ory_kratos_example/importer.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({
    Key? key,
    this.completion,
  }) : super(key: key);

  final Function()? completion;
  @override
  RecoverPasswordScreenState createState() => RecoverPasswordScreenState();
}

class RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool isEmailValid = true;
  bool isSendButtonEnabled = false;
  bool isLoading = false;

  SelfServiceRecoveryFlow? selfServiceRecoveryFlow;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      selfServiceRecoveryFlow =
          await global.handlers.initHandlersForgotScreen(context);
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
              child: SingleChildScrollView(
                child: Align(
                  child: Container(
                    alignment: Alignment.center,
                    width: 500,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    height: 70,
                                    width: 70,
                                    child: Image.asset(
                                      'assets/images/iglu_logo.png',
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 30,
                                      bottom: 30,
                                      left: 30,
                                      right: 30,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Recover password',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            color: textColor,
                                            fontSize: 28,
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        const Text(
                                          'Enter your email address to receive the link to reset your password',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w200,
                                            color: textSecondaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        returnEmailTextFormField(),
                                        const SizedBox(height: 30),
                                        MElevatedButton(
                                          title: 'Send',
                                          onPressed: isSendButtonEnabled
                                              ? _sendEmailActionAction
                                              : null,
                                          isLoading: isLoading,
                                        ),
                                        const SizedBox(height: 36),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 24 +
                                        MediaQuery.of(context)
                                            .viewPadding
                                            .bottom,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60, top: 20),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () => {
                                    Nav.pushReplacement(
                                      context,
                                      screen: const LoginScreen(),
                                      name: '/login',
                                    )
                                  },
                                  icon: const Center(
                                    child: Icon(
                                      Icons.keyboard_backspace,
                                      size: 30,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget returnEmailTextFormField() {
    return MTextField(
      controller: _emailController,
      showIcon: false,
      check: isEmailValid,
      type: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      onChanged: _onEmailChanged,
      backgroundColor: Colors.white.withOpacity(0.6),
      hint: 'Email',
    );
  }

  void _onEmailChanged(String text) {
    setState(() {
      isEmailValid = text.isEmpty || (text.trim().isEmail == true);
      isSendButtonEnabled =
          isEmailValid && _emailController.text.trim().isNotEmpty;
    });
  }

  Future _sendEmailActionAction() async {
    setState(() => isLoading = true);
    final result = await global.handlers.forgotHandler(
      _emailController.text.trim(),
      flow: selfServiceRecoveryFlow,
    );
    if (result.item2) {
      showCustomDialog(
        context: context,
        title: 'Congratulations',
        message:
            'We have sent you an email at ${_emailController.text.trim()} to reset your password',
        onPressed: () {
          Nav.pushReplacement(
            context,
            screen: const LoginScreen(),
            name: '/login',
          );
        },
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
    setState(() => isLoading = false);
  }
}
