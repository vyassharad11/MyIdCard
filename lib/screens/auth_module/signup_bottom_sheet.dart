import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../models/error_mdodel.dart';
import '../../models/login_api_reponse.dart';
import '../../utils/colors/colors.dart';
import '../../utils/widgets/button_primary.dart';
import '../../utils/widgets/network.dart';
import '../home_module/first_card.dart';
import '../home_module/main_home_page.dart';
import 'otp_bottom_sheet.dart';

class SignUpBottomSheetContent extends StatefulWidget {
  const SignUpBottomSheetContent({super.key});

  @override
  State<SignUpBottomSheetContent> createState() =>
      _SignUpBottomSheetContentState();
}

class _SignUpBottomSheetContentState extends State<SignUpBottomSheetContent> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool passord = true, iscConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password, name;
  String? confirmPassword;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool validatePasswordRegx(String password) {
    String passwordPattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,16}$';
    RegExp regex = RegExp(passwordPattern);
    return regex.hasMatch(password);
  }

  Future<void> registerVendor() async {
    context.loaderOverlay.show();
    const url =
        "${Network.baseUrl}auth/signup"; // Replace with your API endpoint
    try {
      var headers = {'Accept': 'application/json'};
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.fields.addAll({
        'language_id': '1',
        'email': _emailController.text.toString().trim(),
        'password': _passwordController.text.toString().trim(),
        'password_confirmation': _passwordController.text.toString().trim(),
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        context.loaderOverlay.hide();

        final responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);
        var tokenDara = data['token'];
        Storage().saveToken(tokenDara);
        Navigator.pop(context);

        debugPrint('Registration successful: $data');
        // final jsonResponse = jsonDecode(response.body);
        // final apiResponse = LoginApiResponse.fromJson(jsonResponse);
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          isScrollControlled: true,
          builder: (context) => EmailVerificationBottomSheet(
            email: _emailController.text,
            token: tokenDara ?? "",
          ),
        );
      } else {
        context.loaderOverlay.hide();

        final responseData =
            ErrorModel.fromJson(json.decode(response.toString()));

        Fluttertoast.showToast(
            msg: responseData.message.toString(),
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.white,
            backgroundColor: Colors.grey);

        debugPrint('Failed to register: ${response.statusCode}');
        debugPrint('Response: $response');
      }
    } catch (e) {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: "This email is already registered. Please Sign In",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          backgroundColor: Colors.grey);
      debugPrint('Error: $e');
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

// Password Validation
  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

// Confirm Password Validation
  String? validateConfirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }
    if (_confirmPasswordController.text != _passwordController.text) {
      return 'Password and confirm password do not match';
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

  Future<void> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = Platform.isAndroid
        ? GoogleSignIn(
            serverClientId: Network.googleKeyAndroid,
          )
        : GoogleSignIn(clientId: Network.googleKeyIOS);
    try {
      // Step 1: Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint("Google Sign-In canceled.");
        return;
      }

      // Step 2: Obtain Google authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Extract the ID token
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        debugPrint("Failed to get ID Token.");
        return;
      }

      // Step 3: Send the token to your backend
      final response = await http.post(
        Uri.parse('${Network.baseUrl}oauth/google/login/callback'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'idToken': idToken}),
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
        Navigator.pop(context);
        if (apiResponse.user != null && apiResponse.user!.firstName == null) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (builder) => BottomNavBarExample()));
        } else {
          Navigator.push(context,
              CupertinoPageRoute(builder: (builder) => FirstCardScreen()));
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

      // Step 3: Send the tokens to your backend
      final response = await http.post(
        Uri.parse('${Network.baseUrl}oauth/apple/login/callback'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'identityToken': identityToken,
          'authorizationCode': authorizationCode,
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
        Navigator.pop(context);
        if (apiResponse.user != null && apiResponse.user!.firstName == null) {
          Navigator.push(context,
              CupertinoPageRoute(builder: (builder) => BottomNavBarExample()));
        } else {
          Navigator.push(context,
              CupertinoPageRoute(builder: (builder) => FirstCardScreen()));
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 25.0),
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
                obscureText: passord,
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
                        passord = !passord;
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

              const SizedBox(height: 12),
              Text(AppLocalizations.of(context).translate('Confirmpassword')),
              const SizedBox(height: 4),

              TextFormField(
                obscureText: iscConfirmPassword,
                controller: _confirmPasswordController,
                onSaved: (value) => confirmPassword = value,
                validator: (value) => validateConfirmPassword(value, password),
                decoration: InputDecoration(
                  hintText:
                      AppLocalizations.of(context).translate('Confirmpassword'),
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
                        iscConfirmPassword = !iscConfirmPassword;
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

              const SizedBox(height: 8),

              Utils().primaryButton(
                  onClick: () {
                    if (validateForm()) {
                      if (validatePasswordRegx(
                          _passwordController.text.toString())) {
                        debugPrint("Password is valid.");
                        registerVendor();
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Password is invalid. It must include uppercase, lowercase, digits, and special characters.",
                            toastLength: Toast.LENGTH_LONG,
                            textColor: Colors.white,
                            backgroundColor: Colors.grey);
                        print(
                            "Password is invalid. It must include uppercase, lowercase, digits, and special characters.");
                      }
                    }
                  },
                  text: "Next"),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Or',
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey[300],
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
                      onPressed: () {
                        loginWithGoogle();
                        debugPrint("Login with Google pressed");
                      },
                      icon: Image.asset(
                        "assets/images/fi_281764.png",
                        height: 14,
                        width: 14,
                      ),
                      label: Text(
                        AppLocalizations.of(context).translate('SignOnGoogle'),
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
                  const SizedBox(width: 6),
                  // Login with Apple Button
                  if (Platform.isIOS)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          loginWithApple();
                          debugPrint("Login with Apple pressed");
                        },
                        icon: const Icon(Icons.apple,
                            size: 18, color: Colors.black),
                        label: Text(
                          AppLocalizations.of(context).translate('SignOnApple'),
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
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
