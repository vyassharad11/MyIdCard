import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';

import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../models/registration_otp_model.dart';
import '../../utils/widgets/button_primary.dart';
import '../../utils/widgets/network.dart';
import 'profile_bottom_sheet.dart';
import 'welcome_screen.dart';

class EmailVerificationBottomSheet extends StatefulWidget {
  final String email, token;

  const EmailVerificationBottomSheet(
      {super.key, required this.email, required this.token});
  @override
  _EmailVerificationBottomSheetState createState() =>
      _EmailVerificationBottomSheetState();
}

class _EmailVerificationBottomSheetState
    extends State<EmailVerificationBottomSheet> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> otpRegisterApiCalling() async {
    context.loaderOverlay.show();
    const url =
        "${Network.baseUrl}auth/verify-code"; // Replace with your API endpoint

    final Map<String, String> requestBody = {
      'email': widget.email.toString(),
      'email_verification_code': _otpController.text.toString().trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        FocusManager.instance.primaryFocus?.unfocus();

        context.loaderOverlay.hide();
        final jsonResponse = jsonDecode(response.body);
        final apiResponse = RegistrationApiResponse.fromJson(jsonResponse);
        Storage().saveUserToPreferences(apiResponse.user);
        Storage().saveToken(widget.token.toString());
        debugPrint('Registration successful: ${response.body}');
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          isDismissible: false,
          isScrollControlled: true,
          builder: (context) => ProfileBottomSheet(),
        );
        // Navigator.push(context,
        //     CupertinoPageRoute(builder: (builder) => BottomNavBarExample()));
      } else {
        context.loaderOverlay.hide();
        Fluttertoast.showToast(
            msg: "The selected email verification code is invalid.",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.white,
            backgroundColor: Colors.grey);
        debugPrint('Failed to register: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: "The selected email verification code is invalid.",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          backgroundColor: Colors.grey);

      debugPrint('Error: $e');
    }
  }

  Future<void> otpResendApiCalling() async {
    context.loaderOverlay.show();
    const url =
        "${Network.baseUrl}auth/resend-verify-code"; // Replace with your API endpoint

    final Map<String, String> requestBody = {
      'email': widget.email.toString(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        FocusManager.instance.primaryFocus?.unfocus();

        context.loaderOverlay.hide();
        Fluttertoast.showToast(
            msg: "Verification code send successfully",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.white,
            backgroundColor: Colors.green);
      } else {
        context.loaderOverlay.hide();
        Fluttertoast.showToast(
            msg: "The selected email verification code is invalid.",
            toastLength: Toast.LENGTH_LONG,
            textColor: Colors.white,
            backgroundColor: Colors.grey);
        debugPrint('Failed to register: ${response.statusCode}');
        debugPrint('Response: ${response.body}');
      }
    } catch (e) {
      context.loaderOverlay.hide();
      Fluttertoast.showToast(
          msg: "The selected email verification code is invalid.",
          toastLength: Toast.LENGTH_LONG,
          textColor: Colors.white,
          backgroundColor: Colors.grey);

      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom:
              MediaQuery.of(context).viewInsets.bottom, // for keyboard handling
        ),
        child: Wrap(
          children: [
            // Title and Description
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)
                          .translate('EmailVerification'),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(children: [
                      TextSpan(
                        text: AppLocalizations.of(context)
                            .translate('wearedetect'),
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      TextSpan(
                        text: widget.email.toString(),
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Close the bottom sheet

                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              isScrollControlled:
                                  true, // To allow full height usage
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                  ),
                                  child: LoginSignUpBottomSheetContent(),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Image.asset(
                              "assets/images/edit-05.png",
                              width: 14,
                              height: 14,
                            ),
                          ),
                        ),
                      ),
                    ]),
                    // Image.asset("assets/images/edit-05.png"),
                  ),
                ],
              ),
            ),

            // OTP Field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context).translate('enterPassword')),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _otpController,
                    autocorrect: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText:
                          AppLocalizations.of(context).translate('EnterOTP'),
                      hintStyle: TextStyle(
                          color: Colors.grey.shade50,
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Utils().primaryButton(
                      onClick: () {
                        if (_otpController.text.isNotEmpty) {
                          otpRegisterApiCalling();
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please enter otp",
                              toastLength: Toast.LENGTH_LONG);
                        }
                      },
                      text: "Submit"),

                  // Submit Button
                ],
              ),
            ),
            // Resend OTP
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('didnt'),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800]),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Logic to resend OTP
                      if (widget.email.isNotEmpty) {
                        otpResendApiCalling();
                      } else {
                        Fluttertoast.showToast(
                            msg: "Email id not valid",
                            toastLength: Toast.LENGTH_LONG);
                      }
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('resend'),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
