/// ORY KRATOS IGLU EXAMPLE
///
/// Copyright © 2020 - 2022 IGLU. All rights reserved.
/// Copyright © 2020 - 2022 IGLU
///

// ignore_for_file: unawaited_futures, use_build_context_synchronously

import 'package:iglu_ory_kratos_example/importer.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    Key? key,
    this.completion,
  }) : super(key: key);

  final Function()? completion;
  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isSignupButtonEnabled = false;

  bool isPasswordVisible = false;
  bool isLoading = false;

  SelfServiceRegistrationFlow? selfServiceRegistrationFlow;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      selfServiceRegistrationFlow =
          await global.handlers.initHandlersRegistrationScreen(context);
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
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
                                      'Signup',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: textColor,
                                        fontSize: 28,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    returnEmailTextFormField(),
                                    const SizedBox(height: 24),
                                    returnPasswordTextFormField(),
                                    const SizedBox(height: 30),
                                    MElevatedButton(
                                      title: 'Signup',
                                      onPressed: isSignupButtonEnabled
                                          ? _signupAction
                                          : null,
                                      isLoading: isLoading,
                                    ),
                                    const SizedBox(height: 36),
                                    returnRegisterBorderButton(),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 24 +
                                    MediaQuery.of(context).viewPadding.bottom,
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

  Widget returnRegisterBorderButton() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Already have an account? ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textSecondaryColor,
              fontSize: 16,
            ),
          ),
          TextSpan(
            text: 'Login',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Nav.push(
                  context,
                  screen: const LoginScreen(),
                  fullScreen: true,
                  name: '/login',
                );
              },
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
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

  Widget returnPasswordTextFormField() {
    return MTextField(
      controller: _passwordController,
      obscureText: !isPasswordVisible,
      showIcon: false,
      type: TextInputType.visiblePassword,
      autofillHints: const [AutofillHints.password],
      onChanged: _onPasswordChanged,
      textInputAction: TextInputAction.done,
      check: isPasswordValid,
      backgroundColor: Colors.white.withOpacity(0.6),
      onSubmitted: (v) {
        if (isSignupButtonEnabled) {
          _signupAction();
        }
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
      hint: 'Password',
    );
  }

  void _onPasswordChanged(String text) {
    setState(
      () {
        isPasswordValid = text.isEmpty || !(text.length < 5);
        isSignupButtonEnabled =
            (isEmailValid && _emailController.text.trim().isNotEmpty) &&
                (isPasswordValid && _passwordController.text.isNotEmpty);
      },
    );
  }

  void _onEmailChanged(String text) {
    setState(() {
      isEmailValid = text.isEmpty || (text.trim().isEmail == true);
      isSignupButtonEnabled =
          (isEmailValid && _emailController.text.trim().isNotEmpty) &&
              (isPasswordValid && _passwordController.text.isNotEmpty);
    });
  }

  Future _signupAction() async {
    setState(() => isLoading = true);
    final result = await global.handlers.registrationHandler(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      flow: selfServiceRegistrationFlow,
    );
    if (result.item2 != null) {
      global.session = result.item2;
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
    setState(() => isLoading = false);
  }
}
