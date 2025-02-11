import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/models/error_mdodel.dart';
import 'package:my_di_card/models/login_api_reponse.dart';
import 'package:my_di_card/models/my_card_get.dart';
import 'package:my_di_card/utils/widgets/button_primary.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../utils/colors/colors.dart';
import '../../utils/widgets/network.dart';
import '../home_module/first_card.dart';
import 'profile_bottom_sheet.dart';

class LoginBottomSheetContent extends StatefulWidget {
  const LoginBottomSheetContent({super.key});

  @override
  State<LoginBottomSheetContent> createState() =>
      _LoginBottomSheetContentState();
}

class _LoginBottomSheetContentState extends State<LoginBottomSheetContent> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool isPassword = true;
  bool rememberMe = false;

  @override
  void initState() {
    autofillCredentials(); // Autofill saved credentials on screen load
    super.initState();
  }

  Future<void> autofillCredentials() async {
    final savedCredentials = await Storage().getSavedCredentials();
    setState(() {
      _emailController.text = savedCredentials['email'] ?? '';
      _passwordController.text = savedCredentials['password'] ?? '';
      rememberMe = savedCredentials['email'] != null; // Remember Me checkbox
    });
  }

// Function to handle login
  void handleLogin(rememberMe) {
    if (rememberMe) {
      Storage()
          .saveCredentials(_emailController.text, _passwordController.text);
    } else {
      Storage().clearCredentials();
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> loginApiCalling() async {
    context.loaderOverlay.show();
    // Replace with your API endpoint
    const url = "${Network.baseUrl}auth/login";

    final Map<String, String> requestBody = {
      'email': _emailController.text.toString().trim(),
      'password': _passwordController.text.toString().trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 && mounted) {
        context.loaderOverlay.hide();
        final jsonResponse = jsonDecode(response.body);
        final apiResponse = LoginApiResponse.fromJson(jsonResponse);
        Storage().saveToken(apiResponse.token.toString());
        Storage().saveUserToPreferences(apiResponse.user!);
        debugPrint(
          'Registration successful: ${response.body}--${apiResponse.token.toString()}',
        );
        FocusScope.of(context).unfocus();
        Navigator.pop(context);
        if (apiResponse.user != null && apiResponse.user!.firstName == null) {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            isScrollControlled: true,
            useRootNavigator: false,
            isDismissible: false,
            builder: (context) => ProfileBottomSheet(),
          );
        } else if (apiResponse.user != null &&
            apiResponse.user!.cards != null &&
            apiResponse.user!.cards!.isNotEmpty) {
          Cards cardData = apiResponse.user!.cards![0];
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (builder) => FirstCardScreen(
                        cardData: cardData,
                      )));
        } else {
          Navigator.push(
              context,
              CupertinoPageRoute(
              builder: (builder) => const FirstCardScreen(),
            ),
          );
        }
      } else {
        context.loaderOverlay.hide();
        final responseData = ErrorModel.fromJson(
          json.decode(response.toString()),
        );

        Fluttertoast.showToast(
            msg: "Response: ${responseData.message}",
          toastLength: Toast.LENGTH_LONG,
        );
        debugPrint('Failed to register: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: "Email & Password does not match with our record.",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
        backgroundColor: Colors.grey,
      );
      final responseData = ErrorModel.fromJson(json.decode(e.toString()));

      Fluttertoast.showToast(
          msg: "Error: ${responseData.message}",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          backgroundColor: Colors.grey);

      debugPrint('Error: $e');
    }
  }

  Future<void> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = Platform.isAndroid
        ? GoogleSignIn(
            clientId: Network.googleKeyAndroid,
          )
        : GoogleSignIn(clientId: Network.googleKeyIOS);
    try {
      // Step 1: Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint("Google Sign-In canceled.");
        return;
      }

      debugPrint("email:${googleUser.email}\n id:${googleUser.id}");

      // Step 2: Obtain Google authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Extract the ID token
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        debugPrint("Failed to get ID Token.");
        return;
      }

      debugPrint("idToken$idToken");
      // Step 3: Send the token to your backend
      final response = await http.post(
        Uri.parse('${Network.baseUrl}oauth/google/login/callback'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'idToken': idToken, "email": googleUser.email.toString()}),
      );

      // Step 4: Handle the backend response
      if (response.statusCode == 200) {
        context.loaderOverlay.hide();
        final jsonResponse = jsonDecode(response.body);
        final apiResponse = LoginApiResponse.fromJson(jsonResponse);
        Storage().saveUserToPreferences(apiResponse.user!);
        Storage().saveToken(apiResponse.token);

        debugPrint('Registration successful: ${response.body}');
        FocusScope.of(context).unfocus();

        if (apiResponse.user != null && apiResponse.user!.firstName == null) {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            isScrollControlled: true,
            useRootNavigator: false,
            isDismissible: false,
            builder: (context) => ProfileBottomSheet(),
          );
        } else if (apiResponse.user != null &&
            apiResponse.user!.cards != null &&
            apiResponse.user!.cards!.isNotEmpty) {
          Cards cardData = apiResponse.user!.cards![0];
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (builder) => FirstCardScreen(
                        cardData: cardData,
                      )));
        } else {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (builder) => const FirstCardScreen()));
        }
      } else {
        context.loaderOverlay.hide();
        Fluttertoast.showToast(
            msg: "Response: ${response.body}", toastLength: Toast.LENGTH_LONG);
        debugPrint('Failed to register: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      debugPrint("Google Login Error: $e");
    }
  }

  Future<void> loginWithApple() async {
          Storage().removeTokenFromPreferences();

    try {
      // Step 1: Trigger Apple Sign-In
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Step 2: Obtain the authorization code and identity token
      final String? identityToken = appleCredential.identityToken;
      final String authorizationCode = appleCredential.authorizationCode;

      if (identityToken == null) {
        debugPrint("Failed to get tokens from Apple.");
        return;
      }
      debugPrint("identityToken => $identityToken");
      debugPrint("authorizationCode => $authorizationCode");
      debugPrint("email => ${appleCredential.email}");
      // Step 3: Send the tokens to your backend
      final response = await http.post(
        Uri.parse('${Network.baseUrl}oauth/apple/login/callback'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'identity_token': identityToken,
          'authorization_code': authorizationCode,
          'email': appleCredential.email,
        }),
      );

      // Step 4: Handle the backend response
      if (response.statusCode == 200) {
        context.loaderOverlay.hide();
        final jsonResponse = jsonDecode(response.body);
        final apiResponse = LoginApiResponse.fromJson(jsonResponse);
        Storage().saveUserToPreferences(apiResponse.user!);
        Storage().saveToken(apiResponse.token);

        debugPrint('Registration successful: ${response.body}');
        FocusScope.of(context).unfocus();

        if (apiResponse.user != null && apiResponse.user!.firstName == null) {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            isScrollControlled: true,
            useRootNavigator: false,
            isDismissible: false,
            builder: (context) => ProfileBottomSheet(),
          );
        } else if (apiResponse.user != null &&
            apiResponse.user!.cards != null &&
            apiResponse.user!.cards!.isNotEmpty) {
          Cards cardData = apiResponse.user!.cards![0];
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (builder) => FirstCardScreen(
                        cardData: cardData,
                      )));
        } else {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (builder) => const FirstCardScreen()));
        }
      } else {
        context.loaderOverlay.hide();
        Fluttertoast.showToast(
            msg: "Response: ${response.body}", toastLength: Toast.LENGTH_LONG);
        debugPrint('Failed to register: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      debugPrint("Apple Login Error: $e");
    }
  }

  // Email Validation
  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    // Regular expression for basic email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  bool validateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      // All validations passed

      return true;
    }
    return false;
  }

  bool validatePasswordRegx(String password) {
    String passwordPattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$';
    RegExp regex = RegExp(passwordPattern);
    return regex.hasMatch(password);
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? email, password;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context).translate('emailAddress')),
              const SizedBox(height: 4),

              TextFormField(
                validator: validateEmail,
                controller: _emailController,
                onSaved: (value) => email = value,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)
                      .translate('enterEmailAddress'),
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: Colors.white, width: 0),
                  ),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  alignLabelWithHint: true,
                  fillColor: ColoursUtils.background,
                  hintStyle: TextStyle(
                      color: ColoursUtils.greyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      "assets/images/mail-01.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Password Text Field
              Text(AppLocalizations.of(context).translate('password')),
              const SizedBox(height: 4),
              TextFormField(
                obscureText: isPassword,
                validator: validatePassword,
                controller: _passwordController,
                onSaved: (value) => password = value,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).translate('password'),
                  filled: true,
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    borderSide: BorderSide(color: Colors.white, width: 0),
                  ),
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(width: 0),
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  alignLabelWithHint: true,
                  fillColor: ColoursUtils.background,
                  hintStyle: TextStyle(
                      color: ColoursUtils.greyColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      "assets/images/lock-02.png",
                      width: 20,
                      height: 20,
                    ),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isPassword = !isPassword;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "assets/images/eye-off.png",
                        width: 20,
                        height: 20,
                      ),
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),

              const SizedBox(height: 10),
              // Remember me and Forgot password Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 12,
                      ),
                      SizedBox(
                          width: 14,
                          height: 14,
                          child: Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor: Colors.white,
                              ),
                              child: Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  side: const BorderSide(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  value: rememberMe,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      rememberMe = value ?? false;

                                      handleLogin(rememberMe);
                                    });
                                  }))),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            rememberMe = !rememberMe;
                            handleLogin(rememberMe);
                          });
                        },
                        child: Text(
                          AppLocalizations.of(context).translate('rememberMe'),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Forgot password logic
                      showForgotPasswordBottomSheet(context);
                      debugPrint('Forgot password clicked');
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('forgotPassword'),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Utils().primaryButton(
                  onClick: () {
                    if (validateForm()) {
                      if (validatePasswordRegx(
                          _passwordController.text.toString())) {
                        debugPrint("Password is valid.");
                        loginApiCalling();
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Password is invalid. It must include uppercase, lowercase, digits, and special characters.",
                            toastLength: Toast.LENGTH_LONG,
                            textColor: Colors.white,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.grey);
                        print(
                            "Password is invalid. It must include uppercase, lowercase, digits, and special characters.");
                      }
                    }
                  },
                  text: AppLocalizations.of(context).translate('login')),
              const SizedBox(height: 12),

              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Or',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Login with Google Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        debugPrint("Login with Google pressed");
                        await loginWithGoogle();
                      },
                      icon: Image.asset(
                        "assets/images/fi_281764.png",
                        height: 14,
                        width: 14,
                      ),
                      label: Text(
                        AppLocalizations.of(context).translate('SignInGoogle'),
                        softWrap: true,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w400),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Colors.grey), // Outline color for Google
                        minimumSize: const Size(
                            double.infinity, 40), // Full-width button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Login with Apple Button
                  if (Platform.isIOS)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                           await loginWithApple();
                          debugPrint("Login with Apple pressed");
                        },
                        icon: const Icon(Icons.apple,
                            size: 18, color: Colors.black),
                        label: Text(
                          AppLocalizations.of(context).translate('SignInApple'),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w400),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.grey), // Outline color for Apple
                          minimumSize: const Size(
                              double.infinity, 40), // Full-width button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

// To show the bottom sheet
  void showForgotPasswordBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ForgotPasswordBottomSheet(),
      ),
    );
  }
}

class ForgotPasswordBottomSheet extends StatefulWidget {
  const ForgotPasswordBottomSheet({super.key});

  @override
  State<ForgotPasswordBottomSheet> createState() =>
      _ForgotPasswordBottomSheetState();
}

class _ForgotPasswordBottomSheetState extends State<ForgotPasswordBottomSheet> {
  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Forgot Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Enter email address',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                loginApiForgotPasswordCalling(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loginApiForgotPasswordCalling(context) async {
    const url =
        "${Network.baseUrl}auth/forgot-password"; // Replace with your API endpoint

    final Map<String, String> requestBody = {
      'email': _emailController.text.toString().trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "A mail was sent to you to update your password.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white);
        _emailController.clear();
        Navigator.pop(context);
      } else {
        final responseData = ErrorModel.fromJson(
          json.decode(response.toString()),
        );
        Fluttertoast.showToast(
            msg: "Response: ${responseData.message}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.grey,
            textColor: Colors.white);
        debugPrint('Failed to register: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}
