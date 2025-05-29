import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:my_di_card/data/repository/auth_repository.dart';
import 'package:my_di_card/models/login_dto.dart';

import '../../bloc/api_resp_state.dart';
import '../../bloc/cubit/auth_cubit.dart';
import '../../language/app_localizations.dart';
import '../../localStorage/storage.dart';
import '../../models/registration_otp_model.dart';
import '../../models/utility_dto.dart';
import '../../utils/constant.dart';
import '../../utils/utility.dart';
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
  AuthCubit? _otpRegisterCubit,_otpResendApi;

  @override
  void initState() {
    _otpRegisterCubit = AuthCubit(AuthRepository());
    _otpResendApi = AuthCubit(AuthRepository());
    super.initState();
  }

  @override
  void dispose() {
    _otpRegisterCubit?.isClosed;
    _otpResendApi?.isClosed;
    _otpRegisterCubit = null;
    _otpResendApi = null;
    _otpController.dispose();
    super.dispose();
  }


  Future<void> otpRegisterApiCalling() async {
    Utility.showLoader(context);
    Map<String, dynamic> data = {
      'email': widget.email.toString(),
      'email_verification_code': _otpController.text.toString().trim(),
    };
    _otpRegisterCubit?.otpRegisterApi(data);
  }

  Future<void> otpResendApi() async {
    Utility.showLoader(context);
    Map<String, dynamic> data = {
      'email': widget.email.toString(),
    };
    _otpResendApi?.otpResendApi(data);
  }




  @override
  Widget build(BuildContext context) {
    return  MultiBlocListener(
      listeners: [
       BlocListener<AuthCubit, ResponseState>(
        bloc: _otpRegisterCubit,
        listener: (context, state) {
          if (state is ResponseStateLoading) {
          }
          else if (state is ResponseStateEmpty) {
            Utility.hideLoader(context);
            Utility().showFlushBar(context: context, message: state.message,isError: true);
          } else if (state is ResponseStateNoInternet) {
             Utility.hideLoader(context);
             Utility().showFlushBar(context: context, message: state.message,isError: true);
          } else if (state is ResponseStateError) {
             Utility.hideLoader(context);
             Utility().showFlushBar(context: context, message: state.errorMessage,isError: true);
          } else if (state is ResponseStateSuccess) {
             Utility.hideLoader(context);
            var dto = state.data as LoginDto;
            if (dto.user != null) {
              Storage().saveUserToPreferences(dto.user!);
            }
            // Storage().saveToken(widget.token.toString());
             Storage().saveToken(dto.token ?? "");

             showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              isDismissible: false,
              isScrollControlled: true,
               enableDrag: false,
               builder: (context) => ProfileBottomSheet(),
            );

          }
          setState(() {});
        },),BlocListener<AuthCubit, ResponseState>(
        bloc: _otpResendApi,
        listener: (context, state) {
          if (state is ResponseStateLoading) {
          }
          else if (state is ResponseStateEmpty) {
          } else if (state is ResponseStateNoInternet) {
             Utility.hideLoader(context);
          } else if (state is ResponseStateError) {
             Utility.hideLoader(context);
          } else if (state is ResponseStateSuccess) {
             Utility.hideLoader(context);
            var dto = state.data as UtilityDto;
          }
          setState(() {});
        },),
        ],child:
         SingleChildScrollView(
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
                              TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: Constants.fontFamily),
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
                                  enableDrag: false,
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
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Logic to resend OTP
                            if (widget.email.isNotEmpty) {
                              otpResendApi();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Email id not valid",
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          },
                          child: Text(
                            AppLocalizations.of(context).translate('resend'),
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
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
      );
  }
}
